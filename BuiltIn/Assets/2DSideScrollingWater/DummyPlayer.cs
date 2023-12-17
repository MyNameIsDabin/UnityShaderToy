using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DummyPlayer : MonoBehaviour
{
    void Update()
    {
        transform.position = new Vector2(transform.position.x + 1f * Time.deltaTime, transform.position.y);
    }
}
