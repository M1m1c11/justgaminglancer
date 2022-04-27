shader_type spatial;

render_mode unshaded, cull_disabled, depth_draw_opaque;

uniform vec4 albedo : hint_color;

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
	// DEPTH = log2(max(1e-6, 1.0 -gl_Position.z)) * c;
	
	
	ALBEDO = albedo.rgb*COLOR.rgb;
}
