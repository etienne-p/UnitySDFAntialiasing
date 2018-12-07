using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Scaler : MonoBehaviour 
{
    [SerializeField, Range(0, 2)] float scale;

    private void OnValidate()
    {
        transform.localScale = Vector3.one * scale;
    }
}
