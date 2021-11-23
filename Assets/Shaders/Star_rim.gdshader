shader_type spatial;
render_mode depth_draw_opaque, cull_disabled, unshaded, blend_add;

uniform vec4 albedo : hint_color;

uniform float rim_strength = 50;
uniform float inner_rim_power = 4.0;
uniform float outer_rim_power = 4.0;
uniform float inner_rim_smoothness = 4.0;
uniform float outter_rim_smoothness = 4.0;

// For logarithmic depth buffer.
const float c = 0.001;
varying vec4 gl_Position;

void vertex()
{
	// For logarithmic depth buffer.
	gl_Position = MODELVIEW_MATRIX*vec4(VERTEX, 1.0);
}

void fragment()
{
	// Logarithmic depth buffer.
	DEPTH = log2(max(1e-6, 1.0 -gl_Position.z)) * c;
	
	float rim_inner = clamp(pow( dot( NORMAL, VIEW ), inner_rim_power )*rim_strength, 0.0, 1.0);
	float rim_outer = clamp(pow( dot( NORMAL, VIEW ), outer_rim_power )*rim_strength, 0.0, 1.0);

	ALBEDO = albedo.rgb;
	ALPHA = 
		pow(rim_outer, outter_rim_smoothness)
		*pow((1.0-rim_inner), inner_rim_smoothness);
}
