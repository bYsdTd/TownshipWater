﻿Shader "Unlit/Sea"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SeaColor ("SeaColor", Color) = (0, 0.45, 0.63,1)
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
            };

            struct v2f
            {
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float4 vertex : SV_POSITION;
                float2 v : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _SeaColor;

            v2f vert (appdata v)
            {
                v2f o;
                // uv是通过顶点的位置坐标计算的
                // uv0,uv1两次不同方向的采样做混合，跟一般的水效果实现是一样的
                o.uv0 = v.vertex.xy * 0.15;
                o.uv1 = o.uv0;

                // 计算时间参数,uv0和uv1的频率稍微有点不同
                float t = _Time.y * 0.015;
                o.uv0.y += t;
                o.uv1.y -= t*0.08;


                // 计算Mesh的偏移，模拟水的波浪
                // 考虑让每个位置的y偏移形成波浪，所以y的偏移应该是与坐标位置有关的一个函数
                // 这函数算法啥意思，要是有大佬懂得话，麻烦告知
                float w_t0 = o.uv0.x * 40.0 + o.uv0.y * 20.0;
                float w_t1 = o.uv0.x * 20.0 + o.uv0.y * 10.0 - t * 143.5;
                float yoff = sin(w_t0) * sin(w_t1) *0.1;
                v.vertex.y += yoff;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.v.xy = o.vertex.xy;
                o.v.y += 0.5;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // 高光部分
                // 让屏幕靠近中间和上方的部分高光强烈
                float hlight = exp(-i.v.x * i.v.x * 8.0 - i.v.y * i.v.y * 1.0) * 1.25;

                fixed4 col0 = tex2D(_MainTex, i.uv0);
                fixed4 col1 = tex2D(_MainTex, i.uv1);
                fixed4 col = col0 * col1;

                return _SeaColor 
                        + col.r 
                        + col.g 
                        - col.b*0.24 
                        - (1.0 - col.a) * 0.3 
                        + hlight * col.r + hlight * 0.2
                        ;
            }
            ENDCG
        }
    }
}
