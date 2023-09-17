Shader "CookbookShaders/Chapter 05/PhongSpecular"
{
    Properties
    {
        _MainTint ("Diffuse Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
        _SpecPower ("Specular Power", Range(0, 30)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Phong
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
            float4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
            
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        
        fixed4 LightingPhong(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            // Reflection
            float NdotL = dot(s.Normal, lightDir);
            float3 reflectionVector = normalize(2.0 * s.Normal * NdotL - lightDir);

            // Specular
            float spec = pow(max(0, dot(reflectionVector, viewDir)), _SpecPower);
            float3 finalSpec = _LightColor0.rgb * _SpecularColor.rgb * spec * atten;

            // Final effect
            fixed4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * max(0, NdotL) * atten)
                + finalSpec;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
