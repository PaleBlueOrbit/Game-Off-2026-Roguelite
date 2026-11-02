shader_type canvas_item;

// --- Palette Swap Uniforms ---
// How many colors are in your original slime sprite palette?
const int PALETTE_SIZE = 3; 

// The exact original colors of your sprite (adjust these to match your artwork!)
uniform vec4 base_palette[PALETTE_SIZE] : source_color;

// The new colors you want to swap them with
uniform vec4 target_palette[PALETTE_SIZE] : source_color;

// How strictly to match the colors (keeps compression/artifacts from breaking the swap)
uniform float precision : hint_range(0.0, 0.1) = 0.01;

// --- Hit Flash Uniforms ---
uniform vec4 flash_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Default Red
uniform float flash_modifier : hint_range(0.0, 1.0) = 0.0;          // 0 = normal, 1 = fully flashed

void fragment() {
    // Get the original pixel color from the sprite sheet
    vec4 current_color = texture(TEXTURE, UV);
    vec4 final_color = current_color;

    // 1. Palette Swap Logic
    // Only swap if the pixel isn't fully transparent
    if (current_color.a > 0.0) {
        for (int i = 0; i < PALETTE_SIZE; i++) {
            // Check if the current pixel matches a color in our base palette
            if (distance(current_color.rgb, base_palette[i].rgb) < precision) {
                // Swap it with the target palette color while preserving original alpha
                final_color = vec4(target_palette[i].rgb, current_color.a);
                break; 
            }
        }
    }

    // 2. Hit Flash Logic
    // Blend between the swapped palette color and your flash color based on the modifier
    final_color.rgb = mix(final_color.rgb, flash_color.rgb, flash_modifier);

    // Output the final pixel color to the screen
    COLOR = final_color;
}
