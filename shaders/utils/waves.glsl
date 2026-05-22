#include "timing.glsl"

vec3 ApplyLeavesWave(vec3 pos, vec2 uv, float strength, float speed)
{
    float time = frameTimeCounter * speed;


    // Scale world space differently for less synchronization
    vec3 p = pos * vec3(0.75, 0.35, 0.75);

    // Base magnitude variation
    float magnitude =
        sin(time * 0.15 + p.x + p.y) * 0.04 + 0.04;

    // Directional phase offsets
    float d0 = sin(time * 0.27);
    float d1 = sin(time * 0.19);
    float d2 = sin(time * 0.23);

    vec3 wave;

    // Chaotic directional interference
    wave.x =
        magnitude *
        sin(time * 1.4 +
            d1 + d2 +
            p.x - p.z + p.y);

    wave.y =
        magnitude *
        sin(time * 0.25 +
            d2 + d0 +
            p.x);

    wave.z =
        magnitude *
        sin(time * 0.9 +
            d0 + d1 -
            p.x + p.z + p.y);

    // Stronger horizontal motion
    wave.x *= 1.8;
    wave.z *= 2.4;

    // Minimal vertical movement
    wave.y *= 0.15;

    // Top vertices move more
    float topMask = smoothstep(0.0, 1.0, uv.y);

    // Add some gusting
    float gust =
        sin(time * 0.12) * 0.5 + 0.5;

    float gustStrength =
        mix(0.7, 1.3, gust);

    // Final displacement
    pos += wave * strength * topMask * gustStrength;

    return pos;
}
