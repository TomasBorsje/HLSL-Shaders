Shader "Custom/RainbowPostProcess"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DepthFactor("Depth Factor", Float) = 100.0
    }
    SubShader
    {
        Cull Off ZWrite Off ZTest Always

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
                float4 scrPos : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.scrPos = ComputeScreenPos(o.vertex);
                return o;
            }

            float3 HueToRGB(in float hue)
            {
                float3 rgb = abs(hue * 6. - float3(3, 2, 4)) * float3(1, -1, -1) + float3(-1, 2, 2);
                return clamp(rgb, 0., 1.);
            }

            sampler2D _MainTex;
            sampler2D _CameraDepthTexture;
            float _DepthFactor;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv); // Get the colour the pixel would be
                float depth = fmod(Linear01Depth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)).r) * _DepthFactor, 1); // Get a cycling rainbow colour based on pixel's depth
                col.rgb = col.r; // Desaturate
                col.rgb += HueToRGB(depth)/5.0; // Add some colour back based on the depth
                return col;
            }
            ENDCG
        }
    }
}
