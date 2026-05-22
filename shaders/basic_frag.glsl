#version 330

#define ENABLE_SHADOWS // Enables shadow mapping


#ifdef ENABLE_SHADOWS
    #include "shadows.glsl"
#endif

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

in vec3 foilageColor;
in vec3 normal;
in vec3 worldPos;

in vec2 texCoord;
in vec2 lightMapCoords;

uniform sampler2D gtexture;
uniform sampler2D lightmap;

uniform mat4 gbufferModelViewInverse;

uniform vec3 shadowLightPosition;

uniform float rainStrength;

const vec3 sunlightColor = vec3(1.0, 0.85, 0.7); 
const vec3 skyAmbient = vec3(0.55, 0.65, 0.9);
const vec3 groundAmbient = vec3(0.18, 0.16, 0.14);

const float sunlightIntensity = 0.85f;
const float _ShadowBias = 0.0002f;
const float ambientMultiplier = 1.25;
const float specularMultiplier = 0.5;


vec3 calculateShadows(const vec3 lightColor)
{
#ifdef ENABLE_SHADOWS
    vec3 shadow = GetShadows(worldPos, _ShadowBias);
    shadow = mix(shadow, 0.2f + (lightColor / 2.0f), rainStrength);
    return shadow;
#else
    return vec3(1.0);
#endif
}

vec3 calculateAmbient(const vec3 lightColor, const vec3 worldNormal){
    float upFactor = worldNormal.y * 0.5 + 0.5;
    vec3 ambientColor = mix(groundAmbient, skyAmbient, upFactor);

    return ambientColor * lightColor * ambientMultiplier;
}

vec3 calculateSpecular(const vec3 viewDir, const vec3 worldNormal, const vec3 lightDir){
    vec3 halfDir = normalize(lightDir + viewDir);
    float spec = pow(max(dot(worldNormal, halfDir), 0.0), 32.0);

    return sunlightColor * spec * specularMultiplier;
}

float calculateFresnel(const vec3 viewDir, const vec3 worldNormal){
    return pow(1.0 - max(dot(worldNormal, viewDir), 0.0), 5.0);

}

void main(){
    vec3 viewDir = normalize(-worldPos);

    // --- ALBEDO ---
    vec4 albedo = texture(gtexture, texCoord);
    albedo.rgb *= foilageColor; // optional: gamma correction

    // --- ALPHA DISCARD ---
    float transparency = albedo.a;
    if(transparency < 0.1){
        discard;
    }

    // --- LIGHTING ---
    vec3 lightColor = texture(lightmap, lightMapCoords).rgb; // optional: gamma correction
    vec3 lightDir = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);

     // --- NORMAL ---
    vec3 worldNormal = normalize(mat3(gbufferModelViewInverse) * normal);
    float nDotL = max(dot(worldNormal, lightDir), 0.0);
    
    // --- SHADOWS ---
   vec3 shadow = calculateShadows(lightColor);
   
    // --- DIFFUSE ---
    vec3 diffuse = vec3(nDotL) * shadow;

    // --- AMBIENT ---
    vec3 ambient = calculateAmbient(lightColor, worldNormal);

    // --- SPECULAR ---
    vec3 specular = calculateSpecular(viewDir, worldNormal, lightDir);


    // --- DIRECT LIGHT ---
    vec3 direct = sunlightColor * vec3(sunlightIntensity) * diffuse * lightColor ;

    // --- FINAL LIGHTING ---
    vec3 lighting = direct + ambient + specular;

    // --- FINAL COLOR ---
    vec3 finalColorData = albedo.rgb  * lighting;
    vec4 finalColor = vec4(finalColorData, transparency); // optional: gamma correction


    outColor0 = finalColor;   
}

