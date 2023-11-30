using UnityEngine;

public class Player : MonoBehaviour
{
    public float Speed;
    
    void Update()
    {
        var hAxis = Input.GetAxisRaw("Horizontal");
        var vAxis = Input.GetAxisRaw("Vertical");

        transform.position += new Vector3(hAxis, vAxis, 0) * Speed;
    }
}
