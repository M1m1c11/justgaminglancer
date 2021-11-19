shader_type spatial;
render_mode depth_draw_opaque, cull_disabled, unshaded;

uniform vec4 albedo : hint_color;
uniform float rim_strength = 0.05;
uniform float rim_power = 9.0;

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
	
	float rim = clamp(pow( dot( NORMAL, VIEW ), rim_power)*rim_strength, 0.0, 1.0);
	ALBEDO = albedo.rgb;
	ALPHA = rim;
}
