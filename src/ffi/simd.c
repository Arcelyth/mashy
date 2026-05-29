#include <stdint.h>

#if defined(__ARM_NEON) || defined(__aarch64__)
    #include <arm_neon.h>
    typedef float32x4_t vec_f32;
    typedef int32x4_t vec_i32;
    typedef uint32x4_t vec_u32;
    typedef uint8x16_t vec_u8;
#elif defined(__SSE__) || defined(__x86_64__)
    #include <immintrin.h>
    typedef __m128 vec_f32;
    typedef __m128i vec_i32;
    typedef __m128i vec_u32;
    typedef __m128i vec_u8;
#else
    typedef struct { float f[4]; } vec_f32;
#endif

#if defined(_MSC_VER)
    #define ALIGN_PRE(x) __declspec(align(x))
    #define ALIGN_POST(x)
#elif defined(__GNUC__) || defined(__clang__)
    #define ALIGN_PRE(x)
    #define ALIGN_POST(x) __attribute__((aligned(x)))
#else
    #define ALIGN_PRE(x) _Alignas(x)
    #define ALIGN_POST(x)
#endif

typedef ALIGN_PRE(16) union {
    vec_f32 v;
    float f[4];
    struct {
        float x, y, z, w;
    };
} ALIGN_POST(16) Vec4f32;

typedef ALIGN_PRE(16) union { vec_i32 v; int32_t i[4]; } ALIGN_POST(16) Vec4i32;
typedef ALIGN_PRE(16) union { vec_u32 v; uint32_t u[4]; } ALIGN_POST(16) Vec4u32;
typedef ALIGN_PRE(16) union { vec_u8 v; uint8_t b[16]; } ALIGN_POST(16) Vec4u8;

#define VEC_RING_SIZE 512
static Vec4f32 vec_ring[VEC_RING_SIZE];
static int vec_ring_idx = 0;

inline static Vec4f32* alloc_ring_slot(void) {
    Vec4f32* ptr = &vec_ring[vec_ring_idx];
    vec_ring_idx = (vec_ring_idx + 1) & (VEC_RING_SIZE - 1);
    return ptr;
}

Vec4f32* vec4f_new(float x, float y, float z, float w) {
    Vec4f32* r = alloc_ring_slot();
#if defined(__ARM_NEON) || defined(__aarch64__)
    r->v = (float32x4_t){x, y, z, w};
#elif defined(__SSE__) || defined(__x86_64__)
    r->v = _mm_set_ps(w, z, y, x);
#else
    r->f[0] = x; r->f[1] = y; r->f[2] = z; r->f[3] = w;
#endif
    return r;
}

Vec4f32* vec4f_add(const Vec4f32* a, const Vec4f32* b) {
    Vec4f32* r = alloc_ring_slot();
#if defined(__ARM_NEON) || defined(__aarch64__)
    r->v = vaddq_f32(a->v, b->v);
#elif defined(__SSE__) || defined(__x86_64__)
    r->v = _mm_add_ps(a->v, b->v);
#else
    r->f[0] = a->f[0] + b->f[0];
    r->f[1] = a->f[1] + b->f[1];
    r->f[2] = a->f[2] + b->f[2];
    r->f[3] = a->f[3] + b->f[3];
#endif
    return r;
}

Vec4f32* vec4f_sub(const Vec4f32* a, const Vec4f32* b) {
    Vec4f32* r = alloc_ring_slot();
#if defined(__ARM_NEON) || defined(__aarch64__)
    r->v = vsubq_f32(a->v, b->v);
#elif defined(__SSE__) || defined(__x86_64__)
    r->v = _mm_sub_ps(a->v, b->v);
#else
    r->f[0] = a->f[0] - b->f[0];
    r->f[1] = a->f[1] - b->f[1];
    r->f[2] = a->f[2] - b->f[2];
    r->f[3] = a->f[3] - b->f[3];
#endif
    return r;
}

Vec4f32* vec4f_mul(const Vec4f32* a, const Vec4f32* b) {
    Vec4f32* r = alloc_ring_slot();
#if defined(__ARM_NEON) || defined(__aarch64__)
    r->v = vmulq_f32(a->v, b->v);
#elif defined(__SSE__) || defined(__x86_64__)
    r->v = _mm_mul_ps(a->v, b->v);
#else
    r->f[0] = a->f[0] * b->f[0];
    r->f[1] = a->f[1] * b->f[1];
    r->f[2] = a->f[2] * b->f[2];
    r->f[3] = a->f[3] * b->f[3];
#endif
    return r;
}

Vec4f32* vec4f_div(const Vec4f32* a, const Vec4f32* b) {
    Vec4f32* r = alloc_ring_slot();
#if defined(__ARM_NEON) || defined(__aarch64__)
    r->v = vdivq_f32(a->v, b->v);
#elif defined(__SSE__) || defined(__x86_64__)
    r->v = _mm_div_ps(a->v, b->v);
#else
    r->f[0] = a->f[0] / b->f[0];
    r->f[1] = a->f[1] / b->f[1];
    r->f[2] = a->f[2] / b->f[2];
    r->f[3] = a->f[3] / b->f[3];
#endif
    return r;
}

