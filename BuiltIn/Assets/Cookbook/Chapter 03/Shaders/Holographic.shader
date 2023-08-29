Shader "CookbookShaders/Chapter 03/Holographic"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DotProduct ("Rim effect", Range(-1, 1)) = 0.25
    }
    SubShader
    {
        Tags 
        { 
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }
        LOD 200
        Cull Off

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade
        #pragma target 3.0

        sampler2D _MainTex;
        float _DotProduct;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir; // 버텍스 입장에서 카메라를 바라보는 방향
        };
        
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            float border = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));
            float alpha = (border * (1 - _DotProduct) + _DotProduct);
            
            o.Albedo = c.rgb;
            o.Alpha = c.a * alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
