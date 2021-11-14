shader_type spatial;

render_mode depth_draw_never, unshaded, blend_add;

uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_normal;
uniform vec3 uv1_scale = vec3(1.0, 1.0, 1.0);
uniform vec3 uv1_offset;

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb*COLOR.rgb*albedo_tex.rgb;
	DEPTH = 1.0;
}
