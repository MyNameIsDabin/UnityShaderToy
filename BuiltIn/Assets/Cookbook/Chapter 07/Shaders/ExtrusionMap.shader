Shader "CookbookShaders/Chapter 07/ExtrusionMap" 
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "" {}
        _ExtrusionMap ("ExtrusionMap", 2D) = "" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Amount ("Amount", Range(-0.0001, 0.0001)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard vertex:vert
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _ExtrusionMap;
        fixed4 _Color;
        float _Amount;
        
        struct Input
        {
            float2 uv_MainTex;
        };
        
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void vert (inout appdata_full v)
        {
            float4 tex = tex2Dlod(_ExtrusionMap, float4(v.texcoord.xy, 0, 0));
            float extrusion = tex.r * 2 - 1;
            v.vertex.xyz += v.normal * _Amount * extrusion;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float4 tex = tex2D (_ExtrusionMap, IN.uv_MainTex);
            float extrusion = abs(tex.r * 2 - 1);
            float4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Albedo = lerp(o.Albedo.rgb, float3(0, 0, 0), extrusion * (_Amount / 0.0001) * 1.1);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
