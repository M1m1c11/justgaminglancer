shader_type spatial;
render_mode depth_draw_opaque, blend_mix, cull_disabled, unshaded;

uniform vec4 albedo : hint_color;
uniform float rim_strength = 1.5;
uniform float rim_power = 9.0;
uniform float rim_strength_inner = 1.5;
uniform float rim_power_inner = 9.0;

uniform sampler2D displacement_texture;
uniform float displacement_scale = 0.02;
uniform float displacement_velocity = 0.01;


void vertex() {
	vec2 tex_position_x = VERTEX.yz / 1.0 - TIME*displacement_velocity;
	vec2 tex_position_y = VERTEX.xz / 1.0 + TIME*displacement_velocity;
	vec2 tex_position_z = VERTEX.xy / 1.0 - TIME*displacement_velocity;
	
	float displacement_x = 2.0*texture(displacement_texture, tex_position_x).r-1.0;
	float displacement_y = 2.0*texture(displacement_texture, tex_position_y).r-1.0;
	float displacement_z = 2.0*texture(displacement_texture, tex_position_z).r-1.0;
	
	VERTEX.z += displacement_z * displacement_scale;
	VERTEX.x += displacement_x * displacement_scale;
	VERTEX.y += displacement_y * displacement_scale;
}

void fragment()
{	
	float rim = clamp(pow(dot(NORMAL, VIEW), rim_power)*rim_strength, 0.0, 1.0);
	float rim_inner = clamp(pow(dot(NORMAL, VIEW), rim_power_inner)*rim_strength_inner, 0.0, 1.0);
	ALBEDO = albedo.rgb*COLOR.rgb;
	ALPHA = clamp(1.0-rim_inner, 0.0, 1.0)*clamp(rim, 0.0, 1.0);
}
