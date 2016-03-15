local ffi = require('ffi')

local function imageToSTB(imageData, w, h)
  local decoded = ffi.cast("unsigned char*", imageData:getString())
  local preparedData = ffi.new("unsigned char[?]", w * h * 3)

  for i=0, w * h do
    preparedData[i * 3] = decoded[i * 4]
    preparedData[i * 3 + 1] = decoded[i * 4 + 1]
    preparedData[i * 3 + 2] = decoded[i * 4 + 2]
  end

  return preparedData
end

local function loadLib()
  local C = ffi.load('stb_herringbone_wang')
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

  local stbhw_tile = ffi.metatype('stbhw_tile', {__index = {}})
  local stbhw_tileset = ffi.metatype('stbhw_tileset', {__index = {}})

  C.srand(os.time())

  return {
    STBHW = C,
    tileset = stbhw_tileset()
  }
end

local HW = loadLib()
HW.__index = Line

function HW:setTileset(imageData)
  local w, h = imageData:getDimensions()
  local tilesetData = imageToSTB(imageData, w, h)
  if (self.STBHW.stbhw_build_tileset_from_image(self.tileset, tilesetData, w * 3, w, h) == 0) then
    error(self.STBHW.stbhw_get_last_error())
  end
end

function HW:createMapImageData(w, h)
  local imageDataArray = ffi.new("unsigned char[?]", w * h * 3)
  if (self.STBHW.stbhw_generate_image(self.tileset, nil, imageDataArray, w*3, w, h) == 0) then
    print(self.STBHW.stbhw_get_last_error())
  end

  local imageData = love.image.newImageData(w, h)
  imageData:mapPixel(function(x, y)
    local i = (w * y + x) * 3
    return imageDataArray[i], imageDataArray[i + 1], imageDataArray[i + 2], 255
  end)
  return imageData
end

return HW
