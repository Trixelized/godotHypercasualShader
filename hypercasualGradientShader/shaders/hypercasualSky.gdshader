shader_type sky;

#include "hypercasualLib.gdshaderinc"



// Uniforms

uniform float blendSmoothness : hint_range(0.05, 1.0, 0.01) = 1.0;

uniform vec3 colorA : source_color = vec3(0.9, 0.9, 0.9);
uniform vec3 colorB : source_color = vec3(0.6, 0.6, 0.6);

group_uniforms Debanding;
	
	uniform bool deband = true;
	uniform float debandDepth: hint_range(4.0, 256.0, 1.0) = 256.0;
	
group_uniforms;


// Functions

void sky() {
	
	// Copy the eye direction for manipulating.
	vec3 dir = EYEDIR;
	
	float gradient = smoothstep(
		-1.0,
		1.0,
		(dir.y / blendSmoothness)
	);
	
	vec3 finalColor = blendGradient(colorA, colorB, gradient);
	
	if (deband) {
		finalColor += valveDeband(FRAGCOORD.xy, debandDepth);
	}
	
	COLOR = finalColor;
	
}
