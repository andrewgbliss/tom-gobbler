shader_type canvas_item;

uniform float effect_speed : hint_range(0.0, 1.0) = 0.1;
uniform vec2 screen_size;
uniform vec2 center_position;

void fragment() {
    vec2 center = screen_size / 2.0;
    vec2 adjusted_center = center + center_position;
    vec2 frag_coord = vec2(FRAGCOORD.x, screen_size.y - FRAGCOORD.y);  // Adjust for Y-coordinate inversion
    float distance = length(frag_coord - adjusted_center) / length(center);
    float transparency = smoothstep(effect_speed, 0.0, distance);
    COLOR = vec4(0.0, 0.0, 0.0, 1.0 - transparency);
}