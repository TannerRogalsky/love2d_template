const float pi = 3.14159265;
const float pi2 = 2.0 * pi;

extern vec2 time = vec2(0.0, 0.0);
extern float resolution = 1;

extern float width = 1;
extern float height = 1;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
  return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 tc, vec2 pixel_coords) {
   vec2 p = 2.0 * (tc - 0.5);

   float r = sqrt(p.x * p.x * width + p.y * p.y * height);

   if (r > 1.0) discard;

   float d = r != 0.0 ? asin(r) / r : 0.0;

   vec2 p2 = d * p * resolution;

   vec2 uv = mod(p2 / pi2 + 0.5 + time, 1.0);

   return color * Texel(texture, uv);
}
#endif
