using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraControls : MonoBehaviour
{
    private Vector3 _lastMousePos;

    void Update()
    {
        if ( !Input.GetMouseButton( 1 ) )
        {
            _lastMousePos = Input.mousePosition;
            return;
        }

        var delta = Input.mousePosition - _lastMousePos;
        
        transform.Rotate( Vector3.right, -delta.y );
        transform.Rotate( Vector3.up, delta.x );

        transform.position = -transform.forward * 3f;

        _lastMousePos = Input.mousePosition;
    }
}
