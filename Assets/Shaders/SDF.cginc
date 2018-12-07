
// which channel of the texture holds SDF data
#define SAMPLE_SDF(tex, uv) (tex2D(tex, uv).r)

// we may want to try multiple functions
#define SMOOTHSTEP(a, b, x) smoothstep(a, b, x)
//#define SMOOTHSTEP(a, b, x) (1.0 / (1.0 + exp(-(a * 24.0) * (x - (b * 2)))))

// utils for readability
#define MIN_FLOAT4(x) (min(x.r, min(x.g, min(x.b, x.a))))
#define MAX_FLOAT4(x) (max(x.r, max(x.g, max(x.b, x.a))))

// Texel coordinates Jacobian
#define JACOBIAN(uv) (transpose( float2x2( ddx(uv), ddy(uv) ) ))

// Uniforms
sampler2D _MainTex;
float4 _MainTex_ST;

float _Threshold;
float _Smoothness;

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
};

struct v2f
{
    float2 uv : TEXCOORD0;
    UNITY_FOG_COORDS(1)
    float4 vertex : SV_POSITION;
};

// Vertex shader, nothing special here
v2f vert (appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    return o;
}

float sdf(float2 uv)
{
    float sdfValue = (SAMPLE_SDF(_MainTex, uv) - _Threshold) / (1. - _Threshold);
    float2 sdfGrad = float2(ddx(sdfValue), ddy(sdfValue));
    float afwidth = _Smoothness * length(sdfGrad);
    return smoothstep(-afwidth, afwidth, sdfValue); 
}
	
#if SDF_DEFAULT
fixed4 frag (v2f i) : SV_Target
{
    return sdf(i.uv);
}
#elif SDF_SUPERSAMPLE
fixed4 frag (v2f i) : SV_Target
{
    float2x2 J = JACOBIAN(i.uv);
    
    return 0.25 * (
        sdf(i.uv + mul(J, float2( 1, 1) * 0.25)) + 
        sdf(i.uv + mul(J, float2( 1,-1) * 0.25)) +
        sdf(i.uv + mul(J, float2(-1, 1) * 0.25)) +
        sdf(i.uv + mul(J, float2(-1,-1) * 0.25)));
}
#elif SDF_SUBPIXEL
fixed4 frag (v2f i) : SV_Target
{
    float2x2 J = JACOBIAN(i.uv);
    
    float R = sdf(i.uv + mul(J, float2(-0.333, 0)));
    float G = sdf(i.uv);
    float B = sdf(i.uv + mul(J, float2( 0.333, 0)));
    
    return fixed4(R, G, B, (R + G + B) / 3.);
}
#elif SDF_SUBPIXEL_DX
fixed4 frag (v2f i) : SV_Target
{
    float sdfValue = (SAMPLE_SDF(_MainTex, i.uv) - _Threshold) / (1. - _Threshold);
    float2 sdfGrad = float2(ddx(sdfValue), ddy(sdfValue));
    float afwidth = _Smoothness * length(sdfGrad);
    
    float R = smoothstep(-afwidth, afwidth, sdfValue - sdfGrad.x / 3.);
    float G = smoothstep(-afwidth, afwidth, sdfValue);
    float B = smoothstep(-afwidth, afwidth, sdfValue + sdfGrad.x / 3.);

    return fixed4(R, G, B, (R + G + B) / 3.);
}
#elif SDF_SUPERSAMPLE_SUBPIXEL
fixed4 frag (v2f i) : SV_Target
{
    float2x2 J = JACOBIAN(i.uv);
    
    float R =   sdf(i.uv + mul(J, float2(-2.5 / 6.0, 0))) + 
                sdf(i.uv + mul(J, float2(-1.5 / 6.0, 0)));

    float G =   sdf(i.uv + mul(J, float2(-0.5 / 6.0, 0))) + 
                sdf(i.uv + mul(J, float2( 0.5 / 6.0, 0)));
        
    float B =   sdf(i.uv + mul(J, float2( 1.5 / 6.0, 0))) + 
                sdf(i.uv + mul(J, float2( 2.5 / 6.0, 0)));
                
    return fixed4(R, G, B, (R + G + B) / 3.) / 2.;
}
#else // SDF_NONE
fixed4 frag (v2f i) : SV_Target
{
    return (fixed4)SAMPLE_SDF(_MainTex, i.uv);
}
#endif