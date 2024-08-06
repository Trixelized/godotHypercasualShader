shader_type spatial;
render_mode unshaded;

// Include the library, containing some shared functions.
#include "hypercasualLib.gdshaderinc"



// Uniforms.
// Their names should be pretty self-explanatory.

uniform vec3 color: source_color = vec3(1.0, 1.0, 1.0);

group_uniforms Texture;

	uniform bool useTexture = false;
	uniform sampler2D textureSource:
		source_color,
		hint_default_transparent,
		filter_linear_mipmap;

group_uniforms;

group_uniforms Debanding;
	
	uniform bool deband = true;
	uniform float debandDepth: hint_range(4.0, 256.0, 1.0) = 256.0;
	
group_uniforms;



// Functions

// The fragment (per-pixel) logic.
void fragment() {
	
	// We already know the color! ;)
	vec3 finalColor = color;
	
	// Add the texture if enabled.
	if (useTexture) {
		vec4 tex = texture(textureSource, UV);
		finalColor = mix(
			finalColor,
			tex.rgb,
			tex.a
		);
	}
	
	if (deband) {
		finalColor += valveDeband(FRAGCOORD.xy, debandDepth, TIME);
	}
	
	ALBEDO = finalColor * COLOR.rgb;
	
}
