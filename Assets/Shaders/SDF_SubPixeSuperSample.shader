Shader "Custom/SDF_SubpixelSuperSampled"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _SmoothstepMin ("Smoothstep Min", Range (0, 1)) = 0
        _SmoothstepMax ("Smoothstep Max", Range (0, 1)) = 1
        _PlaceHolder ("PlaceHolder", Range (0, 2)) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
            #include "Helper.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
            
            float _SmoothstepMin;
            float _SmoothstepMax;
            float _PlaceHolder;
                        
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
                // use screen space derivatives for supersampling
                // we need to compute the derivative of 2D vector field
                // dUV = | ddx_u ddy_u |
                //       | ddx_v ddy_v |
                float2x2 dUV = transpose( float2x2( ddx(i.uv), ddy(i.uv) ) );
                
               
                // below code assumes RGB pixels
                float R =   SAMPLE_SDF(_MainTex, i.uv + mul(dUV, float2(-2.5 / 6.0, 0) * _PlaceHolder)) + 
                            SAMPLE_SDF(_MainTex, i.uv + mul(dUV, float2(-1.5 / 6.0, 0) * _PlaceHolder));
                
                float G =   SAMPLE_SDF(_MainTex, i.uv + mul(dUV, float2(-0.5 / 6.0, 0) * _PlaceHolder)) + 
                            SAMPLE_SDF(_MainTex, i.uv + mul(dUV, float2( 0.5 / 6.0, 0) * _PlaceHolder));
                    
                float B =   SAMPLE_SDF(_MainTex, i.uv + mul(dUV, float2(1.5 / 6.0, 0) * _PlaceHolder)) + 
                            SAMPLE_SDF(_MainTex, i.uv + mul(dUV, float2(2.5 / 6.0, 0) * _PlaceHolder));
                    
                float3 px = float3(R, G, B) * 0.5;
                    
                float3 opacity = SMOOTHSTEP(_SmoothstepMin, _SmoothstepMax, px);                
				return fixed4(opacity.r, opacity.g, opacity.b, 1);
			}
			ENDCG
		}
	}
}
