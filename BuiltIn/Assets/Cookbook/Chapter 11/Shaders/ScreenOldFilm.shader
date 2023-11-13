Shader "CookbookShaders/Chapter 11/ScreenOldFilm"
{
    Properties
    {
        _MainTex("_MainTex", 2D) = "white" {}
        _SepiaColor("_SepiaColor", Color) = (1,1,1,1)
        _VignetteAmount("_VignetteAmount", Range(0.0, 1)) = 1.0
        _VignetteTex("_VignetteTex", 2D) = "white" {}
        _ScratchesTex("_ScratchesTex", 2D) = "white" {}
        _ScratchesVSpeed("_ScratchesVSpeed", Float) = 1.0
        _ScratchesXSpeed("_ScratchesXSpeed", Float) = 1.0
        _DustTex("_DustTex", 2D) = "white" {}
        _dustVSpeed("_dustVSpeed", Float) = 1.0
        _dustXSpeed("_dustXSpeed", Float) = 1.0
        _RandomValue("_RandomValue", Float) = 1.0
        _Contrast("Contrast", Float) = 3.0
        _EffectAmount("_EffectAmount", Range(0, 1)) = 1.0
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
            uniform sampler2D _VignetteTex;
            uniform sampler2D _ScratchesTex;
            uniform sampler2D _DustTex;
            fixed4 _SepiaColor;
            fixed _VignetteAmount;
            fixed _ScratchesVSpeed;
            fixed _ScratchesXSpeed;
            fixed _dustVSpeed;
            fixed _dustXSpeed;
            fixed _RandomValue;
            fixed _Contrast;
            fixed _EffectAmount;
            
            fixed4 frag(v2f_img i) : COLOR
            {
                fixed4 renderTex = tex2D(_MainTex, i.uv);
                fixed4 vignetteTex = tex2D(_VignetteTex, i.uv);

                half2 scratchesUV = half2(i.uv.x + (_RandomValue * _SinTime.z * _ScratchesXSpeed),
                    i.uv.y + (_Time.x * _ScratchesVSpeed));
                
                fixed4 scratchesTex = tex2D(_ScratchesTex, scratchesUV);
                
                half2 dustUV = half2(i.uv.x + (_RandomValue * _SinTime.z * _dustXSpeed),
                    i.uv.y + (_RandomValue * (_SinTime.z * _dustVSpeed)));
                
                fixed4 dustTex = tex2D(_DustTex, dustUV);
                fixed lum = dot(fixed3(0.299, 0.587, 0.114), renderTex.rgb);
                fixed4 finalColor = lum + lerp(_SepiaColor, _SepiaColor + fixed4(0.1f, 0.1f, 0.1f, 1.0f), _RandomValue);
                finalColor = pow(finalColor, _Contrast);
                
                fixed3 constantWhite = fixed3(1, 1, 1);
                finalColor = lerp(finalColor, finalColor * vignetteTex, _VignetteAmount);
                finalColor.rgb *= lerp(scratchesTex, constantWhite, _RandomValue);
                finalColor.rgb *= lerp(dustTex.rgb, constantWhite, (_RandomValue * _SinTime.z));
                finalColor = lerp(renderTex, finalColor, _EffectAmount);
                
                return finalColor;
            }
            ENDCG
        }
    }
    FallBack Off
}
