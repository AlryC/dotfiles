#version 130
uniform sampler2D tex;

vec4 window_shader() {
    // Sample using the default fragment coordinate
    vec4 color = texture(tex, gl_TexCoord[0].xy);
    float gray = 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
    return vec4(vec3(gray), color.a);
}
