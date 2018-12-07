
// which channel of the texture holds SDF data
#define SAMPLE_SDF(tex, uv) (tex2D(tex, uv).r)

// we may want to try multiple functions
#define SMOOTHSTEP(a, b, x) smoothstep(a, b, x)
//#define SMOOTHSTEP(a, b, x) (1.0 / (1.0 + exp(-(a * 24.0) * (x - (b * 2)))))

// utils for readability
#define MIN_FLOAT4(x) (min(x.r, min(x.g, min(x.b, x.a))))
#define MAX_FLOAT4(x) (max(x.r, max(x.g, max(x.b, x.a))))

// Texel coordinates Jacobian
#define JACOBIAN(uv) (transpose( float2x2( ddx(uv), ddy(uv) ) ));

// Uniforms
sampler2D _MainTex;
float4 _MainTex_ST;

float _SmoothstepMin;
float _SmoothstepMax;

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
		
			
fixed4 frag_sdf (v2f i) : SV_Target
{
    return fixed4(1, 0, 0, 1);
}

fixed4 frag_sdf_supersample (v2f i) : SV_Target
{
    return fixed4(1, 0, 0, 1);
}

fixed4 frag_sdf_subpixel (v2f i) : SV_Target
{
    return fixed4(1, 0, 0, 1);
}

fixed4 frag_sdf_supersample_subpixel (v2f i) : SV_Target
{
    return fixed4(1, 0, 0, 1);
}