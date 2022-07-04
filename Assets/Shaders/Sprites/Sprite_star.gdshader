shader_type spatial;
render_mode unshaded;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float scale = 0.1;

void vertex() {
	MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0],CAMERA_MATRIX[1],CAMERA_MATRIX[2],WORLD_MATRIX[3]);
	if (PROJECTION_MATRIX[3][3] != 0.0) {
		float h = abs(1.0 / (2.0 * PROJECTION_MATRIX[1][1]));
		float sc = (h * 2.0)*scale; //consistent with Y-fov
		MODELVIEW_MATRIX[0]*=sc;
		MODELVIEW_MATRIX[1]*=sc;
		MODELVIEW_MATRIX[2]*=sc;
	} else {
		float sc = -(MODELVIEW_MATRIX)[3].z*scale;
		MODELVIEW_MATRIX[0]*=sc;
		MODELVIEW_MATRIX[1]*=sc;
		MODELVIEW_MATRIX[2]*=sc;
	}
}

void fragment() {
	vec4 albedo_tex = texture(texture_albedo,UV);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	ALPHA = albedo.a * albedo_tex.a;
}
