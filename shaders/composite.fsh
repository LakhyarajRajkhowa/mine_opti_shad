#version 330

#include "program/tonemap.glsl"

uniform sampler2D colortex0;
in  vec2 texCoord;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

void main() {
    vec3 color = texture(colortex0, texCoord).rgb;
  //  color = ColorGrade(color);
  //  color = ACESFilmic(color);
    outColor0 = vec4(color, 1.0);
}