local w, h = game.tile_width, game.tile_height
local square = {
  0, 0,
  w, 0,
  w, h,
  0, h,
}
local ru_tri = {
  0, 0,
  w, 0,
  w, h,
}
local rd_tri = {
  w, 0,
  w, h,
  0, h,
}
local lu_tri = {
  0, 0,
  w, 0,
  0, h,
}
local ld_tri = {
  0, h,
  0, 0,
  w, h,
}
COLORS.tile_grey = {r = 120, g = 120, b = 135}
COLORS.background_grey = {r = 202, g = 202, b = 207}

return {
  [0] = {
    color = COLORS.background_grey,
    geometry = square
  },
  [1] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [2] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [3] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [4] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [5] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [6] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [7] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [8] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [9] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [10] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [11] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [12] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [13] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [14] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [15] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [16] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [17] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [18] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [19] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [20] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [21] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [22] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [23] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [24] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [25] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [26] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [27] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [28] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [29] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [30] = {
    color = COLORS.tile_grey,
    geometry = square
  },
  [31] = {
    color = COLORS.tile_grey,
    geometry = square
  },
}
