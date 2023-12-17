Shader "Unlit/2DSideScrollingWater"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTexture ("NoiseTexture", 2D) = "white" {}
        _OffsetY ("OffsetY", Range(0, 1)) = 1.0
    }
    SubShader
    {
        Tags 
        { 
            "Queue"="Transparent"
            "RenderType"="Transparent" 
        }
        
        GrabPass 
        { 
            "_GrabTexture" 
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 noiseCoord : TEXCOORD1;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 noiseCoord : TEXCOORD1;
            };

            float _OffsetY;
            sampler2D _GrabTexture;
            sampler2D _NoiseTexture;
            sampler2D _MainTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = ComputeGrabScreenPos(o.vertex);
                o.uv.y = _OffsetY - o.uv.y;

                o.noiseCoord = v.noiseCoord;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                i.noiseCoord.x -= _Time.x * 0.3;
                fixed4 noiseCol = tex2D(_NoiseTexture, i.noiseCoord);

                // UV 왜곡
                i.uv.xy += noiseCol.x * 0.02;
                fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uv));

                // 강을 좀 더 어둡게
                col.rgb *= 0.45;

                if (noiseCol.r > 0.35)
                    col.rgb += noiseCol.r * 0.5;
                
                return col;
            }
            ENDCG
        }
    }
}
