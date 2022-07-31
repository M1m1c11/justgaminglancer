shader_type spatial;
render_mode depth_draw_opaque, blend_mix, cull_disabled, unshaded;

uniform vec4 albedo : hint_color;
uniform float rim_strength = 1.5;
uniform float rim_power = 9.0;
uniform float alpha_global = 0.5;


void fragment()
{
	float rim = clamp(pow(dot(NORMAL,VIEW), rim_power)*rim_strength, 0.0, 1.0);
	ALBEDO = albedo.rgb*COLOR.rgb;
	ALPHA = clamp(1.0-rim, 0.0, 1.0)*alpha_global;
}
