extern Image normals;
extern number fac = 0.5;
extern number mousex = 1.0;
extern number mousey = 1.0;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
  return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {
  vec2 uv2 = vec2(texture_coords.x, 1 - texture_coords.y);
  vec3 NormalMap = Texel(normals, uv2).rgb;
  vec3 N = normalize(NormalMap * 2.0 - 1.0);
  vec2 uv = vec2(
    texture_coords.x - (.5 - NormalMap.r)/(2/fac)*ceil(NormalMap.g), // - NormalMap.b/(16/fac),
    texture_coords.y - (.5 - NormalMap.g)/(2/fac)*ceil(NormalMap.g)  // - NormalMap.b/(16/fac)
  );
  // vec2 uv = texture_coords - N / (2 / fac) * ceil(NormalMap);

  // vec3 col = texture2D(texture,uv).xyz;
  // float p1 = pow(texture_coords.x*4 - mousex*4 - .5, 2);
  // float p2 = pow(texture_coords.y*4 - mousey*4 + .5, 2);
  // float n = (1 - clamp(sqrt(p1 + p2), 0, 1) - .2);
  // col += n * ceil(mapcol.g) * fac;
  // return vec4(col, 1);
  return texture2D(texture,uv) * color;
}
#endif
