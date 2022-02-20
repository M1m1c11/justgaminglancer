shader_type spatial;
render_mode depth_draw_opaque, cull_front, unshaded;

uniform vec4 corona_color : hint_color;
uniform vec4 core_color : hint_color;
uniform float rim_strength = 0.05;
uniform float rim_power = 9.0;
uniform float core_strength = 0.05;
uniform float core_power = 9.0;
uniform float core_amount = 0.05;


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
	
	float rim = clamp(pow( dot( NORMAL, VIEW ), rim_power)*rim_strength, 0.0, 1.0);
	float core = clamp(pow( dot( NORMAL, VIEW ), core_power)*core_strength, 0.0, 1.0);
	ALBEDO = corona_color.rgb + core*core_amount*core_color.rgb;
	ALPHA = rim;
}
