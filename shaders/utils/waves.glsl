#include "timing.glsl"

vec3 ApplyLeavesWave(vec3 pos, float speed)
{
    float time = frameTimeCounter * speed;

    // Compress world pos — tighter Y keeps canopy blocks in phase
    vec3 p = pos * vec3(0.75, 0.375, 0.75);

    float magnitude = sin(time * 0.15 + p.x + p.y) * 0.04 + 0.04;

    float d0 = sin(time * 0.27);
    float d1 = sin(time * 0.19);
    float d2 = sin(time * 0.23);

    vec3 wave;
    wave.x = magnitude * sin(time * 1.4 + d1 + d2 + p.x - p.z + p.y);
    wave.y = magnitude * sin(time * 0.25 + d2 + d0 + p.x);
    wave.z = magnitude * sin(time * 0.9  + d0 + d1 - p.x + p.z + p.y);

    // Z is dominant (wind direction), Y rustles up/down, X secondary sway
    wave *= vec3(4.0, 3.0, 8.0);

    // No topMask — leaves are a full block, all vertices move equally
    // No gust multiplier needed — magnitude variation handles that already

    return pos + wave * 0.1;
}

vec3 ApplyGrassWave(vec3 pos, vec2 uv, vec2 midUV, float strength, float speed)
{
    float time = frameTimeCounter * speed;

    // Top-half mask using the sprite midpoint.
    // uv.t < midUV.t means this vertex is in the upper half of the sprite.
    // Bottom vertices get topMask == 0 and don't move — root stays anchored.
    float topMask = (uv.t < midUV.t) ? 1.0 : 0.0;

    float phase   = pos.x * 0.7 + pos.z * 0.5;
    float sway    = sin(time * 1.8 + phase) * 0.04;
    float flutter = sin(time * 3.1 + phase * 1.3) * 0.012;
    float gust    = sin(time * 0.4) * 0.5 + 0.5;

    vec3 wave = vec3(0.0);
    wave.x = (sway + flutter) * mix(0.8, 1.2, gust);
    wave.z = flutter * 0.6;

    return pos + wave * strength * topMask;
}