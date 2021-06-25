using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    public float rotateSpeed = 2;
    void Update()
    {
        transform.Rotate(0, rotateSpeed/10f, 0, Space.World);
    }
}
