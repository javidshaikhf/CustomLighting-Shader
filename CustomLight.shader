Shader "Custom/CustomLight"
{
    Properties
    {
        _Color ("Tint", Color) = (0,0,0,1)
        _MainTex ("Texture", 2D) = "white" {}

        [HDR] _Emission ("Emission", color) = (0,0,0)

        _Ramp("Toon Ramp", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Geometry" }
       
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Custom fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        half3 _Emission;
        fixed4 _Color;
        sampler2D _Ramp;

        float4 LightingCustom(SurfaceOutput s, float3 lightdir, float atten){
                float towardsLight = dot(s.Normal, lightdir);

                towardsLight = towardsLight * 0.5 + 0.5f;

                float3 lightIntensity = tex2D(_Ramp, towardsLight).rgb;

                float4 col;

                col.rgb = lightIntensity * s.Albedo * atten * _LightColor0.rgb;

                col.a = s.Alpha;

                return col;
        }

        struct Input
        {
            float2 uv_MainTex;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {

            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

            c *= _Color;

            o.Albedo = c.rgb;
           
        }
        ENDCG
    }
    FallBack "Standard"
}
