shader_type canvas_item;

uniform bool enable_flash = false;

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    if (enable_flash) {
        COLOR = vec4(1.0, 1.0, 1.0, color.a); // White flash
    } else {
        COLOR = color; // Normal appearance
    }
}
