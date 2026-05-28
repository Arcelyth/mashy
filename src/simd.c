#include <stdint.h>

#if defined(__ARM_NEON) || defined(__aarch64__)
    #include <arm_neon.h>
    typedef float32x4_t Vec4f;
    typedef int32x4_t vec_i32;
    typedef uint32x4_t vec_u32;
    typedef uint8x16_t vec_u8;
#elif defined(__SSE__) || defined(__x86_64__)
    #include <immintrin.h>
    typedef __m128 Vec4f;
    typedef __m128i vec_i32;
    typedef __m128i vec_u32;
    typedef __m128i vec_u8;
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
    float f[4];
    Vec4f v;
} ALIGN_POST(16) Vec4f32Cast;

typedef ALIGN_PRE(16) union {
    int32_t i[4];
    vec_i32 v;
} ALIGN_POST(16) Vec4i32Cast;

typedef ALIGN_PRE(16) union {
    uint32_t u[4];
    vec_u32 v;
} ALIGN_POST(16) Vec4u32Cast;

typedef ALIGN_PRE(16) union {
    uint8_t u[16];
    vec_u8 v;
} ALIGN_POST(16) Vec4u8Cast;

void new_vec4f32(Vec4f32Cast* out, float x, float y, float z, float w) {
    out->f[0] = x;
    out->f[1] = y;
    out->f[2] = z;
    out->f[3] = w;
}

void vec4f_add(Vec4f32Cast* out, const Vec4f32Cast* a, const Vec4f32Cast* b) {
#if defined(__ARM_NEON) || defined(__aarch64__)
    out->v = vaddq_f32(a->v, b->v);
#elif defined(__SSE__) || defined(__x86_64__)
    out->v = _mm_add_ps(a->v, b->v);
#else
    for(int i = 0; i < 4; i++) out->f[i] = a->f[i] + b->f[i];
#endif
}

float vec4f_get_x(const Vec4f32Cast* v) { return v->f[0]; }
float vec4f_get_y(const Vec4f32Cast* v) { return v->f[1]; }
float vec4f_get_z(const Vec4f32Cast* v) { return v->f[2]; }
float vec4f_get_w(const Vec4f32Cast* v) { return v->f[3]; }

