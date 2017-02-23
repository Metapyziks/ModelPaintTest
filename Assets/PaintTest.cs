using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PaintTest : MonoBehaviour
{
    private bool _painting;

    public int Resolution = 1024;

    public Camera Camera;
    public MeshRenderer Model;
    public RenderTexture PaintTarget;
    public Material PaintMaterial;
    
    [Range(2f, 128f)]
    public float BrushRadius = 16f;

    public Color BrushColor = Color.white;

    void Start()
    {
        if ( PaintTarget == null )
        {
            PaintTarget = new RenderTexture( Resolution, Resolution, 1, RenderTextureFormat.ARGB32 );

            GetComponent<MeshRenderer>().material.mainTexture = PaintTarget;
            Model.material.mainTexture = PaintTarget;
        }
    }

    private void Paint()
    {
        if ( Camera == null || PaintMaterial == null || Model == null ) return;

        var mesh = Model.GetComponent<MeshFilter>().sharedMesh;

        Graphics.SetRenderTarget( PaintTarget );

        var cursorPos = Camera.ScreenToViewportPoint( Input.mousePosition );
        
        PaintMaterial.SetVector( "_CursorParams", new Vector4(cursorPos.x, 1f - cursorPos.y, Camera.pixelHeight / BrushRadius, Camera.pixelWidth / (float) Camera.pixelHeight) );
        PaintMaterial.SetColor( "_Color", BrushColor );
        PaintMaterial.SetPass( 0 );

        GL.PushMatrix();
        GL.LoadProjectionMatrix( Camera.projectionMatrix );

        GL.Clear( true, false, Color.black );
        Graphics.DrawMeshNow( mesh, Model.transform.localToWorldMatrix, 0 );

        GL.PopMatrix();

        Graphics.SetRenderTarget( null );
    }

    void FixedUpdate()
    {
        if (Input.GetMouseButton( 0 ) || Input.GetKey( KeyCode.Space )) Paint();
    }
}
