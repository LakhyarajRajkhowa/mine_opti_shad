#version 330 

#include "terrain.glsl"

in vec4 vaColor;

in vec3 vaPosition;
in vec3 vaNormal;

in ivec2 vaUV2;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 gbufferModelViewInverse;


uniform mat3 normalMatrix;

uniform vec3 cameraPosition;
uniform vec3 chunkOffset;


out vec3 foilageColor;
out vec3 normal;
out vec3 worldPos;
out vec3 playerPos;

out vec2 texCoord;
out vec2 lightMapCoords;


void main(){
    texCoord = vaUV0;

    normal = normalize(normalMatrix * vaNormal);

    lightMapCoords = vaUV2 * (1.0 / 256.0) + (1.0 / 32.0);

    foilageColor = vaColor.rgb;

    vec3 pos = vaPosition + chunkOffset;

    pos = calculateFoilageMotion(pos);

    playerPos = pos ;
    worldPos = pos;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}
