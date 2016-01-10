#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
  float half_width = love_ScreenSize.x / 2;
  vertex_position.x *= smoothstep(0, 1, vertex_position.y / love_ScreenSize.y);
  vertex_position.x -= smoothstep(0, 1, vertex_position.y / love_ScreenSize.y) * half_width;
  vertex_position.x += half_width;
  return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
  vec4 texturecolor = Texel(texture, texture_coords);
  return texturecolor * color;
}
#endif
