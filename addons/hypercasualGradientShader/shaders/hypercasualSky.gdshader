shader_type sky;

// Include the library, containing some shared functions.
#include "hypercasualLib.gdshaderinc"



// Uniforms.
// Their names should be pretty self-explanatory.

uniform float blendSmoothness : hint_range(0.05, 1.0, 0.01) = 1.0;

uniform vec3 colorA : source_color = vec3(0.9, 0.9, 0.9);
uniform vec3 colorB : source_color = vec3(0.6, 0.6, 0.6);

group_uniforms Debanding;
	
	uniform bool deband = true;
	uniform float debandDepth: hint_range(4.0, 256.0, 1.0) = 256.0;
	
group_uniforms;



// Functions.

// Whenever the sky is sampled.
void sky() {
	
	// Calculate the gradient.
	// Since EYEDIR is always a normalized value, we can use the -1 to 1 range.
	float gradient = smoothstep(
		-1.0,
		1.0,
		(EYEDIR.y / blendSmoothness)
	);
	
	// Mix the colors based on the gradient.
	vec3 finalColor = blendGradient(colorA, colorB, gradient);
	
	if (deband) {
		finalColor += valveDeband(FRAGCOORD.xy, debandDepth, TIME);
	}
	
	COLOR = finalColor;
	
}
