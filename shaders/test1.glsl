float PI = 3.1459;
extern float time;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
  float c = cos(time);
  float s = sin(time);
  vertex_position.x *= c;
  vertex_position.y *= s * c;
  float x = c * vertex_position.x - s * vertex_position.y;
  vertex_position.y = s * vertex_position.x + c * vertex_position.y;
  vertex_position.x = x;
  return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  vec4 texturecolor = Texel(texture, texture_coords);
  return texturecolor * color;
}
#endif
