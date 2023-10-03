Shader "CookbookShaders/Chapter 07/SimpleVertexColor"
{
    Properties
    {
        _MainTint("Global Color Tint", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // vertex:vert로 버텍스 함수(vert라는 이름으로)를 사용하겠음을 알림 
        #pragma surface surf Lambert vertex:vert
        #pragma target 3.0

        float4 _MainTint;

        struct Input
        {
            float4 vertColor;
        };
        
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        // vert 함수의 appdata_full 데이터로 정점 데이터를 받아오고, surf 함수에서 쓸 수 있도록 Input 으로 넘김
        void vert (inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.vertColor = v.color;
        }
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = IN.vertColor.rgb * _MainTint.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