float vec4f_dot(const Vec4f32* a, const Vec4f32* b) {
#if defined(__aarch64__)
    return vaddvq_f32(vmulq_f32(a->v, b->v));
#elif defined(__ARM_NEON)
    float32x4_t mul = vmulq_f32(a->v, b->v);
    float f[4];
    vst1q_f32(f, mul);
    return f[0] + f[1] + f[2] + f[3];
#elif defined(__SSE__) || defined(__x86_64__)
    __m128 mul = _mm_mul_ps(a->v, b->v);
    __m128 shuf = _mm_shuffle_ps(mul, mul, _MM_SHUFFLE(2, 3, 0, 1));
    __m128 sums = _mm_add_ps(mul, shuf);
    shuf = _mm_movehl_ps(shuf, sums);
    sums = _mm_add_ss(sums, shuf);
    return _mm_cvtss_f32(sums);
#else
    return (a->f[0] * b->f[0]) + (a->f[1] * b->f[1]) + (a->f[2] * b->f[2]) + (a->f[3] * b->f[3]);
#endif
}

void vec4f_add_bulk(float* out, const float* a, const float* b, int count) {
    int32_t i = 0;
#if defined(__ARM_NEON) || defined(__aarch64__)
    int32_t end4 = count & ~3;
    for (; i < end4; i += 4) vst1q_f32(out + i, vaddq_f32(vld1q_f32(a + i), vld1q_f32(b + i)));
#elif defined(__SSE__) || defined(__x86_64__)
    int32_t end4 = count & ~3;
    for (; i < end4; i += 4) _mm_storeu_ps(out + i, _mm_add_ps(_mm_loadu_ps(a + i), _mm_loadu_ps(b + i)));
#else
    for (; i < count; i++) out[i] = a[i] + b[i];
#endif
}

void vec4f_sub_bulk(float* out, const float* a, const float* b, int count) {
    int32_t i = 0;
#if defined(__ARM_NEON) || defined(__aarch64__)
    int32_t end4 = count & ~3;
    for (; i < end4; i += 4) vst1q_f32(out + i, vsubq_f32(vld1q_f32(a + i), vld1q_f32(b + i)));
#elif defined(__SSE__) || defined(__x86_64__)
    int32_t end4 = count & ~3;
    for (; i < end4; i += 4) _mm_storeu_ps(out + i, _mm_sub_ps(_mm_loadu_ps(a + i), _mm_loadu_ps(b + i)));
#endif
    for (; i < count; i++) out[i] = a[i] - b[i];
}

void vec4f_mul_bulk(float* out, const float* a, const float* b, int count) {
    int32_t i = 0;
#if defined(__ARM_NEON) || defined(__aarch64__)
    int32_t end4 = count & ~3;
    for (; i < end4; i += 4) vst1q_f32(out + i, vmulq_f32(vld1q_f32(a + i), vld1q_f32(b + i)));
#elif defined(__SSE__) || defined(__x86_64__)
    int32_t end4 = count & ~3;
    for (; i < end4; i += 4) _mm_storeu_ps(out + i, _mm_mul_ps(_mm_loadu_ps(a + i), _mm_loadu_ps(b + i)));
#endif
    for (; i < count; i++) out[i] = a[i] * b[i];
}

void vec4f_div_bulk(float* out, const float* a, const float* b, int count) {
    int32_t i = 0;
#if defined(__ARM_NEON) || defined(__aarch64__)
    int32_t end4 = count & ~3;
    for (; i < end4; i += 4) vst1q_f32(out + i, vdivq_f32(vld1q_f32(a + i), vld1q_f32(b + i)));
#elif defined(__SSE__) || defined(__x86_64__)
    int32_t end4 = count & ~3;
    for (; i < end4; i += 4) _mm_storeu_ps(out + i, _mm_div_ps(_mm_loadu_ps(a + i), _mm_loadu_ps(b + i)));
#endif
    for (; i < count; i++) out[i] = a[i] / b[i];
}

void vec4f_dot_bulk(float* out, const float* a, const float* b, int count) {
    int vec_count = count / 4;
    for (int j = 0; j < vec_count; j++) {
        int i = j * 4;
#if defined(__aarch64__)
        out[j] = vaddvq_f32(vmulq_f32(vld1q_f32(a + i), vld1q_f32(b + i)));
#elif defined(__ARM_NEON)
        float32x4_t m = vmulq_f32(vld1q_f32(a + i), vld1q_f32(b + i));
        float f[4]; vst1q_f32(f, m); out[j] = f[0]+f[1]+f[2]+f[3];
#elif defined(__SSE__) || defined(__x86_64__)
        __m128 mul = _mm_mul_ps(_mm_loadu_ps(a + i), _mm_loadu_ps(b + i));
        __m128 shuf = _mm_shuffle_ps(mul, mul, _MM_SHUFFLE(2, 3, 0, 1));
        __m128 sums = _mm_add_ps(mul, shuf);
        shuf = _mm_movehl_ps(shuf, sums);
        sums = _mm_add_ss(sums, shuf);
        out[j] = _mm_cvtss_f32(sums);
#else
        out[j] = (a[i]*b[i]) + (a[i+1]*b[i+1]) + (a[i+2]*b[i+2]) + (a[i+3]*b[i+3]);
#endif
    }
}

float vec4f_get_x(const Vec4f32* a) {
    return a->f[0];
}

float vec4f_get_y(const Vec4f32* a) {
    return a->f[1];
}

float vec4f_get_z(const Vec4f32* a) {
    return a->f[2];
}

float vec4f_get_w(const Vec4f32* a) {
    return a->f[3];
}

int get_arch_info(void) {
#if defined(__ARM_NEON) || defined(__aarch64__)
    return 1; // neon
#elif defined(__SSE__) || defined(__x86_64__)
    return 2; // sse
#else
    return 0; // none
#endif
}


