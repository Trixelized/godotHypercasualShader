

// Used for blending colors for the gradient ONLY!
// Allows for quick changing of the gradient logic.
vec3 blendGradient(vec3 colA, vec3 colB, float amt) {
	
	return mix(colA, colB, amt);
	
}

// Used for debanding.
// Based on https://www.shadertoy.com/view/4dcSRX
vec3 valveDeband(vec2 screenUV, float colorDepth) {
    vec3 dither = vec3(dot(vec2(131.0, 312.0), screenUV.xy + TIME));
    dither = fract(dither / vec3(103.0, 71.0, 97.0)) - vec3(0.5, 0.5, 0.5);
    return (dither / colorDepth) * 0.375;
}

