#version 330

in vec3 vaPosition;
in vec2 vaUV0;

out vec2 texCoord;

void main() {
    texCoord    = vaUV0;
    gl_Position = vec4(vaPosition * 2.0 - 1.0, 1.0);
}