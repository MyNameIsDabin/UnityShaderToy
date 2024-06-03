Shader "Custom/CardFrame"
{
    Properties
    {
        [IntRange] _StencilID ("Stencil ID", Range(0, 255)) = 0
    }
    SubShader
    {   
        ZTest LEqual
        ZWrite Off
        
        Tags { 
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }
        
        Pass
        {
            Cull Front
            
            Stencil
            {
                Ref [_StencilID]
                Comp Always
                Pass Replace 
            }
        }
    }
}
