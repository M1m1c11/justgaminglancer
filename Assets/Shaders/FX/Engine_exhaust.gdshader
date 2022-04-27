shader_type spatial;

render_mode blend_add, cull_disabled, unshaded, depth_draw_opaque;

uniform vec4 albedo : hint_color;
uniform float pulse_amount : hint_range(0.0, 1.0) = 0.05;
uniform float pulse_frequency = 50;

void vertex()
{
	float a = ((cos(TIME*pulse_frequency)+1.0)*0.5);
	VERTEX.y = VERTEX.y*(a*pulse_amount + (1.0 - pulse_amount));
}

void fragment()
{
	ALBEDO = albedo.rgb * COLOR.rgb;
}
