extern vec2 time = vec2(0.0, 0.0);
extern float image_aspect_ratio;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
  return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 tc, vec2 pixel_coords) {
  float xb = 2.0 * (tc.x * image_aspect_ratio - 0.5);
  float yb = 2.0 * (tc.y - 0.5);
  float r = sqrt(xb * xb + yb * yb); //value between 0 and sqrt(2)
  if (r < 1.0) {
    float f = (1.0-sqrt(1.0-r))/(r);
    vec2 uv;
    uv.x = (xb * f) / image_aspect_ratio + time.x;
    uv.y = yb * f + time.y;
    return texture2D(texture,uv) * color;
  }
  else {
    discard;
  }
}
#endif
