using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowRays : MonoBehaviour
{
    public enum DebugFilter
    {
        View,
        Refelection
    }

    public DebugFilter debugFilter;
    MeshFilter curFilter;
    public float gizmosSize = 1.0f;
	
    void OnDrawGizmos()
    {
        Gizmos.matrix = transform.localToWorldMatrix;
        Vector3 camPosition = Camera.main.transform.position;
		
        if(!curFilter)
        {
            curFilter = transform.GetComponent<MeshFilter>();
            if(!curFilter)
            {
                Debug.LogWarning("No mesh filter found!!");
            }
        }
        else
        {
            Mesh curMesh = curFilter.sharedMesh;
            if(curMesh)
            {
                for(int i = 0; i < curMesh.vertices.Length; i++)
                {
                    Vector3 viewDir = (curMesh.vertices[i] - camPosition).normalized;
                    Vector3 curReflVector = Reflect(viewDir, curMesh.normals[i]);

                    var drawDir = debugFilter == DebugFilter.View ? viewDir : curReflVector;
                    
                    Gizmos.color = new Color(drawDir.x,drawDir.y,drawDir.z, 1.0f);
                    Gizmos.DrawRay(curMesh.vertices[i], drawDir * gizmosSize);
                }
            }
        }
    }
	
    Vector3 Reflect(Vector3 viewDir, Vector3 normal)
    {
        Vector3 reflection = viewDir - 2.0f * normal * Vector3.Dot(normal, viewDir);
        return reflection;
    }
}
