/*
	Original code:
	魔法防御シェーダー 3 by あるる（きのもと 結衣）
	Magical Shield Shader 3 by Yui Kinomoto @arlez80.
	
	Modified by Roal-Yr.
	
	Supply this shader with decently detailed 2k noise map.
	
	MIT License.
*/

shader_type spatial;
render_mode unshaded, depth_draw_opaque;
uniform vec4 color_surface_hot : hint_color = vec4(1.0, 0.9, 0.4, 1.0);
uniform vec4 color_details_major : hint_color = vec4(0.0, 0.9, 1.0, 1.0);
uniform vec4 color_details_small : hint_color = vec4(1.0, 1.0, 0.0, 1.0);

uniform sampler2D major_detail_noise : hint_normal;
uniform float major_detail_phase = 0.996;
uniform float major_detail_scale = 1;
uniform float major_detail_flow = 0.02;

uniform sampler2D small_detail_noise : hint_normal;
uniform float small_detail_phase = 0.99;
uniform float small_detail_scale = 3;
uniform float small_detail_flow = 0.2;

const float pi = 3.1415926535;

// For logarithmic depth buffer.
const float c = 0.001;
varying vec4 gl_Position;

void vertex()
{
	// For logarithmic depth buffer.
	gl_Position = MODELVIEW_MATRIX*vec4(VERTEX, 1.0);
}

void fragment()
{
	// Logarithmic depth buffer.
	DEPTH = log2(max(1e-6, 1.0 -gl_Position.z)) * c;
	

	// Surface details major.
	vec2 p = texture(major_detail_noise, -UV*major_detail_scale).xy 
		-TIME*major_detail_flow;
	vec2 p2 = texture(small_detail_noise, -UV*small_detail_scale).xy 
		-TIME*small_detail_flow;
	
	float detail_major = sin(texture(major_detail_noise, p).r*pi+major_detail_phase);
	float detail_small = sin(texture(small_detail_noise, p2).r*pi+small_detail_phase);

	
	// Combine surface colors with details. Not clamping it because it makes
	// interesting effects when colors overflow.
	ALBEDO = 
		color_surface_hot.rgb
		+detail_major*color_details_major.rgb
		+detail_small*color_details_small.rgb;
	//ALBEDO = vec3(DEPTH, DEPTH, DEPTH);
	// This is may be needed by alpha sorting.
	//ALPHA = 1.0;
}