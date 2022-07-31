shader_type spatial;
render_mode depth_draw_opaque, blend_add, cull_front, unshaded;

uniform vec4 albedo : hint_color;
uniform float rim_strength = 1.5;
uniform float rim_power = 9.0;
uniform float rim_strength_inner = 1.5;
uniform float rim_power_inner = 9.0;


void fragment()
{
	float rim = clamp(pow(dot(NORMAL, VIEW), rim_power)*rim_strength, 0.0, 1.0);
	float rim_inner = clamp(pow(dot(NORMAL, VIEW), rim_power_inner)*rim_strength_inner, 0.0, 1.0);
	ALBEDO = albedo.rgb*COLOR.rgb;
	ALPHA = clamp(1.0-rim_inner, 0.0, 1.0)*clamp(rim, 0.0, 1.0);
}
