#version 330 core
out vec4 FragColor;

in vec3 Normal;
in vec3 FragPos;

uniform vec3 lightPos;
uniform vec3 viewPos;
uniform vec3 lightColor;

// void main()
// {
//     
//     vec3 N = normalize(Normal);
//     vec3 L = normalize(lightPos - FragPos);
// 
//     float lambertian = max(dot(N, L), 0.0);
// 
//     float specular = 0.0;
//     if(lambertian > 0.0) {
//       vec3 R = reflect(-L, N);
//       vec3 V = normalize(-FragPos);
//       float specAngle = max(dot(R, V), 0.0);
//       specular = pow(specAngle, 80);
//     }
//     // TODO: Implement Phong shading model here
// 
//     vec3 colorA = lightColor; 
// 
//     vec3 ambient = vec3(0.1) * colorA;
//     vec3 diffuse = vec3(0.2);
// 
//     vec3 result = ambient + diffuse + specular;
//     result = clamp(result, 0.0, 1.0); 
// 
//     FragColor = vec4(FragPos, 1.0);
// }
void main() {
    FragColor = vec4(normalize(Normal), 1.0);
}