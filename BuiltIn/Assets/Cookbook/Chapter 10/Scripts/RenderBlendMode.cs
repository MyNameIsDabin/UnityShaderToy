using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

[ExecuteInEditMode]
public class RenderBlendMode : MonoBehaviour
{
    public Shader curShader;
    public Texture2D blendTexture;
    public float blendOpacity = 1.0f;

    private Material screenMat;

    Material ScreenMat
    {
        get
        {
            if (screenMat == null)
            {
                screenMat = new Material(curShader);
                screenMat.hideFlags = HideFlags.HideAndDontSave;
            }

            return screenMat;
        }
    }
    
    void Start()
    {
        if (!curShader && !curShader.isSupported)
            enabled = false;
    }

    void Update()
    {
        blendOpacity = Mathf.Clamp01(blendOpacity);
    }

    private void OnDisable()
    {
        if (screenMat)
        {
            DestroyImmediate(screenMat);
        }
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (curShader != null)
        {
            ScreenMat.SetTexture("_BlendTex", blendTexture);
            ScreenMat.SetFloat("_Opacity", blendOpacity);

            Graphics.Blit(src, dest, ScreenMat);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
