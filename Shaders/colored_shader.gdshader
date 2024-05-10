shader_type spatial;


uniform vec4 color: source_color = vec4(1, 1, 1, 1);


void fragment() {
	ALBEDO = color.rgb;
	ALPHA = color.a;
}
