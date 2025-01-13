#version 330 core

in vec3 ecNormal;
in vec3 ecPosition;

// Light info
uniform vec4 LightPosition; // in eye space
uniform vec4 LightAmbient;
uniform vec4 LightDiffuse;
uniform vec4 LightSpecular;
uniform mat4 view;

uniform samplerCube EnvMap;

out vec4 FragColor;

const vec4 k_a = vec4(0.5, 0.5, 0.5, 1.0);
const vec4 k_d = vec4(0.1, 0.3, 0.5, 1.0);
const vec4 k_s = vec4(1.0, 1.0, 1.0, 1.0);
const float n = 50.0;


void main() {

    // Get view vector
    vec3 viewVec = -normalize(ecPosition);

    // Get light vector: from surface to light source
    vec3 lightVec;
    if (LightPosition.w == 0.0 )
        lightVec = normalize(LightPosition.xyz);
    else
        lightVec = normalize(LightPosition.xyz - ecPosition);

    // Normalize normal vector
    vec3 N = normalize(ecNormal);

    // Compute Phong Lighting
    vec3 reflectVec = reflect(-lightVec, N);

    float L_dot_N = max(0.0, dot(-lightVec, N));
    float R_dot_V = max(0.0, dot(reflectVec, viewVec));

    vec4 phongColor = (LightAmbient * k_a) + (LightDiffuse * k_d * L_dot_N) + (LightSpecular * k_s * pow(R_dot_V, n));

    // ENV MAPPING
    // Incident ray for environment mapping is view vector
    vec3 eyeReflectVec = reflect(viewVec, N);
    vec3 wcReflectVec = normalize(vec3(transpose(view) * vec4(eyeReflectVec, 0.0))); // Transform reflect vector to world space
    vec4 envColor = texture(EnvMap, wcReflectVec);

    vec3 L = normalize(lightVec);  // Light direction
    vec3 V = normalize(viewVec);    // View direction
    vec3 H = normalize(L + V);      // Half-vector

    float V_dot_H = max(0.0, dot(V, H));
    float exponential = pow(max(0.0, (1 - V_dot_H)), 1.0);
    float F0 = 0.02;
    float fresnel = F0 + (1.0 - F0) * exponential;
    float specularIntensity = pow(max(0.0, dot(H, N)), 16.0);


    FragColor = mix(envColor+k_s * specularIntensity,  + (LightAmbient * k_a) + (LightDiffuse * k_d * L_dot_N), 0.4);
    FragColor.a = 1.0;

}
