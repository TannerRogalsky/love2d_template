#ifdef VERTEX
vec4 position(mat4 transProj, vec4 vPos) {
  return transProj * vPos;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 uv, vec2 screen) {
  return Texel(texture, uv) * color;
}
#endif
