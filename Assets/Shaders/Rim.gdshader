shader_type spatial;
render_mode depth_draw_opaque, cull_disabled, unshaded;

uniform vec4 albedo : hint_color;

uniform float rim_strength = 2.5;
uniform float inner_rim_power = 4.0;
uniform float outer_rim_power = 4.0;

void fragment() {
	float rim_inner = clamp(pow( dot( NORMAL, VIEW ), inner_rim_power )*rim_strength, 0.0, 1.0);
	float rim_outer = clamp(pow( dot( NORMAL, VIEW ), outer_rim_power )*rim_strength, 0.0, 1.0);

	ALBEDO = albedo.rgb;
	ALPHA = rim_outer*(1.0-rim_inner);
}
