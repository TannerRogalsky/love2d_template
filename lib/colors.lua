local colors
local color_map_mt, colors_mt = {}, {}

-- set up metatable imposed on each individual color map table (rgba values)
function color_map_mt.__index(t, k)
  local mt = getmetatable(t)
  return mt[k]
end

function color_map_mt.rgb(color)
  return color.r, color.g, color.b
end

function color_map_mt.rgba(color)
  return color.r, color.g, color.b, color.a or 255
end

function color_map_mt.rgb_to_hsl(rgb_color)
  local r,g,b = rgb_color:rgb()
  r = r / 255
  g = g / 255
  b = b / 255

  local max, min = math.max(r, g, b), math.min(r, g, b)
  local average = (max + min) / 2
  local h,s,l = average,average,average

  if min == max then
    h,s = 0,0 -- achromatic
  else
    local d = max - min
    s = l > 0.5 and d / (2 - max - min) or d / (max + min)

    if max == r then
      h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
      h = (b - r) / d + 2
    elseif max == b then
      h = (r - g) / d + 4
    end

    h = h / 6
  end

  return h, s, l
end

function color_map_mt.hsl_to_rgb(h, s, l)
  local r,g,b

  if s == 0 then
    r,g,b = l,l,l -- achromatic
  else
    local function hue_to_rgb(p, q, t)
      if t < 0 then t = t + 1 end
      if t > 1 then t = t - 1 end
      if t < 1/6 then return p + (q - p) * 6 * t end
      if t < 1/2 then return q end
      if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
      return p
    end

    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    r = hue2rgb(p, q, h + 1/3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1/3)
  end

  return r * 255, g * 255, b * 255
end


-- metatable functions for the encompassing colors collection
function colors_mt.__newindex(t, k, v)
  setmetatable(v, color_map_mt)
  rawset(t, k, v)
end

function colors_mt.__index(t, k)
  return rawget(t, k:upper())
end

colors = setmetatable({}, colors_mt)

