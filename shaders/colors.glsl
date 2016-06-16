extern float time;
extern int layer_index;
varying vec4 vpos;

float PI = 3.1459;

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
  vpos = vertex_position;
  float t = time;
  if (mod(layer_index, 2) == 0) {
    t *= -1;
  }

  float c = cos(t * 2);
  float s = sin(t * 2);
  float x = c * vertex_position.x - s * vertex_position.y;
  vertex_position.y = s * vertex_position.x + c * vertex_position.y;
  vertex_position.x = x;
  return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
  vec4 texturecolor = Texel(texture, texture_coords);
  vec2 pos = vec2(screen_coords.y - love_ScreenSize.y / 2, screen_coords.x - love_ScreenSize.x / 2);
  float phi = atan(pos.x, pos.y) + mod(time, PI * 2);
  vec4 hsv = vec4(hsv2rgb(vec3(phi / (PI * 2), 1, 1)), 1);
  return texturecolor * hsv;
}
#endif
