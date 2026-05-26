
#include "../utils/waves.glsl"

in vec4 mc_Entity;
in vec2 mc_midTexCoord;

in vec2 vaUV0;


vec3 calculateFoilageMotion(const vec3 position){

    vec3 pos = position;

    int blockId = int(mc_Entity.x);

    // grass
    if (blockId == 1 || blockId == 2) {
        pos = ApplyGrassWave(position, vaUV0, mc_midTexCoord, 1.0, 1.0);
    }

    // oak_leaves
    if (blockId == 3) {
        pos = ApplyLeavesWave(position, 2.0);
    }


    return pos;
}