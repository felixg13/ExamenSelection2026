#version 330 core

layout(location = 0) in vec3 aPos;
layout(location = 1) in vec3 aNormal;
layout(location = 2) in vec2 aTexCoord;

out vec3 FragPos;
out vec3 Normal;
out vec2 TexCoord;
out float WaveHeight;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform float time;

uniform float waveAmplitude;
uniform float waveFrequency;
uniform float waveSpeed;

float getHeight(vec2 position) {
    float dist = length(position);
    float wave = sin(position.x * waveFrequency - time * waveSpeed);
    return wave * waveAmplitude;
}

vec3 surfaceNormal(vec2 pos) {
    float e = 0.001;
    float hL = getHeight(pos - vec2(e, 0.0));
    float hR = getHeight(pos + vec2(e, 0.0));
    float hD = getHeight(pos - vec2(0.0, e));
    float hU = getHeight(pos + vec2(0.0, e));

    float dhdx = (hR - hL) / (2.0 * e);
    float dhdz = (hU - hD) / (2.0 * e);

    return normalize(vec3(-dhdx, 1.0, -dhdz));
}

void main() {
    // TODO: Finish the vertex shader implementation
    // You need to create a realistic wave effect on the plane

    // Pourquoi trois waves?
    // float wave1 = 0.3;
    // float wave2 = 0.3;
    // float wave3 = 0.3;
    // 
    // float totalWave = wave1 + wave2 + wave3;
    
    float totalWave = waveAmplitude * sin((waveFrequency * aPos.x) + (waveSpeed * time));
    vec3 displacedPos = aPos;
    displacedPos.y += getHeight(aPos.xz);
    
    float dx = 1;

    float dz = 1;
    
    // vec3 calculatedNormal = normalize(vec3(-dx, 1.0, -dz));
    vec3 calculatedNormal = surfaceNormal(aPos.xz);
    
    FragPos = vec3(model * vec4(displacedPos, 1.0));
    Normal = mat3(transpose(inverse(model))) * calculatedNormal;
    TexCoord = aTexCoord;
    WaveHeight = totalWave;
    
    gl_Position = projection * view * model * vec4(displacedPos, 1.0);
}
