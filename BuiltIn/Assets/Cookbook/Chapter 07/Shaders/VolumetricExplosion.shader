Shader "CookbookShaders/Chapter 07/VolumetricExplision"
{
    Properties
    {
        _RampTex ("Color Ramp", 2D) = "white" {}
        _RampOffset ("Ramp Offset", Range(-0.5, 0.5)) = 0
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _Period ("Period", Range(0, 1)) = 0.5
        _Amount ("Amount", Range(0, 1)) = 0.1
        _ClipRange ("ClipRange", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard vertex:vert
        #pragma target 3.0

        sampler2D _RampTex;
        float _RampOffset;
        sampler2D _NoiseTex;
        float _Period;
        half _Amount;
        half _ClipRange;
        
        struct Input
        {
            float2 uv_NoiseTex;
        };

        void vert(inout appdata_full v)
        {
            float disp = tex2Dlod(_NoiseTex, float4(v.texcoord.xy, 0, 0)).r;
            float time = sin(_Time[3] * _Period + disp * 10);
            v.vertex.xyz += v.normal * disp * _Amount * time;
        }
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float3 noise = tex2D (_NoiseTex, IN.uv_NoiseTex);
            float n = saturate(noise.r + _RampOffset);

            clip(_ClipRange - n);
            half4 c = tex2D(_RampTex, float2(n, 0.5));
            o.Albedo = c.rgb;
            o.Emission = c.rgb * c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
