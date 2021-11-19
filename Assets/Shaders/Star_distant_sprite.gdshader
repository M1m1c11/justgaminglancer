// NOTE: Shader automatically converted from Godot Engine 3.4.stable's SpatialMaterial.

shader_type spatial;
render_mode blend_add,depth_draw_never,cull_back,unshaded;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;



void fragment() {
	vec4 albedo_tex = texture(texture_albedo, UV);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	// TODO: See if this shader depth is okay for star sprite.
	DEPTH = 0.9999; // THIS MAY NOT BE THE BEST IDEA!!!
}
