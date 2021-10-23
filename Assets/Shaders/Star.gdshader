/*
	Original code from:
	魔法防御シェーダー 3 by あるる（きのもと 結衣）
	Magical Shield Shader 3 by Yui Kinomoto @arlez80

	MIT License
*/

shader_type spatial;
render_mode unshaded;


uniform vec4 star_color : hint_color = vec4( 0.5, 0.8, 1.0, 1.0 );
uniform float rim_strength = 50.0;

uniform sampler2D surface_noise : hint_normal;
uniform float surface_strength = 1.0;
uniform float surface_flow_speed = 0.02;
uniform float surface_noise_size = 10.0;

uniform sampler2D detail_noise : hint_normal;
uniform float details_strength = 0.6;
uniform float detail_noise_filter = 0.99;
uniform float detail_noise_size = 5;
uniform float details_flow_speed = 0.02;


const float pi = 3.1415926535;

void fragment( )
{
	float rim = clamp(pow( dot( NORMAL, VIEW ), 2.0 ) * rim_strength, 0.0, 1.0);
	
	
	vec2 p = texture( detail_noise, -UV*detail_noise_size).xy + TIME * -details_flow_speed;
	
	// Surface details.
	float detail_pixel = 
		clamp(
			(sin(
				texture(
					detail_noise, 
					p
					).r * pi
				) - detail_noise_filter
			) * 90.0
		, 0.0, 1.0) 
	* details_strength;
	
	// Base surface.
	float surface_pixel = 
		texture(
			surface_noise, 
			vec2(UV.x*surface_noise_size-TIME*surface_flow_speed, UV.y*surface_noise_size) 
		).r * surface_strength;

	// Colors of the surface.
	ALBEDO = vec3(
		detail_pixel+surface_pixel*star_color.r, 
		detail_pixel+surface_pixel*star_color.g, 
		detail_pixel+surface_pixel*star_color.b);
	
	// This affects the border of the star, making it more or less sharp.
	ALPHA = rim;
	
	
}