colors.aliceblue =            { r = 240, g = 248, b = 255, name = "aliceblue"}
colors.antiquewhite =         { r = 250, g = 235, b = 215, name = "antiquewhite"}
colors.aqua =                 { r = 0,   g = 255, b = 255, name = "aqua"}
colors.aquamarine =           { r = 127, g = 255, b = 212, name = "aquamarine"}
colors.azure =                { r = 240, g = 255, b = 255, name = "azure"}
colors.beige =                { r = 245, g = 245, b = 220, name = "beige"}
colors.bisque =               { r = 255, g = 228, b = 196, name = "bisque"}
colors.black =                { r = 0,   g = 0,   b = 0,   name = "black"}
colors.blanchedalmond =       { r = 255, g = 235, b = 205, name = "blanchedalmond"}
colors.blue =                 { r = 0,   g = 0,   b = 255, name = "blue"}
colors.blueviolet =           { r = 138, g = 43,  b = 226, name = "blueviolet"}
colors.brown =                { r = 165, g = 42,  b = 42,  name = "brown"}
colors.burlywood =            { r = 222, g = 184, b = 135, name = "burlywood"}
colors.cadetblue =            { r = 95,  g = 158, b = 160, name = "cadetblue"}
colors.chartreuse =           { r = 127, g = 255, b = 0,   name = "chartreuse"}
colors.chocolate =            { r = 210, g = 105, b = 30,  name = "chocolate"}
colors.coral =                { r = 255, g = 127, b = 80,  name = "coral"}
colors.cornflowerblue =       { r = 100, g = 149, b = 237, name = "cornflowerblue"}
colors.cornsilk =             { r = 255, g = 248, b = 220, name = "cornsilk"}
colors.crimson =              { r = 220, g = 20,  b = 60,  name = "crimson"}
colors.cyan =                 { r = 0,   g = 255, b = 255, name = "cyan"}
colors.darkblue =             { r = 0,   g = 0,   b = 139, name = "darkblue"}
colors.darkcyan =             { r = 0,   g = 139, b = 139, name = "darkcyan"}
colors.darkgoldenrod =        { r = 184, g = 134, b = 11,  name = "darkgoldenrod"}
colors.darkgray =             { r = 169, g = 169, b = 169, name = "darkgray"}
colors.darkgreen =            { r = 0,   g = 100, b = 0,   name = "darkgreen"}
colors.darkgrey =             { r = 169, g = 169, b = 169, name = "darkgrey"}
colors.darkkhaki =            { r = 189, g = 183, b = 107, name = "darkkhaki"}
colors.darkmagenta =          { r = 139, g = 0,   b = 139, name = "darkmagenta"}
colors.darkolivegreen =       { r = 85,  g = 107, b = 47,  name = "darkolivegreen"}
colors.darkorange =           { r = 255, g = 140, b = 0,   name = "darkorange"}
colors.darkorchid =           { r = 153, g = 50,  b = 204, name = "darkorchid"}
colors.darkred =              { r = 139, g = 0,   b = 0,   name = "darkred"}
colors.darksalmon =           { r = 233, g = 150, b = 122, name = "darksalmon"}
colors.darkseagreen =         { r = 143, g = 188, b = 143, name = "darkseagreen"}
colors.darkslateblue =        { r = 72,  g = 61,  b = 139, name = "darkslateblue"}
colors.darkslategray =        { r = 47,  g = 79,  b = 79,  name = "darkslategray"}
colors.darkslategrey =        { r = 47,  g = 79,  b = 79,  name = "darkslategrey"}
colors.darkturquoise =        { r = 0,   g = 206, b = 209, name = "darkturquoise"}
colors.darkviolet =           { r = 148, g = 0,   b = 211, name = "darkviolet"}
colors.deeppink =             { r = 255, g = 20,  b = 147, name = "deeppink"}
colors.deepskyblue =          { r = 0,   g = 191, b = 255, name = "deepskyblue"}
colors.dimgray =              { r = 105, g = 105, b = 105, name = "dimgray"}
colors.dimgrey =              { r = 105, g = 105, b = 105, name = "dimgrey"}
colors.dodgerblue =           { r = 30,  g = 144, b = 255, name = "dodgerblue"}
colors.firebrick =            { r = 178, g = 34,  b = 34,  name = "firebrick"}
colors.floralwhite =          { r = 255, g = 250, b = 240, name = "floralwhite"}
colors.forestgreen =          { r = 34,  g = 139, b = 34,  name = "forestgreen"}
colors.fuchsia =              { r = 255, g = 0,   b = 255, name = "fuchsia"}
colors.gainsboro =            { r = 220, g = 220, b = 220, name = "gainsboro"}
colors.ghostwhite =           { r = 248, g = 248, b = 255, name = "ghostwhite"}
colors.gold =                 { r = 255, g = 215, b = 0,   name = "gold"}
colors.goldenrod =            { r = 218, g = 165, b = 32,  name = "goldenrod"}
colors.gray =                 { r = 128, g = 128, b = 128, name = "gray"}
colors.grey =                 { r = 128, g = 128, b = 128, name = "grey"}
colors.green =                { r = 0,   g = 128, b = 0,   name = "green"}
colors.greenyellow =          { r = 173, g = 255, b = 47,  name = "greenyellow"}
colors.honeydew =             { r = 240, g = 255, b = 240, name = "honeydew"}
colors.hotpink =              { r = 255, g = 105, b = 180, name = "hotpink"}
colors.indianred =            { r = 205, g = 92,  b = 92,  name = "indianred"}
colors.indigo =               { r = 75,  g = 0,   b = 130, name = "indigo"}
colors.ivory =                { r = 255, g = 255, b = 240, name = "ivory"}
colors.khaki =                { r = 240, g = 230, b = 140, name = "khaki"}
colors.lavender =             { r = 230, g = 230, b = 250, name = "lavender"}
colors.lavenderblush =        { r = 255, g = 240, b = 245, name = "lavenderblush"}
colors.lawngreen =            { r = 124, g = 252, b = 0,   name = "lawngreen"}
colors.lemonchiffon =         { r = 255, g = 250, b = 205, name = "lemonchiffon"}
colors.lightblue =            { r = 173, g = 216, b = 230, name = "lightblue"}
colors.lightcoral =           { r = 240, g = 128, b = 128, name = "lightcoral"}
colors.lightcyan =            { r = 224, g = 255, b = 255, name = "lightcyan"}
colors.lightgoldenrodyellow = { r = 250, g = 250, b = 210, name = "lightgoldenrodyellow"}
colors.lightgray =            { r = 211, g = 211, b = 211, name = "lightgray"}
colors.lightgreen =           { r = 144, g = 238, b = 144, name = "lightgreen"}
colors.lightgrey =            { r = 211, g = 211, b = 211, name = "lightgrey"}
colors.lightpink =            { r = 255, g = 182, b = 193, name = "lightpink"}
colors.lightsalmon =          { r = 255, g = 160, b = 122, name = "lightsalmon"}
colors.lightseagreen =        { r = 32,  g = 178, b = 170, name = "lightseagreen"}
colors.lightskyblue =         { r = 135, g = 206, b = 250, name = "lightskyblue"}
colors.lightslategray =       { r = 119, g = 136, b = 153, name = "lightslategray"}
colors.lightslategrey =       { r = 119, g = 136, b = 153, name = "lightslategrey"}
colors.lightsteelblue =       { r = 176, g = 196, b = 222, name = "lightsteelblue"}
colors.lightyellow =          { r = 255, g = 255, b = 224, name = "lightyellow"}
colors.lime =                 { r = 0,   g = 255, b = 0,   name = "lime"}
colors.limegreen =            { r = 50,  g = 205, b = 50,  name = "limegreen"}
colors.linen =                { r = 250, g = 240, b = 230, name = "linen"}
colors.magenta =              { r = 255, g = 0,   b = 255, name = "magenta"}
colors.maroon =               { r = 128, g = 0,   b = 0,   name = "maroon"}
colors.mediumaquamarine =     { r = 102, g = 205, b = 170, name = "mediumaquamarine"}
colors.mediumblue =           { r = 0,   g = 0,   b = 205, name = "mediumblue"}
colors.mediumorchid =         { r = 186, g = 85,  b = 211, name = "mediumorchid"}
colors.mediumpurple =         { r = 147, g = 112, b = 219, name = "mediumpurple"}
colors.mediumseagreen =       { r = 60,  g = 179, b = 113, name = "mediumseagreen"}
colors.mediumslateblue =      { r = 123, g = 104, b = 238, name = "mediumslateblue"}
colors.mediumspringgreen =    { r = 0,   g = 250, b = 154, name = "mediumspringgreen"}
colors.mediumturquoise =      { r = 72,  g = 209, b = 204, name = "mediumturquoise"}
colors.mediumvioletred =      { r = 199, g = 21,  b = 133, name = "mediumvioletred"}
colors.midnightblue =         { r = 25,  g = 25,  b = 112, name = "midnightblue"}
colors.mintcream =            { r = 245, g = 255, b = 250, name = "mintcream"}
colors.mistyrose =            { r = 255, g = 228, b = 225, name = "mistyrose"}
colors.moccasin =             { r = 255, g = 228, b = 181, name = "moccasin"}
colors.navajowhite =          { r = 255, g = 222, b = 173, name = "navajowhite"}
colors.navy =                 { r = 0,   g = 0,   b = 128, name = "navy"}
colors.oldlace =              { r = 253, g = 245, b = 230, name = "oldlace"}
colors.olive =                { r = 128, g = 128, b = 0,   name = "olive"}
colors.olivedrab =            { r = 107, g = 142, b = 35,  name = "olivedrab"}
colors.orange =               { r = 255, g = 165, b = 0,   name = "orange"}
colors.orangered =            { r = 255, g = 69,  b = 0,   name = "orangered"}
colors.orchid =               { r = 218, g = 112, b = 214, name = "orchid"}
colors.palegoldenrod =        { r = 238, g = 232, b = 170, name = "palegoldenrod"}
colors.palegreen =            { r = 152, g = 251, b = 152, name = "palegreen"}
colors.paleturquoise =        { r = 175, g = 238, b = 238, name = "paleturquoise"}
colors.palevioletred =        { r = 219, g = 112, b = 147, name = "palevioletred"}
colors.papayawhip =           { r = 255, g = 239, b = 213, name = "papayawhip"}
colors.peachpuff =            { r = 255, g = 218, b = 185, name = "peachpuff"}
colors.peru =                 { r = 205, g = 133, b = 63,  name = "peru"}
colors.pink =                 { r = 255, g = 192, b = 203, name = "pink"}
colors.plum =                 { r = 221, g = 160, b = 221, name = "plum"}
colors.powderblue =           { r = 176, g = 224, b = 230, name = "powderblue"}
colors.purple =               { r = 128, g = 0,   b = 128, name = "purple"}
colors.red =                  { r = 255, g = 0,   b = 0,   name = "red"}
colors.rosybrown =            { r = 188, g = 143, b = 143, name = "rosybrown"}
colors.royalblue =            { r = 65,  g = 105, b = 225, name = "royalblue"}
colors.saddlebrown =          { r = 139, g = 69,  b = 19,  name = "saddlebrown"}
colors.salmon =               { r = 250, g = 128, b = 114, name = "salmon"}
colors.sandybrown =           { r = 244, g = 164, b = 96,  name = "sandybrown"}
colors.seagreen =             { r = 46,  g = 139, b = 87,  name = "seagreen"}
colors.seashell =             { r = 255, g = 245, b = 238, name = "seashell"}
colors.sienna =               { r = 160, g = 82,  b = 45,  name = "sienna"}
colors.silver =               { r = 192, g = 192, b = 192, name = "silver"}
colors.skyblue =              { r = 135, g = 206, b = 235, name = "skyblue"}
colors.slateblue =            { r = 106, g = 90,  b = 205, name = "slateblue"}
colors.slategray =            { r = 112, g = 128, b = 144, name = "slategray"}
colors.slategrey =            { r = 112, g = 128, b = 144, name = "slategrey"}
colors.snow =                 { r = 255, g = 250, b = 250, name = "snow"}
colors.springgreen =          { r = 0,   g = 255, b = 127, name = "springgreen"}
colors.steelblue =            { r = 70,  g = 130, b = 180, name = "steelblue"}
colors.tan =                  { r = 210, g = 180, b = 140, name = "tan"}
colors.teal =                 { r = 0,   g = 128, b = 128, name = "teal"}
colors.thistle =              { r = 216, g = 191, b = 216, name = "thistle"}
colors.tomato =               { r = 255, g = 99,  b = 71,  name = "tomato"}
colors.turquoise =            { r = 64,  g = 224, b = 208, name = "turquoise"}
colors.violet =               { r = 238, g = 130, b = 238, name = "violet"}
colors.wheat =                { r = 245, g = 222, b = 179, name = "wheat"}
colors.white =                { r = 255, g = 255, b = 255, name = "white"}
colors.whitesmoke =           { r = 245, g = 245, b = 245, name = "whitesmoke"}
colors.yellow =               { r = 255, g = 255, b = 0,   name = "yellow"}
colors.yellowgreen =          { r = 154, g = 205, b = 50,  name = "yellowgreen"}

return colors
