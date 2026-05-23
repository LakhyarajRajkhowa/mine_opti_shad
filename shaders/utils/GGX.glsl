float GGX(vec3 N, vec3 V, vec3 L, float roughness) {
    vec3  H     = normalize(V + L);
    float NdotH = max(dot(N, H), 0.0);
    float a     = roughness * roughness;
    float a2    = a * a;
    float denom = NdotH * NdotH * (a2 - 1.0) + 1.0;
    return a2 / (3.14159 * denom * denom);
}