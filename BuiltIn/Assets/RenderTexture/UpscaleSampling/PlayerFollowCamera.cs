using System;
using TMPro;
using UnityEngine;
using UnityEngine.Rendering;

public class PlayerFollowCamera : MonoBehaviour
{
    public Vector3 Offset;
    public Transform Target;
    public RenderTexture RenderTexture;
    public TMP_Text GraphicsAPIText;

    private void Start()
    {
        if (GraphicsAPIText != null)
            GraphicsAPIText.text = SystemInfo.graphicsDeviceType.ToString();
    }

    private void Update()
    {
        // var cmd = new CommandBuffer();
        // cmd.SetRenderTarget(RenderTexture);
        // cmd.ClearRenderTarget(true, true, Color.clear);
        // Graphics.ExecuteCommandBuffer(cmd);
        // cmd.Dispose();
        
        // RenderTexture rt = RenderTexture.active;
        // RenderTexture.active = RenderTexture;
        // GL.Clear(true, true, Color.clear);
        // RenderTexture.active = rt;
    }

    void LateUpdate()
    {
        transform.position = Target.transform.position + Offset;
    }
}
