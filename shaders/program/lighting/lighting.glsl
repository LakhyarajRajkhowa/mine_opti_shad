#ifndef LIGHTING_GLSL
#define LIGHTING_GLSL

#include "../../utils/GGX.glsl"

const vec3 sunlightColor = vec3(1.0, 0.85, 0.7); 
const vec3 skyAmbient    = vec3(0.55, 0.65, 0.9);
const vec3 groundAmbient = vec3(0.18, 0.16, 0.14);

const float sunlightIntensity   = 0.85;
const float ambientMultiplier   = 1.25;
const float specularMultiplier  = 0.1;


vec3 calculateAmbient(float skylightLevel, const vec3 worldNormal) {
    float upFactor     = worldNormal.y * 0.5 + 0.5;
    vec3 ambientColor  = mix(groundAmbient, skyAmbient, upFactor);
    return ambientColor * skylightLevel * ambientMultiplier;
}

vec3 calculateSpecular(float skylightLevel, const vec3 viewDir, const vec3 worldNormal, const vec3 lightDir) {
    float spec = GGX(worldNormal, viewDir, lightDir, 0.5);
    return sunlightColor * spec * specularMultiplier * skylightLevel;
}

float calculateFresnel(const vec3 viewDir, const vec3 worldNormal) {
    return pow(1.0 - max(dot(worldNormal, viewDir), 0.0), 5.0);
}

vec3 calculateLighting(
    const vec3  worldNormal,
    const vec3  viewDir,
    const vec3  lightDir,
    const vec3  lightColor,
    float       skylightLevel,
    const vec3  shadow
) {
    float nDotL = max(dot(worldNormal, lightDir), 0.0);

    vec3 diffuse  = vec3(nDotL) * shadow;
    vec3 direct   = sunlightColor * sunlightIntensity * diffuse;
    vec3 ambient  = calculateAmbient(skylightLevel, worldNormal);
    vec3 specular = calculateSpecular(skylightLevel, viewDir, worldNormal, lightDir);

    return (direct + ambient + specular) * lightColor;
}

#endif