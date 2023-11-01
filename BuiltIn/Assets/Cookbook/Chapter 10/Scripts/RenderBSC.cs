using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
public class RenderBSC : MonoBehaviour
{
    public Shader curShader;

    public float brightness = 1.0f;
    public float saturation = 1.0f;
    public float contrast = 1.0f;

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
        brightness = Mathf.Clamp(brightness, 0f, 2f);
        saturation = Mathf.Clamp(saturation, 0f, 2f);
        contrast = Mathf.Clamp(contrast,  0f, 3f);
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
            ScreenMat.SetFloat("_Brightness", brightness);
            ScreenMat.SetFloat("_Saturation", saturation);
            ScreenMat.SetFloat("_Contrast", contrast);
            
            Graphics.Blit(src, dest, ScreenMat);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
