shader_type spatial;
render_mode depth_draw_opaque, cull_disabled, unshaded;

uniform vec4 albedo : hint_color;
uniform float rim_strength = 0.05;
uniform float rim_power = 9.0;

void fragment() {
	float rim = clamp(pow( dot( NORMAL, VIEW ), rim_power)*rim_strength, 0.0, 1.0);
	ALBEDO = albedo.rgb;
	ALPHA = rim;
}
