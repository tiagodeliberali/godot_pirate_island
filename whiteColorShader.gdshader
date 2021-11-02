shader_type canvas_item;

uniform bool active = true;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (active) {
		color = vec4(1.0,1.0,1.0,color.a);
	}
	COLOR = color;
}