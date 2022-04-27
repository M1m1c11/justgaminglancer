shader_type spatial;

render_mode depth_draw_never, unshaded, blend_add;

uniform vec4 albedo : hint_color;


void fragment() {
	ALBEDO = albedo.rgb;
	DEPTH = 1.0;
}
