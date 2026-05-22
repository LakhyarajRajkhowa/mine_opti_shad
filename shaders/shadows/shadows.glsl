#include "distort.glsl"

uniform sampler2D shadowtex0;

uniform mat4 shadowModelView;
uniform mat4 shadowProjection;


vec3 GetShadows(vec3 worldPos, float bias)
{
   vec4 shadowPos =
    shadowProjection *
    shadowModelView *
    vec4(worldPos, 1.0);

    shadowPos.xyz /= shadowPos.w;

    shadowPos.xyz = distort(shadowPos.xyz);

    shadowPos.xyz = shadowPos.xyz * 0.5 + 0.5;

    float shadow = 0.0;

    vec2 texelSize = 1.0 / vec2(SHADOW_MAP_RESOLUTION);

    for(int x = -1; x <= 1; x++)
    {
        for(int y = -1; y <= 1; y++)
        {
            vec2 offset = vec2(x, y) * texelSize;

            float depth =
                texture(shadowtex0, shadowPos.xy + offset).r;

            shadow +=
                shadowPos.z - bias <= depth
                ? 1.0
                : 0.0;
        }
    }

    shadow /= 9.0;

    return vec3(shadow);
}