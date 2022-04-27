shader_type spatial;
render_mode depth_draw_opaque, blend_add, cull_front, unshaded;

uniform vec4 albedo : hint_color;
uniform float rim_strength = 0.05;
uniform float rim_power = 9.0;

void fragment()
{
	float rim = clamp(pow( 
			clamp(dot( NORMAL, VIEW ), 0.0, 1.0)
		, rim_power)*rim_strength, 0.0, 1.0);
	ALBEDO = albedo.rgb*COLOR.rgb;
	ALPHA = rim;
}
