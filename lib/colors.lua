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

-- metatable functions for the encompassing colors collection
function colors_mt.__newindex(t, k, v)
  setmetatable(v, color_map_mt)
  rawset(t, k, v)
end

function colors_mt.__index(t, k)
  return rawget(t, k:upper())
end

colors = setmetatable({}, colors_mt)

colors.aliceblue =            { r = 240, g = 248, b = 255 }
colors.antiquewhite =         { r = 250, g = 235, b = 215 }
colors.aqua =                 { r = 0,   g = 255, b = 255 }
colors.aquamarine =           { r = 127, g = 255, b = 212 }
colors.azure =                { r = 240, g = 255, b = 255 }
colors.beige =                { r = 245, g = 245, b = 220 }
colors.bisque =               { r = 255, g = 228, b = 196 }
colors.black =                { r = 0,   g = 0,   b = 0   }
colors.blanchedalmond =       { r = 255, g = 235, b = 205 }
colors.blue =                 { r = 0,   g = 0,   b = 255 }
colors.blueviolet =           { r = 138, g = 43,  b = 226 }
colors.brown =                { r = 165, g = 42,  b = 42  }
colors.burlywood =            { r = 222, g = 184, b = 135 }
colors.cadetblue =            { r = 95,  g = 158, b = 160 }
colors.chartreuse =           { r = 127, g = 255, b = 0   }
colors.chocolate =            { r = 210, g = 105, b = 30  }
colors.coral =                { r = 255, g = 127, b = 80  }
colors.cornflowerblue =       { r = 100, g = 149, b = 237 }
colors.cornsilk =             { r = 255, g = 248, b = 220 }
colors.crimson =              { r = 220, g = 20,  b = 60  }
colors.cyan =                 { r = 0,   g = 255, b = 255 }
colors.darkblue =             { r = 0,   g = 0,   b = 139 }
colors.darkcyan =             { r = 0,   g = 139, b = 139 }
colors.darkgoldenrod =        { r = 184, g = 134, b = 11  }
colors.darkgray =             { r = 169, g = 169, b = 169 }
colors.darkgreen =            { r = 0,   g = 100, b = 0   }
colors.darkgrey =             { r = 169, g = 169, b = 169 }
colors.darkkhaki =            { r = 189, g = 183, b = 107 }
colors.darkmagenta =          { r = 139, g = 0,   b = 139 }
colors.darkolivegreen =       { r = 85,  g = 107, b = 47  }
colors.darkorange =           { r = 255, g = 140, b = 0   }
colors.darkorchid =           { r = 153, g = 50,  b = 204 }
colors.darkred =              { r = 139, g = 0,   b = 0   }
colors.darksalmon =           { r = 233, g = 150, b = 122 }
colors.darkseagreen =         { r = 143, g = 188, b = 143 }
colors.darkslateblue =        { r = 72,  g = 61,  b = 139 }
colors.darkslategray =        { r = 47,  g = 79,  b = 79  }
colors.darkslategrey =        { r = 47,  g = 79,  b = 79  }
colors.darkturquoise =        { r = 0,   g = 206, b = 209 }
colors.darkviolet =           { r = 148, g = 0,   b = 211 }
colors.deeppink =             { r = 255, g = 20,  b = 147 }
colors.deepskyblue =          { r = 0,   g = 191, b = 255 }
colors.dimgray =              { r = 105, g = 105, b = 105 }
colors.dimgrey =              { r = 105, g = 105, b = 105 }
colors.dodgerblue =           { r = 30,  g = 144, b = 255 }
colors.firebrick =            { r = 178, g = 34,  b = 34  }
colors.floralwhite =          { r = 255, g = 250, b = 240 }
colors.forestgreen =          { r = 34,  g = 139, b = 34  }
colors.fuchsia =              { r = 255, g = 0,   b = 255 }
colors.gainsboro =            { r = 220, g = 220, b = 220 }
colors.ghostwhite =           { r = 248, g = 248, b = 255 }
colors.gold =                 { r = 255, g = 215, b = 0   }
colors.goldenrod =            { r = 218, g = 165, b = 32  }
colors.gray =                 { r = 128, g = 128, b = 128 }
colors.grey =                 { r = 128, g = 128, b = 128 }
colors.green =                { r = 0,   g = 128, b = 0   }
colors.greenyellow =          { r = 173, g = 255, b = 47  }
colors.honeydew =             { r = 240, g = 255, b = 240 }
colors.hotpink =              { r = 255, g = 105, b = 180 }
colors.indianred =            { r = 205, g = 92,  b = 92  }
colors.indigo =               { r = 75,  g = 0,   b = 130 }
colors.ivory =                { r = 255, g = 255, b = 240 }
colors.khaki =                { r = 240, g = 230, b = 140 }
colors.lavender =             { r = 230, g = 230, b = 250 }
colors.lavenderblush =        { r = 255, g = 240, b = 245 }
colors.lawngreen =            { r = 124, g = 252, b = 0   }
colors.lemonchiffon =         { r = 255, g = 250, b = 205 }
colors.lightblue =            { r = 173, g = 216, b = 230 }
colors.lightcoral =           { r = 240, g = 128, b = 128 }
colors.lightcyan =            { r = 224, g = 255, b = 255 }
colors.lightgoldenrodyellow = { r = 250, g = 250, b = 210 }
colors.lightgray =            { r = 211, g = 211, b = 211 }
colors.lightgreen =           { r = 144, g = 238, b = 144 }
colors.lightgrey =            { r = 211, g = 211, b = 211 }
colors.lightpink =            { r = 255, g = 182, b = 193 }
colors.lightsalmon =          { r = 255, g = 160, b = 122 }
colors.lightseagreen =        { r = 32,  g = 178, b = 170 }
colors.lightskyblue =         { r = 135, g = 206, b = 250 }
colors.lightslategray =       { r = 119, g = 136, b = 153 }
colors.lightslategrey =       { r = 119, g = 136, b = 153 }
colors.lightsteelblue =       { r = 176, g = 196, b = 222 }
colors.lightyellow =          { r = 255, g = 255, b = 224 }
colors.lime =                 { r = 0,   g = 255, b = 0   }
colors.limegreen =            { r = 50,  g = 205, b = 50  }
colors.linen =                { r = 250, g = 240, b = 230 }
colors.magenta =              { r = 255, g = 0,   b = 255 }
colors.maroon =               { r = 128, g = 0,   b = 0   }
colors.mediumaquamarine =     { r = 102, g = 205, b = 170 }
colors.mediumblue =           { r = 0,   g = 0,   b = 205 }
colors.mediumorchid =         { r = 186, g = 85,  b = 211 }
colors.mediumpurple =         { r = 147, g = 112, b = 219 }
colors.mediumseagreen =       { r = 60,  g = 179, b = 113 }
colors.mediumslateblue =      { r = 123, g = 104, b = 238 }
colors.mediumspringgreen =    { r = 0,   g = 250, b = 154 }
colors.mediumturquoise =      { r = 72,  g = 209, b = 204 }
colors.mediumvioletred =      { r = 199, g = 21,  b = 133 }
colors.midnightblue =         { r = 25,  g = 25,  b = 112 }
colors.mintcream =            { r = 245, g = 255, b = 250 }
colors.mistyrose =            { r = 255, g = 228, b = 225 }
colors.moccasin =             { r = 255, g = 228, b = 181 }
colors.navajowhite =          { r = 255, g = 222, b = 173 }
colors.navy =                 { r = 0,   g = 0,   b = 128 }
colors.oldlace =              { r = 253, g = 245, b = 230 }
colors.olive =                { r = 128, g = 128, b = 0   }
colors.olivedrab =            { r = 107, g = 142, b = 35  }
colors.orange =               { r = 255, g = 165, b = 0   }
colors.orangered =            { r = 255, g = 69,  b = 0   }
colors.orchid =               { r = 218, g = 112, b = 214 }
colors.palegoldenrod =        { r = 238, g = 232, b = 170 }
colors.palegreen =            { r = 152, g = 251, b = 152 }
colors.paleturquoise =        { r = 175, g = 238, b = 238 }
colors.palevioletred =        { r = 219, g = 112, b = 147 }
colors.papayawhip =           { r = 255, g = 239, b = 213 }
colors.peachpuff =            { r = 255, g = 218, b = 185 }
colors.peru =                 { r = 205, g = 133, b = 63  }
colors.pink =                 { r = 255, g = 192, b = 203 }
colors.plum =                 { r = 221, g = 160, b = 221 }
colors.powderblue =           { r = 176, g = 224, b = 230 }
colors.purple =               { r = 128, g = 0,   b = 128 }
colors.red =                  { r = 255, g = 0,   b = 0   }
colors.rosybrown =            { r = 188, g = 143, b = 143 }
colors.royalblue =            { r = 65,  g = 105, b = 225 }
colors.saddlebrown =          { r = 139, g = 69,  b = 19  }
colors.salmon =               { r = 250, g = 128, b = 114 }
colors.sandybrown =           { r = 244, g = 164, b = 96  }
colors.seagreen =             { r = 46,  g = 139, b = 87  }
colors.seashell =             { r = 255, g = 245, b = 238 }
colors.sienna =               { r = 160, g = 82,  b = 45  }
colors.silver =               { r = 192, g = 192, b = 192 }
colors.skyblue =              { r = 135, g = 206, b = 235 }
colors.slateblue =            { r = 106, g = 90,  b = 205 }
colors.slategray =            { r = 112, g = 128, b = 144 }
colors.slategrey =            { r = 112, g = 128, b = 144 }
colors.snow =                 { r = 255, g = 250, b = 250 }
colors.springgreen =          { r = 0,   g = 255, b = 127 }
colors.steelblue =            { r = 70,  g = 130, b = 180 }
colors.tan =                  { r = 210, g = 180, b = 140 }
colors.teal =                 { r = 0,   g = 128, b = 128 }
colors.thistle =              { r = 216, g = 191, b = 216 }
colors.tomato =               { r = 255, g = 99,  b = 71  }
colors.turquoise =            { r = 64,  g = 224, b = 208 }
colors.violet =               { r = 238, g = 130, b = 238 }
colors.wheat =                { r = 245, g = 222, b = 179 }
colors.white =                { r = 255, g = 255, b = 255 }
colors.whitesmoke =           { r = 245, g = 245, b = 245 }
colors.yellow =               { r = 255, g = 255, b = 0   }
colors.yellowgreen =          { r = 154, g = 205, b = 50  }

return colors
