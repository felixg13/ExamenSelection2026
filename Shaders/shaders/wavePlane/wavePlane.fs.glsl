#version 330 core

in vec3 FragPos;
in vec3 Normal;
in vec2 TexCoord;
in float WaveHeight;

out vec4 FragColor;

uniform vec3 viewPos;
uniform float time;

uniform vec3 waveColor1;  
uniform vec3 waveColor2;  
uniform float waveAmplitude;

void main() {
    vec3 normal = normalize(Normal);
    vec3 lightPosition = vec3(0, 50, 0);
    vec3 lightDir = normalize(lightPosition - viewPos);
    
    vec3 lightColor = vec3(1,0,0);
    vec3 diffuse = lightColor * max(dot(normal, lightDir), 0.0) + 0.9;
    
    vec3 objectColor =  mix(waveColor1, waveColor2, TexCoord.x);
    vec3 result = diffuse * objectColor;
    // TODO: Finish the fragment shader implementation

    // vec3 ambient = vec3(0.1, 0.1, 0.1);
    // vec3 diffuse = vec3(0.4, 0.4, 0.4);
    // vec3 specular = vec3(0.5, 0.5, 0.5);
    // vec3 fresnelColor = vec3(0.2, 0.5, 0.8);
    // 
    // vec3 result = ambient + diffuse + specular + fresnelColor * 0.3;
    
    FragColor = vec4(result, 0.9);
}
