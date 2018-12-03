

// which channel of the texture holds SDF data
#define SAMPLE_SDF(tex, uv) tex2D(tex, uv).r

// we may want to try multiple functions
//#define SMOOTHSTEP(a, b, x) smoothstep(a, b, x)
#define SMOOTHSTEP(a, b, x) (1.0 / (1.0 + exp(-(a * 12.0) * (x - (b * 2)))))

// utils for readability
#define MIN_FLOAT4(x) min(x.r, min(x.g, min(x.b, x.a)))
#define MAX_FLOAT4(x) max(x.r, max(x.g, max(x.b, x.a)))
