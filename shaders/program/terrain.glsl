
#include "../utils/waves.glsl"

in vec4 mc_Entity;

in vec2 vaUV0;


vec3 calculateFoilageMotion(const vec3 position){

    vec3 pos = position;

    int blockId = int(mc_Entity.x);

    // grass 
    // if(blockId == 1){
    //     pos = ApplyGrassWave(position, vaUV0, 1.0, 1.0);
    // }

    // oak_leaves
    if(blockId == 2){
        pos = ApplyLeavesWave(position, vaUV0, 200.0, 2.0);
    }

    return pos;
}