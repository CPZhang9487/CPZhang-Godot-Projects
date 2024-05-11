shader_type spatial;


uniform vec4 color: source_color = vec4(1, 1, 1, 1);


void fragment() {
	ALBEDO = color.rgb;
	ALPHA = color.a;
}


void light() {
	DIFFUSE_LIGHT = vec3(1.0, 1.0, 1.0);
}
