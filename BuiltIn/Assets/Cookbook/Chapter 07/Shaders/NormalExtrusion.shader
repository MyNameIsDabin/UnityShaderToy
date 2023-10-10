Shader "CookbookShaders/Chapter 07/NormalExtrusion" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Amount ("Extrusion Amount", Range(-0.0001, 0.0002)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		#pragma target 3.0

		sampler2D _MainTex;
		float _Amount;

		struct Input {
			float2 uv_MainTex;
		};
		
		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void vert (inout appdata_full v)
		{
			v.vertex.xyz += v.normal * _Amount;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}