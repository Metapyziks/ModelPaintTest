Shader "Unlit/UvUnwrap"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
            
            v2f vert (appdata v)
            {
                v2f o;

                float2 uv = v.uv;
                o.vertex = float4(uv*float2(1, -1) * 2 - float2(1, -1), 0, 1);
                float4 clipPos = UnityObjectToClipPos(v.vertex);
                o.uv = clipPos.xy / clipPos.w;
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(i.uv * 0.5 + float2(0.5, 0.5), 1, 1);
            }
            ENDCG
        }
    }
}
