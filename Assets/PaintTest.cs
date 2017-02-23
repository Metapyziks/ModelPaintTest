using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PaintTest : MonoBehaviour
{
    public Camera Camera;
    public MeshRenderer Model;
    public RenderTexture PaintTarget;
    public Material PaintMaterial;

    public float BrushEdge = 16f;
    public float BrushRadius = 128f;

    public Color BrushColor = Color.white;

    void Start()
    {
        if ( PaintTarget == null )
        {
            PaintTarget = new RenderTexture( 512, 512, 1, RenderTextureFormat.ARGB32 );

            Model.material.mainTexture = PaintTarget;
        }
    }

    private void Paint()
    {
        if ( Camera == null || PaintMaterial == null || Model == null ) return;

        var mesh = Model.GetComponent<MeshFilter>().sharedMesh;

        Graphics.SetRenderTarget( PaintTarget );

        var cursorPos = Camera.ScreenToViewportPoint( Input.mousePosition );
        
        PaintMaterial.SetVector( "_CursorParams", new Vector4(cursorPos.x, 1f - cursorPos.y, BrushRadius / Camera.pixelHeight, Camera.pixelHeight / BrushEdge) );
        PaintMaterial.SetColor( "_Color", BrushColor );
        PaintMaterial.SetPass( 0 );

        GL.PushMatrix();
        GL.LoadProjectionMatrix( Camera.projectionMatrix );

        GL.Clear( true, false, Color.black );
        Graphics.DrawMeshNow( mesh, Model.transform.localToWorldMatrix, 0 );

        GL.PopMatrix();

        Graphics.SetRenderTarget( null );
    }

    void Update()
    {
         if (Input.GetMouseButton( 0 )) Paint();
    }
}
