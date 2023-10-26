#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

vec3 mov(float t)
{
    t = (t * 2) - 1;
    vec3 output = vec3(0, 0, 0);

    if (t < 0) {
        output.y = 3.9*(1.44 - (-1.2 - t)*(-1.2 - t));
    } else {
        output = vec3(-t, 7.26 * (0.1024 - (0.32-1.3*t)*(0.32-1.3*t)), 0);
    }
    return 100*output;
}


void main() {
    vec3 offset = vec3(0);

    ivec3 color = ivec3(Color.rgb*255);
    if (color == ivec3(42, 45, 62)) {
        vertexColor = vec4(0.98, 0.98, 0.98, 1.0);
        offset -= mov(Color.a);

    } else if (color == ivec3(10, 11, 15)) {
        vertexColor = vec4(0.24, 0.24, 0.24, 1.0);
        offset -= mov(Color.a);

    } else {
        vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    }


    gl_Position = ProjMat * ModelViewMat * vec4(Position + offset, 1.0);

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * (Position + offset), FogShape);
    texCoord0 = UV0;

}