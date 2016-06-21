#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
  return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  vec4 texturecolor = Texel(texture, texture_coords);
  return texturecolor * color;
}
#endif
