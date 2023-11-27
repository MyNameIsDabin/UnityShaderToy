using UnityEngine;
using UnityEngine.EventSystems;

public class HighlightOnHover : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
{
    public Color highlightColor = Color.red;
    
    private Material _material;
    
    private static readonly int HoverColor = Shader.PropertyToID("_HoverColor");

    void Start()
    {
        _material = GetComponent<MeshRenderer>().material;
        
        OnPointerExit(null);
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        _material.SetColor(HoverColor, highlightColor);
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        _material.SetColor(HoverColor, Color.black);
    }
}
