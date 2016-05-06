#define M_PI 3.1415926535897932384626433832795

extern number time;

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
  float x = 2.0 * (texture_coords.x - 0.5);
  float y = 2.0 * (texture_coords.y - 0.5);
  float r = sqrt(x * x + y * y);

  float d = r >= 0 ? asin(r) / r : 0.0;
  float x2 = d * x;
  float y2 = d * y;

  float x3 = mod(x2 / (4.0 * M_PI) + 0.5 + time, 1.0);
  float y3 = mod(y2 / (2.0 * M_PI) + 0.5, 1.0);

  if (r <= 1.0)
    return texture2D(texture, vec2(x3, y3));
  else
    discard; /* Choose something to do here */
}
#endif
