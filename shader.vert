#version 330 core

layout (location = 0) in vec3 aPos;

uniform float time; // Time variable
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out vec3 ecPosition;
out vec3 ecNormal;

const int NUM_WAVES = 50;
const float PI = 3.14159265359;


// Pseudo-random function to generate random numbers based on position - ChatGPT
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Get random 2D direction - ChatGPT
vec2 randomDirection(vec2 st) {
    // Generate a random angle between 0 and 2*PI
    float angle = random(st) * 2.0 * PI;
    // Convert angle into 2D direction (unit vector)
    return vec2(cos(angle), sin(angle));
}

float getWaveHeight(float amplitude, float frequency, float timeShift, vec2 direction, vec2 xz) {
//    return amplitude * sin(dot(direction, xz) * frequency + timeShift);
    return amplitude * exp(sin(dot(direction, xz) * frequency + timeShift) - 1);
}

float getWaveHeight_x(float amplitude, float frequency, float timeShift, vec2 direction, vec2 xz) {
    float cosineTerm = cos(dot(direction, xz) * frequency + timeShift);
    return direction.x * frequency * amplitude * exp(sin(dot(direction, xz) * frequency + timeShift) - 1) * cosineTerm;
//    return direction.x * frequency * amplitude * cos(dot(direction, xz) * frequency + timeShift);
}

float getWaveHeight_z(float amplitude, float frequency, float timeShift, vec2 direction, vec2 xz) {
    float cosineTerm = cos(dot(direction, xz) * frequency + timeShift);
    return direction.y * frequency * amplitude * exp(sin(dot(direction, xz) * frequency + timeShift) - 1) * cosineTerm;
//    return direction.y * frequency * amplitude * cos(dot(direction, xz) * frequency + timeShift);
}
void main() {
    // Sinusoidal wave: Asin((D dot (x,z)) * omega + t * phi)
    float waveHeight = 0.0;
    float waveHeight_x = 0.0;
    float waveHeight_z = 0.0;

    float amplitude = 0.08;
    float frequency = 2.0;
    float iter = 0.0; // to generate random direction
    float timeMultiplier = 2.0;

    float prevWaveHeight_x = 0.0;
    float prevWaveHeight_z = 0.0;
    for (int i = 0; i < NUM_WAVES; i++) {
        vec2 xz = aPos.xz;
        //Fractional Brownian Motion
        xz += vec2(prevWaveHeight_x, prevWaveHeight_z) * 0.1;

        float phaseShift = length(aPos) * 0.1;
        vec2 direction = vec2(sin(iter), cos(iter));

        waveHeight += getWaveHeight(amplitude, frequency, time * timeMultiplier + phaseShift, direction, xz);
        waveHeight_x += getWaveHeight_x(amplitude, frequency, time * timeMultiplier + phaseShift, direction, xz);
        waveHeight_z += getWaveHeight_z(amplitude, frequency, time * timeMultiplier + phaseShift, direction, xz);

        prevWaveHeight_x = waveHeight_x;
        prevWaveHeight_z = waveHeight_z;

        frequency *= 1.18;
        amplitude *= 0.82;
        iter += 1232.399963;
        timeMultiplier *= 1.07;
    }


    vec3 newPosition = vec3(aPos.x, waveHeight, aPos.z);
    gl_Position = projection * view * model * vec4(newPosition, 1.0);
    ecPosition = vec3(view * model * vec4(newPosition, 1.0));

    // Calculate normal vector
    vec3 normal = normalize(vec3(-waveHeight_x, 1.0, -waveHeight_z)); // World Space Normal
    ecNormal = normalize(mat3(transpose(inverse(view * model))) * normal); // Transform to Eye Space
}

