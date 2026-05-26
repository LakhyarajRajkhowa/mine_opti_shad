#ifndef TONEMAP_GLSL
#define TONEMAP_GLSL

#include "../config/settings.glsl"

// ── ACES Filmic Tone Mapping ─────────────────────────────────────────────────
// Narkowicz 2015 approximation of the full ACES RRT+ODT.
// Fast, single-instruction version used by Complementary, BSL, etc.
vec3 ACESNarkowicz(vec3 x) {
    const float a = 2.51;
    const float b = 0.03;
    const float c = 2.43;
    const float d = 0.59;
    const float e = 0.14;
    return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

// ── Full ACES Input/Output Transforms ───────────────────────────────────────
// Hill 2017 matrix fit — more accurate but slightly more expensive.
// sRGB → ACES AP0 input transform
vec3 ACESFilmic(vec3 color) {
    // Exposure pre-scale (raises scene-linear values into ACES range)
    color *= EXPOSURE;

    // Input matrix: sRGB → ACES AP1 (RRT_SAT)
    mat3 m1 = mat3(
        0.59719, 0.07600, 0.02840,
        0.35458, 0.90834, 0.13383,
        0.04823, 0.01566, 0.83777
    );
    // Output matrix: ACES AP1 → sRGB (ODT_SAT)
    mat3 m2 = mat3(
         1.60475, -0.10208, -0.00327,
        -0.53108,  1.10813, -0.07276,
        -0.07367, -0.00605,  1.07602
    );

    vec3 v = m1 * color;

    // RRT and ODT fit (Fitó 2018 refinement)
    vec3 a = v * (v + 0.0245786) - 0.000090537;
    vec3 b = v * (0.983729 * v + 0.4329510) + 0.238081;

    return clamp(m2 * (a / b), 0.0, 1.0);
}

// ── Color Grading ────────────────────────────────────────────────────────────

// Saturation — scales chroma away from or toward luma
vec3 applySaturation(vec3 color, float saturation) {
    // Rec. 709 luminance weights (matches sRGB display primaries)
    float luma = dot(color, vec3(0.2126, 0.7152, 0.0722));
    return mix(vec3(luma), color, saturation);
}

// Contrast — S-curve pivot around 0.5 in gamma space
vec3 applyContrast(vec3 color, float contrast) {
    // Lift into log space, apply slope, bring back
    color = color - 0.5;
    color = color * contrast + 0.5;
    return clamp(color, 0.0, 1.0);
}

// Lift / Gamma / Gain  (shadows / midtones / highlights)
vec3 applyLiftGammaGain(vec3 color) {
    // Gain scales highlights, gamma shifts midtones, lift raises blacks
    color = color * GAIN + LIFT;
    color = pow(max(color, 0.0), vec3(1.0 / max(GAMMA_SHIFT, 0.001)));
    return clamp(color, 0.0, 1.0);
}

// ── Master Color Grade ───────────────────────────────────────────────────────
// Applied BEFORE tone mapping — operates on scene-linear HDR values.
vec3 ColorGrade(vec3 color) {
    color = applySaturation(color, SATURATION);
    color = applyContrast(color, CONTRAST);
    color = applyLiftGammaGain(color);
    return color;
}

#endif