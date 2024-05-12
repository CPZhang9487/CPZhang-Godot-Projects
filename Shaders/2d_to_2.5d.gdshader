shader_type canvas_item;


uniform float rotation_x: hint_range(-180, 180) = 0.0;
uniform float rotation_y: hint_range(-180, 180) = 0.0;
uniform float rotation_z: hint_range(-180, 180) = 0.0;


mat4 get_rotatex_trans(float theta) {
    return mat4(
        vec4(1, 0, 0, 0),
        vec4(0, cos(theta), -sin(theta), 0),
        vec4(0, sin(theta), cos(theta), 0),
        vec4(0, 0, 0, 1)
    );
}


mat4 get_rotatey_trans(float theta) {
    return mat4(
        vec4(cos(theta), 0, -sin(theta), 0),
        vec4(0, 1, 0, 0),
        vec4(sin(theta), 0, cos(theta), 0),
        vec4(0, 0, 0, 1)
    );
}


mat4 get_rotatez_trans(float theta) {
    return mat4(
        vec4(cos(theta), -sin(theta), 0, 0),
        vec4(sin(theta), cos(theta), 0, 0),
        vec4(0, 0, 1, 0),
        vec4(0, 0, 0, 1)
    );
}


mat4 get_scale_trans(float scale) {
    return mat4(
        vec4(scale, 0, 0, 0),
        vec4(0, scale, 0, 0),
        vec4(0, 0, scale, 0),
        vec4(0, 0, 0, 1)
    );
}


mat4 get_translate_trans(vec3 translation) {
    return mat4(
        vec4(1, 0, 0, translation[0]),
        vec4(0, 1, 0, translation[1]),
        vec4(0, 0, 1, translation[2]),
        vec4(0, 0, 0, 1)
    );
}


void vertex() {
	vec4 vertex = vec4(VERTEX, 0, 1);
	vertex *= get_rotatex_trans(rotation_x / 180.0 * PI);
	vertex *= get_rotatey_trans(rotation_y / 180.0 * PI);
	vertex *= get_rotatez_trans(rotation_z / 180.0 * PI);
	VERTEX = vertex.xy;
}


void fragment() {
}
