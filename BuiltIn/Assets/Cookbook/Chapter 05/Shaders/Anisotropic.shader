Shader "CookbookShaders/Chapter 05/Anisotropic"
{
    Properties
    {
        _MainTint("Diffuse Tint", Color) = (1,1,1,1)
        _MainTex("Base(RGB)", 2D) = "white" {}
        _SpecularColor("Specular Color", Color) = (1,1,1,1)
        _Specular("Specular Amount", Range(0, 1)) = 0.5
        _SpecPower("Specular Power", Range(0, 1)) = 0.5
        _AnisoDir("Anisotropic Direction", 2D) = "" {}
        _AnisoOffset("Anisotropic Offset", Range(-1, 1)) = -0.2 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Anisotropic
        #pragma target 3.0

        float4 _MainTint;
        sampler2D _MainTex;
        float4 _SpecularColor;
        float _Specular;
        float _SpecPower;
        sampler2D _AnisoDir;
        float _AnisoOffset;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_AnisoDir;
        };

        struct SurfaceAnisoOutput
        {
            float3 Albedo;
            float3 Normal;
            float3 Emission;
            float3 AnisoDirection;
            float Specular;
            float Gloss;
            float Alpha;
        };

        void surf (Input IN, inout SurfaceAnisoOutput o)
        {
            float4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
            float3 anisoTex = UnpackNormal(tex2D(_AnisoDir, IN.uv_AnisoDir));
            
            o.AnisoDirection = anisoTex;
            o.Specular = _Specular;
            o.Gloss = _SpecPower;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 LightingAnisotropic(SurfaceAnisoOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float3 halfVector = normalize(normalize(lightDir) + normalize(viewDir));
            float NdotL = saturate(dot(s.Normal, lightDir));

            float3 H = normalize(s.Normal + s.AnisoDirection);
            float HdotA = dot(H, halfVector);
            float aniso = max(0, sin(radians((HdotA * _AnisoOffset) * 180)));
            float spec = saturate(pow(aniso, s.Gloss * 128) * s.Specular);
            float3 albedoColor = s.Albedo * _LightColor0.rgb * NdotL;
            float3 specColor = _LightColor0.rgb * _SpecularColor.rgb * spec;
            float4 c;
            c.rgb = (albedoColor + specColor) * atten;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
