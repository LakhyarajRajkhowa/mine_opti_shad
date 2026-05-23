#version 330

#define ENABLE_SHADOWS

#ifdef ENABLE_SHADOWS
    #include "../shadows/shadows.glsl"
#endif

#include "lighting/lighting.glsl"
#include "fog.glsl"

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

in vec3 foilageColor;
in vec3 normal;
in vec3 worldPos;
in vec3 playerPos;

in vec2 texCoord;
in vec2 lightMapCoords;

uniform sampler2D gtexture;
uniform sampler2D lightmap;

uniform mat4 gbufferModelViewInverse;
uniform vec3 shadowLightPosition;

const float _ShadowBias = 0.0002;


vec3 calculateShadows(const vec3 lightColor) {
#ifdef ENABLE_SHADOWS
    vec3 shadow = GetShadows(worldPos, _ShadowBias);
    shadow = mix(shadow, vec3(0.35) + lightColor * 0.4, rainStrength);
    return shadow;
#else
    return vec3(1.0);
#endif
}


void main() {
    // --- ALBEDO ---
    vec4 albedo = texture(gtexture, texCoord);
    albedo.rgb *= foilageColor;

    if (albedo.a < 0.1) discard;

    // --- LIGHTMAP ---
    vec3  lightColor    = texture(lightmap, lightMapCoords).rgb;
    float skylightLevel = texture(lightmap, lightMapCoords).g;

    // --- VECTORS ---
    vec3 viewDir     = normalize(-worldPos);
    vec3 worldNormal = normalize(mat3(gbufferModelViewInverse) * normal);
    vec3 lightDir    = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);

    // --- SHADOWS ---
    vec3 shadow = calculateShadows(lightColor);

    // --- LIGHTING ---
    vec3 lighting = calculateLighting(worldNormal, viewDir, lightDir, lightColor, skylightLevel, shadow);

    // --- FINAL COLOR ---
    vec4 finalColor = vec4(clamp(albedo.rgb * lighting, 0.0, 1.0), albedo.a);
    finalColor = applyBorderFog(finalColor, playerPos);

    outColor0 = finalColor;
}