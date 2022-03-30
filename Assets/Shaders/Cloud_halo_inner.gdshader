shader_type spatial;
render_mode depth_draw_opaque, blend_mix, cull_disabled, unshaded;

uniform vec4 albedo : hint_color;
uniform float rim_strength = 1.5;
uniform float rim_power = 9.0;
uniform float alpha_global = 0.5;

// For logarithmic depth buffer.
//const float c = 0.001;
//varying vec4 gl_Position;

//void vertex()
//{
	// For logarithmic depth buffer.
	//gl_Position = MODELVIEW_MATRIX*vec4(VERTEX, 1.0);
//}

void fragment()
{
	// Logarithmic depth buffer.
	// DEPTH = log2(max(1e-6, 1.0 -gl_Position.z)) * c;
	
	float rim = clamp(pow( dot( NORMAL, VIEW ), rim_power)*rim_strength, 0.0, 1.0);
	ALBEDO = albedo.rgb*COLOR.rgb;
	ALPHA = clamp(1.0-rim, 0.0, 1.0)*alpha_global;
}
