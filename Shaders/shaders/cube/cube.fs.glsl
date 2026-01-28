#version 330 core

in vec3 FragPos;
in vec3 Normal;
in vec2 TexCoords;

out vec4 FragColor;

uniform float time;
uniform sampler2D texture1;

uniform vec3 viewPos;

float fresnel(float amount, vec3 normal, vec3 view){
	return pow(
		1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0),
		amount
	);
}

void main()
{
    // TODO: Finish the fragment shader implementation
    vec3 norm = normalize(Normal);

	float fresnel_effect = fresnel(3.0, norm, viewPos);

    float pulse = sin(time * 25) * 0.5 + 0.5;
    vec3 cyan = vec3(0,1,1);
    vec3 magenta  = vec3(1, 0, 1) * FragPos;
    vec3 finalColor = mix(cyan,magenta,pulse) * fresnel_effect;

    FragColor = vec4(finalColor, 1.0);
}
