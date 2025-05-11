shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	float silhouette_alpha = texture(TEXTURE, UV * 0.975 + 0.0125).a;
	vec4 color_silhouette = vec4(vec3(1.0, 0.0, 0.0),COLOR.a);
	COLOR = mix(COLOR, color_silhouette, 1.0 - COLOR.a * 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
