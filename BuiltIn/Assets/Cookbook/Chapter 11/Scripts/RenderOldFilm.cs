using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Random = UnityEngine.Random;

[ExecuteInEditMode]
public class RenderOldFilm : MonoBehaviour
{
    public Shader curShader;

    public float OldFilmEffectAmount = 1.0f;
    public Color sepiaColor = Color.white;
    public Texture2D vignetteTexture;
    public float vignetteAmount = 1.0f;
    public Texture2D scratchesTexture;
    public float scratchesVSpeed = 10.0f;
    public float scratchesXSpeed = 10.0f;
    public Texture2D dustTexture;
    public float dustVSpeed = 10.0f;
    public float dustXSpeed = 10.0f;
    private Material screenMat;
    private float randomValue;

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
        vignetteAmount = Mathf.Clamp01(vignetteAmount);
        OldFilmEffectAmount = Mathf.Clamp(OldFilmEffectAmount, 0f, 1.5f);
        randomValue = Random.Range(-1f, 1f);
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
            ScreenMat.SetColor("_SepiaColor", sepiaColor);
            ScreenMat.SetFloat("_VignetteAmount", vignetteAmount);
            
            if (vignetteTexture)
                ScreenMat.SetTexture("_VignetteTex", vignetteTexture);

            if (scratchesTexture)
            {
                ScreenMat.SetTexture("_ScratchesTex", scratchesTexture);
                ScreenMat.SetFloat("_ScratchesVSpeed", scratchesVSpeed);
                ScreenMat.SetFloat("_ScratchesXSpeed", scratchesXSpeed);
            }

            if (dustTexture)
            {
                ScreenMat.SetTexture("_DustTex", dustTexture);
                ScreenMat.SetFloat("_dustVSpeed", dustVSpeed);
                ScreenMat.SetFloat("_dustXSpeed", dustXSpeed);
                ScreenMat.SetFloat("_RandomValue", randomValue);
            }
            
            Graphics.Blit(src, dest, ScreenMat);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
