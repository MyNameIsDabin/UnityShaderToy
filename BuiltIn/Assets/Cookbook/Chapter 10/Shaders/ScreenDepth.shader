Shader "CookbookShaders/Chapter 10/ScreenDepth"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DepthPower("Depth Power", Range(0, 1)) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma fragmentoption ARB_precsion_hint_fastest
            #include "UnityCG.cginc"
            
            uniform sampler2D _MainTex;
            fixed _DepthPower;
            sampler2D _CameraDepthTexture;
            
            fixed4 frag(v2f_img i) : COLOR
            {
                fixed4 depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv.xy));
                depth = pow(Linear01Depth(depth), _DepthPower);
                return depth;
            }
            ENDCG
        }
    }
    FallBack Off
}
