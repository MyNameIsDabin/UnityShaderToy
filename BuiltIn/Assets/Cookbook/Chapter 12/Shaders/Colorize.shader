Shader "CookbookShaders/Chapter12/Colorize"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _DesatValue ("Desaturate", Range(0,1)) = 0.5
        _MyColor ("My Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #include "MyCGInclude.cginc"
        #pragma surface surf HalfLambert
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _DesatValue;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            half4 c = tex2D (_MainTex, IN.uv_MainTex);
            c.rgb = lerp(c.rgb, Luminance(c.rgb), _DesatValue);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
