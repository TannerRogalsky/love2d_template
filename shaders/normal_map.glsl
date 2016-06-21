extern Image normals;

extern vec3 l_pos = vec3(0.0, 0.0, 0.075);
extern vec4 l_color = vec4(1.0, 1.0, 1.0, 1.0);
extern vec3 falloff = vec3(0.4, 3.0, 20.0);

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
  return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  //RGBA of our diffuse color
  vec4 DiffuseColor = texture2D(texture, texture_coords);

  //RGB of our normal map
  vec3 NormalMap = texture2D(normals, texture_coords).rgb;

  //The delta position of light
  vec3 LightDir = vec3(l_pos.xy - (screen_coords.xy / love_ScreenSize.xy), l_pos.z);

  //Correct for aspect ratio
  LightDir.x *= love_ScreenSize.x / love_ScreenSize.y;

  //Determine distance (used for attenuation) BEFORE we normalize our LightDir
  float D = length(LightDir);

  //normalize our vectors
  vec3 N = normalize(NormalMap * 2.0 - 1.0);
  vec3 L = normalize(LightDir);

  //Pre-multiply light color with intensity
  //Then perform "N dot L" to determine our diffuse term
  vec3 Diffuse = (l_color.rgb * l_color.a) * max(dot(N, L), 0.0);

  //pre-multiply ambient color with intensity
  vec3 Ambient = color.rgb * color.a;

  //calculate attenuation
  float Attenuation = 1.0 / ( falloff.x + (falloff.y*D) + (falloff.z*D*D) );

  //the calculation which brings it all together
  vec3 Intensity = Ambient + Diffuse * Attenuation;
  vec3 FinalColor = DiffuseColor.rgb * Intensity;
  return vec4(FinalColor, DiffuseColor.a);
}
#endif
