extern vec2 texture_size;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
  return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 paint_color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  float ratio = texture_size.x / texture_size.y;
  vec2 uv = vec2(ratio, 1.) * (2. * screen_coords.xy / texture_size.xy - 1.);

  vec3 n = vec3(uv, sqrt(1. - clamp(dot(uv, uv), 0., 1.)));

  vec3 color = 0.5 + 0.5 * n;
  color = mix(vec3(0.5), color, smoothstep(1.01, 1., dot(uv, uv)));
  return vec4(color, 1.0);
}
#endif
