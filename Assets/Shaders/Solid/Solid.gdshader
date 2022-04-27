shader_type spatial;

render_mode depth_draw_opaque, specular_schlick_ggx, cull_back, blend_mix;

uniform vec4 albedo : hint_color;
uniform vec4 emission : hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float specular : hint_range(0,1) = 0.5;
uniform float metallic : hint_range(0,1) = 0.0;
uniform float roughness : hint_range(0,1) = 0.5;
uniform float rim : hint_range(0,1) = 0.01;
uniform float rim_tint : hint_range(0,1) = 0.0;

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
	//DEPTH = log2(max(1e-6, 1.0 -gl_Position.z)) * c;
	
	
	ALBEDO = albedo.rgb*COLOR.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	RIM = rim;
	RIM_TINT = rim_tint;
	EMISSION = emission.rgb*COLOR.rgb;
}
