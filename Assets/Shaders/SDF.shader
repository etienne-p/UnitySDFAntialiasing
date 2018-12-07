Shader "Custom/SDF"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Threshold ("Threshold", Range(0, 1)) = 0.5
        _Smoothness ("Smoothness", Range(0, 2)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "SDF.cginc"
            #pragma multi_compile __ SDF_DEFAULT SDF_SUPERSAMPLE SDF_SUBPIXEL SDF_SUPERSAMPLE_SUBPIXEL
            ENDCG
        }
    }
}
