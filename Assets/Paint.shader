Shader "Unlit/Paint"
{
    Properties
    {
        _UnwrappedMap ("Unwrapped UV Map", 2D) = "white" {}
        _PaintTexture ("Paint Texture", 2D) = "white" {}
        _CursorParams ("Cursor Pos", Vector) = (0.5, 0.5, 0.125, 4)
        _Color ("Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _UnwrappedMap;
            sampler2D _PaintTexture;
            float4 _CursorParams;
            float4 _Color;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = float4(v.uv * 2 - float2(1, 1), 0, 1);
                o.uv = float2(v.uv.x, 1 - v.uv.y);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float2 screenPos = tex2D( _UnwrappedMap, i.uv).xy;
                fixed4 paintSample = tex2D( _PaintTexture, i.uv );

                float dist = length(screenPos - _CursorParams.xy) * _CursorParams.w - _CursorParams.z;
                float alpha = clamp( 1.0 - dist, 0.0, 1.0 );

                return float4(_Color.rgb * paintSample.rgb, _Color.a * alpha);
            }
            ENDCG
        }
    }
}
