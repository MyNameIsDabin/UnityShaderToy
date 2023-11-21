using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Random = System.Random;

[ExecuteInEditMode]
public class RenderNightVision : MonoBehaviour
{
    public Shader curShader;

    public float contrast = 3.0f;
    public float brightness = 0.1f;
    public Color nightVisionColor = Color.green;
    public Texture2D vignetteTexture;
    public Texture2D scanLineTexture;
    public float scanLineTileAmount = 4.0f;
    public Texture2D nightVisionNoise;
    public float noiseXSpeed = 100.0f;
    public float noiseYSpeed = 100.0f;
    public float distortion = 0.2f;
    public float scale = 0.8f;

    private float randomValue = 0.0f;
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
        contrast = Mathf.Clamp(contrast, 0f, 4f);
        brightness = Mathf.Clamp(brightness, 0f, 2f);
        randomValue = UnityEngine.Random.Range(-1f, 1f);
        distortion = Mathf.Clamp(distortion, -1f, 1f);
        scale = Mathf.Clamp(scale, 0f, 3f);
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
            ScreenMat.SetFloat("_Contrast", contrast);
            ScreenMat.SetFloat("_Brightness", brightness);
            ScreenMat.SetColor("_NightVisionColor", nightVisionColor);
            ScreenMat.SetFloat("_RandomValue", randomValue);
            ScreenMat.SetFloat("_distortion", distortion);
            ScreenMat.SetFloat("_scale", scale);

            if (vignetteTexture)
            {
                ScreenMat.SetTexture("_VignetteTex", vignetteTexture);
            }

            if (scanLineTexture)
            {
                ScreenMat.SetTexture("_ScanLineTex", scanLineTexture);
                ScreenMat.SetFloat("_ScanLineTileAmount", scanLineTileAmount);
            }

            if (nightVisionNoise)
            {
                ScreenMat.SetTexture("_NoiseTex", nightVisionNoise);
                ScreenMat.SetFloat("_NoiseXSpeed", noiseXSpeed);
                ScreenMat.SetFloat("_NoiseYSpeed", noiseYSpeed);
            }
            
            Graphics.Blit(src, dest, ScreenMat);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
