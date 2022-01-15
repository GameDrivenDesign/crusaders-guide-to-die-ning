shader_type spatial;

uniform bool hovered = false;

void fragment() {
	if (hovered) {
		ALBEDO = vec3(0.5, 0, 0);
	} else {
		ALBEDO = vec3(1, 0, 0);
	}
}