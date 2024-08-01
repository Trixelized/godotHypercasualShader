

// Used for blending colors for the gradients ONLY!
// This very simple mix, but allows for easy overwriting.
// Go nuts! This can make things look very stylish.
vec3 blendGradient(vec3 colA, vec3 colB, float amt) {
	
	return mix(colA, colB, amt);
	
	// A fun example of what changing this function can do:
	// return mix(colA, colB, sin((amt + TIME * 0.25) * TAU));
	
}

// Darker colors, especially on mobile screens, can make gradients look choppy.
// This is a simple dither-like algorithm used to 'deband' the final color.
// https://www.shadertoy.com/view/4dcSRX
vec3 valveDeband(vec2 screenUV, float colorDepth, float time) {
    vec3 dither = vec3(dot(vec2(131.0, 312.0), screenUV.xy + time));
    dither = fract(dither / vec3(103.0, 71.0, 97.0)) - vec3(0.5, 0.5, 0.5);
    return (dither / colorDepth) * 0.375;
}

