shader_type canvas_item;

uniform vec4 color : hint_color;
uniform float flashState : hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	COLOR = mix(pixelColor, color, flashState);
	COLOR.a *= pixelColor.a;
}