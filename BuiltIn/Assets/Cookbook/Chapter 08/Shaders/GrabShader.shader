Shader "CookbookShaders/Chapter 08/GrabPass"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        GrabPass { "_GrabTexture" }
        Pass 
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            sampler2D _GrabTexture;

            struct vertInput
            {
                float4 vertex: POSITION;                
            };
            
            struct vertOutput
            {
                float4 vertex: POSITION;
                float4 uvgrab: TEXCOORD1;
            };

            vertOutput vert(vertInput v)
            {
                vertOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uvgrab = ComputeGrabScreenPos(o.vertex);
                return o;
            }

            half4 frag(vertOutput i) : COLOR
            {
                fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
                return col + half4(0.5, 0, 0, 0);
            }
            
            ENDCG
        }
    }
    FallBack "Diffuse"
}
