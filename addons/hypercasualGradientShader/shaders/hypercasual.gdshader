shader_type spatial;
render_mode unshaded;

// Include the library, containing some shared functions.
#include "hypercasualLib.gdshaderinc"



// Uniforms.
// Their names should be pretty self-explanatory.

uniform bool useWorldSpace = false;

uniform float gradientOffset = 0.0;
uniform float gradientSize = 1.0;

uniform float blendSmoothness: hint_range(0.05, 1.0, 0.01) = 0.5;

group_uniforms Colors;
	uniform vec3 colorTop: source_color = vec3(1.0, 1.0, 1.0);
	uniform vec3 colorBottom: source_color = vec3(0.2, 0.2, 0.2);
	group_uniforms Colors.Front;
	uniform vec3 colorFrontTop: source_color = vec3(0.8, 0.8, 0.8);
	uniform vec3 colorFrontBottom: source_color = vec3(0.6, 0.6, 0.6);
	group_uniforms Colors.Back;
	uniform vec3 colorBackTop: source_color = vec3(0.8, 0.8, 0.8);
	uniform vec3 colorBackBottom: source_color = vec3(0.6, 0.6, 0.6);
	group_uniforms Colors.Left;
	uniform vec3 colorLeftTop: source_color = vec3(0.6, 0.6, 0.6);
	uniform vec3 colorLeftBottom: source_color = vec3(0.4, 0.4, 0.4);
	group_uniforms Colors.Right;
	uniform vec3 colorRightTop: source_color = vec3(0.6, 0.6, 0.6);
	uniform vec3 colorRightBottom: source_color = vec3(0.4, 0.4, 0.4);
group_uniforms;

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



// Varyings

varying vec3 position;
varying vec3 normal;



// Functions

// Pass info from vertex to fragment.
void vertex() {
	
	// Apply matrix calculations if we're using world space.
	if (useWorldSpace) {
		position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
		normal = (MODEL_NORMAL_MATRIX * NORMAL);
	} else {
		position = VERTEX;
		normal = NORMAL;
	}
	
}

// The fragment (per-pixel) logic.
void fragment() {
	
	// Get the current gradient value from 0 to 1.
	// Smoothstep makes it both pretty and fast!
	float halfSize = (gradientSize / 2.0);
	float gradient = smoothstep(
		gradientOffset + halfSize,
		gradientOffset - halfSize,
		position.y
	);
	
	// Get the final four directional colors based on the gradient value.
	// Combined with top and bottom, that makes six.
	// After this, we don't need to worry about gradients anymore.
	vec3 colorFront = blendGradient(colorFrontTop, colorFrontBottom, gradient);
	vec3 colorBack = blendGradient(colorBackTop, colorBackBottom, gradient);
	vec3 colorLeft = blendGradient(colorLeftTop, colorLeftBottom, gradient);
	vec3 colorRight = blendGradient(colorRightTop, colorRightBottom, gradient);
	
	// Get the correct color for each axis, based on the normal.
	vec3 colX = mix(colorLeft, colorRight, step(0.0, normal.x));
	vec3 colY = mix(colorBottom, colorTop, step(0.0, normal.y));
	vec3 colZ = mix(colorBack, colorFront, step(0.0, normal.z));
	
	// Calculate the weighted normal. This makes each axis stand out.
	// Then get the absolute. We already know the right axis' color.
	vec3 weightedNormal = pow(abs(normal), vec3(1.0 / blendSmoothness));
	vec3 absNormal = abs(weightedNormal);
	
	// Get the sum of the new normal, then normalize.
	// This makes sure everything adds up to 1.
	float normalSum = absNormal.x + absNormal.y + absNormal.z;
	absNormal /= normalSum;
	
	// Blend the final colors based on their weight.
	vec3 finalColor = (
		colX * absNormal.x +
		colY * absNormal.y +
		colZ * absNormal.z
	);
	
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
