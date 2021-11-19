shader_type spatial;

render_mode blend_add, cull_disabled, unshaded, depth_draw_opaque;

uniform vec4 albedo : hint_color;
uniform float proximity_fade_distance;


// For logarithmic depth buffer.
const float far = 1e12; // This is enough for camera far = 1M units.
const float c = 2.0 / log2(far + 1.0);
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
	ALBEDO = albedo.rgb * COLOR.rgb;
}
