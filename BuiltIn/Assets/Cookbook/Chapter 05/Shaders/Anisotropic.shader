Shader "CookbookShaders/Chapter 05/Anisotropic"
{
    Properties
    {
        _MainTint("Diffuse Tint", Color) = (1,1,1,1)
        _MainTex("Base (RGB)", 2D) = "white" {}
        _SpecularColor("Specular Color", Color) = (1,1,1,1)
        _Specular("Specular Amount", Range(0,1)) = 0.5
        _SpecPower("Specular Power", Range(0,1)) = 0.5
        _AnisoDir("Anisotropic Direction", 2D) = "" {}
        _AnisoOffset("Anisotropic Offset", Range(-1,1)) = -0.2
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Anisotropic 
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _AnisoDir;
        float4 _MainTint;
        float4 _SpecularColor;
        float _AnisoOffset;
        float _Specular;
        float _SpecPower;
        
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_AnisoDir;
        };

        // surf 함수에서 LightingModel로 전달할 정보를 Output 구조체에 저장
        struct SurfaceAnisoOutput
        {
            float3 Albedo;
            float3 Normal;
            float3 Emission;
            float3 AnisoDirection;
            half Specular;
            float Gloss;
            float Alpha;
        };
        
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        fixed4 LightingAnisotropic(SurfaceAnisoOutput s, float3 lightDir, half3 viewDir, float atten)
        {
            // View와 Light 의 중앙 벡터
            float3 halfVector = normalize(normalize(lightDir) + normalize(viewDir));
            // 버텍스 노멀(N)과 라이트(L) 내적 (dot)
            float NdotL = saturate(dot(s.Normal, lightDir));

            // 노멀(N) 값과 이방성 맵에서 언패킹해서 얻은 노멀 값을 더해서 H 벡터를 계산.
            // 기존 BlinnPhong과 거의 동일하고 노멀을 더하는 작업만 추가됨.
            float3 H = normalize(s.Normal + s.AnisoDirection);
            float HdotA = dot(H, halfVector);  
            
            float aniso = max(0, sin(radians((HdotA + _AnisoOffset) * 180)));  
            float spec = saturate(pow(aniso, s.Gloss * 128) * s.Specular);

            float3 albedoColor = s.Albedo * _LightColor0.rgb * NdotL;
            float3 specColor = _LightColor0.rgb * _SpecularColor.rgb * spec;

            float4 c;
            c.rgb = (albedoColor + specColor) * atten;
            c.a = s.Alpha;
            return c;
        }

        void surf(Input IN, inout SurfaceAnisoOutput o)
        {
            half4 c = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
            float3 anisoTex = UnpackNormal(tex2D(_AnisoDir, IN.uv_AnisoDir));

            o.AnisoDirection = anisoTex;
            o.Specular = _Specular;
            o.Gloss = _SpecPower;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        ENDCG
    }
    FallBack "Diffuse"
}