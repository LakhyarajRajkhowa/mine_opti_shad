// Shadows
#define SHADOW_DISTORT_ENABLED // Toggles shadow map distortion
#define SHADOW_DISTORT_FACTOR 0.10 // [0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20]
#define SHADOW_BIAS 0.15 // [0.00 0.01 0.02 0.03 0.04 0.05 0.10 0.15 0.20 0.25 0.50 1.00]
#define NORMAL_BIAS // Offsets the sample position using surface normal
#define EXCLUDE_FOLIAGE // Foliage will not cast shadows
#define SHADOW_BRIGHTNESS 0.75 // [0.00 0.05 0.10 0.15 0.20 0.25 0.50 0.75 1.00]
#define SHADOW_MAP_RESOLUTION 1024 // [128 256 512 1024 2048 4096 8192]


// ── Tone Mapping & Color Grade ───────────────────────────────────────────────
#define EXPOSURE     1.0   // [0.25 0.5 0.75 1.0 1.25 1.5 2.0 3.0]
#define SATURATION   1.1   // [0.0 0.5 0.75 1.0 1.1 1.25 1.5 2.0]
#define CONTRAST     1.05  // [0.5 0.75 0.9 1.0 1.05 1.1 1.25 1.5]
#define LIFT         0.0   // [-0.05 -0.02 0.0 0.02 0.05]
#define GAIN         1.0   // [0.5 0.75 1.0 1.1 1.25 1.5]
#define GAMMA_SHIFT  1.0   // [0.7 0.8 0.9 1.0 1.1 1.2 1.4]
