﻿Shader "Custom/SDF_Supersample"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _SmoothstepMin ("Smoothstep Min", Range (0, 1)) = 0
        _SmoothstepMax ("Smoothstep Max", Range (0, 1)) = 1
        _Blending ("Blending", Range (-1, 1)) = 0
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
            float _Blending;
            float _PlaceHolder;
            float2 _vecPlaceHolder;
                        
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
                
                float4 samples = float4(
                    SAMPLE_SDF(_MainTex, i.uv + mul(dUV, float2( 1, 1) * 0.25 * _PlaceHolder)),
                    SAMPLE_SDF(_MainTex, i.uv + mul(dUV, float2( 1,-1) * 0.25 * _PlaceHolder)),
                    SAMPLE_SDF(_MainTex, i.uv + mul(dUV, float2(-1, 1) * 0.25 * _PlaceHolder)),
                    SAMPLE_SDF(_MainTex, i.uv + mul(dUV, float2(-1,-1) * 0.25 * _PlaceHolder)));
                
                float minS = MIN_FLOAT4(samples);
                float maxS = MAX_FLOAT4(samples);
                float avg = dot(float4(1, 1, 1, 1), samples) * 0.25;
                
                float blended = 
                    lerp(avg, (float4)maxS,  _Blending) * step(0, _Blending) + 
                    lerp(avg, (float4)minS, -_Blending) * (1.0 - step(0, _Blending));
                
                float opacity = SMOOTHSTEP(_SmoothstepMin, _SmoothstepMax, blended);
                
                return (fixed4)opacity;
			}
			ENDCG
		}
	}
}