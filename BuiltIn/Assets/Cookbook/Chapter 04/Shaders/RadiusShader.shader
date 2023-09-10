Shader "CookbookShaders/Chapter 04/RadiusShader"
{
    Properties
    {
        _MainTex("Albedo", 2D) = "white" {}
        _Center("Center", Vector) = (200, 0, 200, 0)
        _Radius("Radius", Float) = 100
        _RadiusColor("Radius Color", Color) = (1, 0, 0, 1)
        _RadiusWidth("Raidus Width", Float) = 10
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque"
            "TerrainCompatible"="True"
        }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        float3 _Center;
        float _Radius;
        float4 _RadiusColor;
        float _RadiusWidth;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float d = distance(_Center, IN.worldPos);

            if ((d > _Radius) && (d < _Radius + _RadiusWidth))
            {
                o.Albedo = _RadiusColor;
            }
            else
            {
                o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            }
        }
        ENDCG
    }
    FallBack "Diffuse"
}
