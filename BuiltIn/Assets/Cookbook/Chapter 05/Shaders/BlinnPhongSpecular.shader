Shader "Custom/BlinnPhongSpecular"
{
    Properties
    {
        _MainTint("MainTint", Color) = (1,1,1,1)
        _MainTex("Base(RGB)", 2D) = "white" {}
        _SpecularColor("Specular Color", Color) = (1,1,1,1)
        _SpecPower("Specular Power", Range(0.1, 60)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf BlinnPhong
        #pragma target 3.0

        float4 _MainTint;
        sampler2D _MainTex;
        float4 _SpecularColor;
        float _SpecPower;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        fixed4 LightingBlinnPhong(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float NdotL = max(0, dot(s.Normal, lightDir));
            float3 h = normalize(lightDir + viewDir);
            float3 NdotH = max(0, dot(s.Normal, h));
            float spec = pow(NdotH, _SpecPower) * _SpecColor;
            
            float4 color;
            color.rgb = ((s.Albedo * _LightColor0.rgb * NdotL) + (_LightColor0.rgb * _SpecularColor.rgb * spec)) * atten;
            color.a = s.Alpha;
            return color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
