/*
	Original code:
	魔法防御シェーダー 3 by あるる（きのもと 結衣）
	Magical Shield Shader 3 by Yui Kinomoto @arlez80.
	
	Modified by Roal-Yr.
	
	Supply this shader with decently detailed 2k noise map.
	
	MIT License.
*/

shader_type spatial;
render_mode unshaded, depth_draw_alpha_prepass;
uniform float rim_strength = 50.0;
uniform vec4 color_surface_hot : hint_color = vec4(0.0, 0.75, 0.9, 1.0);
uniform vec4 color_surface_cold : hint_color = vec4(0.75, 0.94, 1.0, 1.0);
uniform vec4 color_details_major : hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color_details_small : hint_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform sampler2D surface_noise : hint_normal;
uniform float surface_hot_value = 1.0;
uniform float surface_cold_value = 1.0;
uniform float surface_noise_scale = 2.0;
uniform float surface_noise_to_power = 5.65;
uniform float surface_flow = 0.004;

uniform sampler2D major_detail_noise : hint_normal;
uniform float major_detail_strength = 0.17;
uniform float major_detail_filter = 0.992;
uniform float major_detail_scale = 2;
uniform float major_detail_flow = 0.004;

uniform sampler2D small_detail_noise : hint_normal;
uniform float small_detail_strength = 0.145;
uniform float small_detail_filter = 0.991;
uniform float small_detail_scale = 4;
uniform float small_detail_flow = 0.04;

const float pi = 3.1415926535;

void fragment( )
{
	// Edge hardness, like atmosphere haze.
	float rim = clamp(pow( dot( NORMAL, VIEW ), 2.0 )*rim_strength, 0.0, 1.0);
	
	// Surface details major.
	vec2 p = texture(major_detail_noise, -UV*major_detail_scale).xy 
		-TIME*major_detail_flow;
		
	float detail_major = 
		clamp(
			(sin(
				texture(major_detail_noise, p).r * pi) 
					-major_detail_filter
				) * 90.0
			, 0.0, 1.0);
	
	// Surface details small.
	vec2 p_2 = texture(small_detail_noise, -UV*small_detail_scale).xy 
		-TIME*small_detail_flow;
		
	float detail_small = 
		clamp(
			(sin(texture(small_detail_noise, p_2).r * pi) 
				-small_detail_filter)*90.0
			, 0.0, 1.0);

	
	// Surface main colors.
	float surface = 
		pow(
			texture(
				surface_noise, 
				vec2(
					UV.x*surface_noise_scale-TIME*surface_flow, 
					UV.y*surface_noise_scale) 
				).r,
			surface_noise_to_power);

	// Combine surface colors with details. Not clamping it because it makes
	// interesting effects when colors overflow.
	ALBEDO = 
		// Surface hot.
		vec3(
			surface*color_surface_hot.r, 
			surface*color_surface_hot.g, 
			surface*color_surface_hot.b)
		* surface_hot_value
		// Surface cold.
		+ vec3(
			(1.0-surface)*color_surface_cold.r, 
			(1.0-surface)*color_surface_cold.g, 
			(1.0-surface)*color_surface_cold.b)
		* surface_cold_value
		// Details major.
		+ vec3(
			detail_major*color_details_major.r, 
			detail_major*color_details_major.g, 
			detail_major*color_details_major.b)
		* major_detail_strength
		// Details small.
		+ vec3(
			detail_small*color_details_small.r, 
			detail_small*color_details_small.g, 
			detail_small*color_details_small.b)
		* small_detail_strength
		;

	
	// This affects the border of the star, making it more or less sharp.
	ALPHA = rim;

	
}