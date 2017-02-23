// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/ModelPaint"
{
    Properties
    {
        _PaintTexture( "Paint Texture", 2D ) = "white" {}
        _CursorParams( "Cursor Pos", Vector ) = (0.5, 0.5, 0.125, 4)
        _Color( "Color", Color ) = (1, 1, 1, 1)
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

            sampler2D _PaintTexture;
            float4 _CursorParams;
            float4 _Color;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal: NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 screenPos : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };
            
            v2f vert (appdata v)
            {
                v2f o;

                float2 uv = v.uv;
                o.vertex = float4(uv*float2(1, -1) * 2 - float2(1, -1), 0, 1);

                float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
                float3 worldDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
                float normalDot = max(0, dot( UnityObjectToWorldNormal( v.normal ), worldDir ));

                float4 clipPos = UnityObjectToClipPos(v.vertex);
                o.uv = float2(v.uv.x, 1 - v.uv.y);
                o.screenPos = float3((clipPos.xy / clipPos.w) * 0.5 + float2(0.5, 0.5), normalDot);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float dist = length( i.screenPos.xy - _CursorParams.xy ) * _CursorParams.w - _CursorParams.z;
                float alpha = clamp( (1.0 - dist) * i.screenPos.z, 0.0, 1.0 );

                return float4(_Color.rgb, _Color.a * alpha);
            }
            ENDCG
        }
    }
}
