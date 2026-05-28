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

typedef struct {
    vec_f32 v;
} Vec4f32;

Vec4f32 vec4f_new(float x, float y, float z, float w) {
    Vec4f32 r;
#if defined(__ARM_NEON) || defined(__aarch64__)
    r.v = (float32x4_t){x, y, z, w};
#elif defined(__SSE__) || defined(__x86_64__)
    r.v = _mm_set_ps(w, z, y, x);
#else
    r.v.f[0] = x; r.v.f[1] = y; r.v.f[2] = z; r.v.f[3] = w;
#endif
    return r;
}

Vec4f32 vec4f_add(Vec4f32 a, Vec4f32 b) {
    Vec4f32 r;
#if defined(__ARM_NEON) || defined(__aarch64__)
    r.v = vaddq_f32(a.v, b.v);
#elif defined(__SSE__) || defined(__x86_64__)
    r.v = _mm_add_ps(a.v, b.v);
#else
    r.v.f[0] = a.v.f[0] + b.v.f[0];
    r.v.f[1] = a.v.f[1] + b.v.f[1];
    r.v.f[2] = a.v.f[2] + b.v.f[2];
    r.v.f[3] = a.v.f[3] + b.v.f[3];
#endif
    return r;
}

float vec4f_get_x(Vec4f32 a) {
#if defined(__ARM_NEON) || defined(__aarch64__)
    return vgetq_lane_f32(a.v, 0);
#elif defined(__SSE__) || defined(__x86_64__)
    return _mm_cvtss_f32(a.v);
#else
    return a.v.f[0];
#endif
}

float vec4f_get_y(Vec4f32 a) {
#if defined(__ARM_NEON) || defined(__aarch64__)
    return vgetq_lane_f32(a.v, 1);
#elif defined(__SSE__) || defined(__x86_64__)
    return _mm_cvtss_f32(_mm_shuffle_ps(a.v, a.v, _MM_SHUFFLE(1, 1, 1, 1)));
#else
    return a.v.f[1];
#endif
}

float vec4f_get_z(Vec4f32 a) {
#if defined(__ARM_NEON) || defined(__aarch64__)
    return vgetq_lane_f32(a.v, 2);
#elif defined(__SSE__) || defined(__x86_64__)
    return _mm_cvtss_f32(_mm_shuffle_ps(a.v, a.v, _MM_SHUFFLE(2, 2, 2, 2)));
#else
    return a.v.f[2];
#endif
}

float vec4f_get_w(Vec4f32 a) {
#if defined(__ARM_NEON) || defined(__aarch64__)
    return vgetq_lane_f32(a.v, 3);
#elif defined(__SSE__) || defined(__x86_64__)
    return _mm_cvtss_f32(_mm_shuffle_ps(a.v, a.v, _MM_SHUFFLE(3, 3, 3, 3)));
#else
    return a.v.f[3];
#endif
}

void vec4f_add_bulk(float* out, const float* a, const float* b, int count) {
    int total_floats = count * 4;
#if defined(__ARM_NEON) || defined(__aarch64__)
    for (int i = 0; i < total_floats; i += 4) {
        float32x4_t va = vld1q_f32(&a[i]);
        float32x4_t vb = vld1q_f32(&b[i]);
        vst1q_f32(&out[i], vaddq_f32(va, vb));
    }
#elif defined(__SSE__) || defined(__x86_64__)
    for (int i = 0; i < total_floats; i += 4) {
        __m128 va = _mm_loadu_ps(&a[i]);
        __m128 vb = _mm_loadu_ps(&b[i]);
        _mm_storeu_ps(&out[i], _mm_add_ps(va, vb));
    }
#else
    for (int i = 0; i < total_floats; i++) {
        out[i] = a[i] + b[i];
    }
#endif
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
