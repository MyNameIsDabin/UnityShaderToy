using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SetRadiusProperties : MonoBehaviour
{
    public Material radiusMaterial;
    public float radius;
    public Color color = Color.white;
    
    void Update()
    {
        if (radiusMaterial != null)
        {
            radiusMaterial.SetVector("_Center", transform.position);
            radiusMaterial.SetFloat("_Radius", radius);
            radiusMaterial.SetColor("_RadiusColor", color);
        }
    }
}
