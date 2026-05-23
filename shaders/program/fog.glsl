uniform float fogEnd;    
uniform vec3  fogColor;   

uniform float rainStrength;    


vec4 applyBorderFog(vec4 color, vec3 playerPos) {
    float dist = max(length(playerPos.xz), abs(playerPos.y));

    float fog = clamp((dist) / (fogEnd), 0.0, 1.0);
    fog = 1.0 - exp(-3.0 * pow(fog, 4.0));

    if (fog > 0.0) {
        color = mix(color, vec4(fogColor, 0.0), fog);
    }

    return color;
}