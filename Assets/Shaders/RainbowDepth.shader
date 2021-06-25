Shader "Unlit/Shader1"
{
    Properties
    {
        _DepthFactor("Depth Factor", Float) = 5.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _DepthFactor;
            float4 _MainTex_ST;

            float3 HueToRGB(in float hue)
            {
                float3 rgb = abs(hue * 6. - float3(3, 2, 4)) * float3(1, -1, -1) + float3(-1, 2, 2);
                return clamp(rgb, 0., 1.);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                UNITY_TRANSFER_DEPTH(o.depth); // Transfer depth so we can use it in frag
                return o;
            }

            fixed3 frag(v2f i) : SV_Target
            {
                fixed3 col;
                col.rgb = HueToRGB(fmod(i.vertex.w/_DepthFactor,1)); // Get hue from depth value cycling with fmod
                return col;
            }
            ENDCG
        }
    }
}
