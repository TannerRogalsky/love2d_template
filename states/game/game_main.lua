local Main = Game:addState('Main')

local palette = {
  { 56,184, 24},
  {120, 24,101},
  {120, 80, 24},
  { 80, 72,248},
  {248, 56, 32},
  {248,152, 80},
  {  0,  0,  0},
  {255,255,255},
}

local ffi = require('ffi')

function Main:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  local quads = {{}, {}}
  self.preloaded_images['pokemon.png']:setFilter('nearest', 'nearest')
  for i=0,250 do
    local x = (i % 15) * 2 * 16
    local y = math.floor(i / 15) * 16
    table.insert(quads[1], g.newQuad(x, y, 16, 16, self.preloaded_images['pokemon.png']:getDimensions()))
    table.insert(quads[2], g.newQuad(x + 16, y, 16, 16, self.preloaded_images['pokemon.png']:getDimensions()))
  end

  sheet = g.newSpriteBatch(self.preloaded_images['pokemon.png'], 251)

  local frameIndex = 1
  local function setupFrames()
    sheet:clear()
    local w = 21
    for i,quad in ipairs(quads[frameIndex]) do
      sheet:add(quad, ((i - 1) % w) * 16, math.floor((i - 1) / w) * 16)
    end
    frameIndex = frameIndex % 2 + 1
  end
  setupFrames()

  updateFrames = cron.every(0.5, setupFrames)

  g.setFont(self.preloaded_fonts["04b03_16"])
  g.setBackgroundColor(218, 229, 214)


  C = ffi.load('stb_herringbone_wang')
  ffi.cdef[[
    void srand (unsigned int seed);

    typedef struct
    {
       // the edge or vertex constraints, according to diagram below
       signed char a,b,c,d,e,f;

       // The herringbone wang tile data; it is a bitmap which is either
       // w=2*short_sidelen,h=short_sidelen, or w=short_sidelen,h=2*short_sidelen.
       // it is always RGB, stored row-major, with no padding between rows.
       // (allocate stbhw_tile structure to be large enough for the pixel data)
       unsigned char pixels[1];
    } stbhw_tile;

    typedef struct
    {
       int is_corner;
       int num_color[6];  // number of colors for each of 6 edge types or 4 corner types
       int short_side_len;
       stbhw_tile **h_tiles;
       stbhw_tile **v_tiles;
       int num_h_tiles, max_h_tiles;
       int num_v_tiles, max_v_tiles;
    } stbhw_tileset;

    // returns description of last error produced by any function (not thread-safe)
    char *stbhw_get_last_error(void);

    // build a tileset from an image that conforms to a template created by this
    // library. (you allocate storage for stbhw_tileset and function fills it out;
    // memory for individual tiles are malloc()ed).
    // returns non-zero on success, 0 on error
    int stbhw_build_tileset_from_image(stbhw_tileset *ts,
                         unsigned char *pixels, int stride_in_bytes, int w, int h);

    // free a tileset built by stbhw_build_tileset_from_image
    void stbhw_free_tileset(stbhw_tileset *ts);

    // generate a map that is w * h pixels (3-bytes each)
    // returns non-zero on success, 0 on error
    // not thread-safe (uses a global data structure to avoid memory management)
    // weighting should be NULL, as non-NULL weighting is currently untested
    int stbhw_generate_image(stbhw_tileset *ts, int **weighting,
                         unsigned char *pixels, int stride_in_bytes, int w, int h);
  ]]
  local stbhw_tileset = ffi.metatype('stbhw_tileset', {__index = {}})


  local image = self.preloaded_images['template_rooms_and_corridors.png']
  w, h = image:getDimensions()
  buf = ffi.new("unsigned char[?]", w * h * 3)
  imageData = image:getData()
  imageData:mapPixel(function(x, y, r, g, b)
    local i = (w * y + x) * 3
    -- print(i, x, y, r, g, b)
    -- print(ffi.new("unsigned char", 255), ffi.new("unsigned char", r), ffi.new("unsigned char", g), ffi.new("unsigned char", b))
    buf[i] = ffi.new("unsigned char", r)
    buf[i + 1] = ffi.new("unsigned char", g)
    buf[i + 2] = ffi.new("unsigned char", b)

    return r, g, b, a
  end)

  C.srand(love.math.random(math.huge))

  tileset = stbhw_tileset()
  local result = C.stbhw_build_tileset_from_image(tileset, buf, w * 3, w, h)
  print(result)
  if (not result) then
    print(C.stbhw_get_last_error())
  end

  result = C.stbhw_generate_image(tileset, nil, buf, w*3, w, h)

  imageData:mapPixel(function(x, y, r, g, b)
    local i = (w * y + x) * 3
    return buf[i], buf[i + 1], buf[i + 2], 255
  end)
  mapImage = g.newImage(imageData)
end

function Main:update(dt)
  updateFrames:update(dt)
end

function Main:draw()
  self.camera:set()

  g.draw(mapImage, 0, 0, 0, 3, 3)
  -- g.draw(sheet, g.getWidth() / 2 + 5, g.getHeight() / 2 + 10, math.sin(love.timer.getTime() / 2), 3, 3, g.getWidth() / 2 / 3, g.getHeight() / 2 / 3)
  -- for i,v in ipairs(palette) do
  --   local w = 20
  --   g.setColor(v[1], v[2], v[3])
  --   g.rectangle('fill', (i - 1) * w, 0, w, 100)
  --   g.setColor(0, 0, 0)
  --   g.print(i, (i - 1) * w)
  -- end

  self.camera:unset()
end

function Main:mousepressed(x, y, button, isTouch)
  result = C.stbhw_generate_image(tileset, nil, buf, w*3, w, h)

  imageData:mapPixel(function(x, y, r, g, b)
    local i = (w * y + x) * 3
    return buf[i], buf[i + 1], buf[i + 2], 255
  end)
  mapImage = g.newImage(imageData)
  mapImage:setFilter('nearest', 'nearest')
end

function Main:mousereleased(x, y, button, isTouch)
end

function Main:keypressed(key, scancode, isrepeat)
end

function Main:keyreleased(key, scancode)
end

function Main:gamepadpressed(joystick, button)
end

function Main:gamepadreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
  self.camera = nil
end

return Main
