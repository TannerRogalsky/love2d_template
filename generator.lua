local Generator = class('Generator', Base)
Generator.static.mask_data = require("data/mask_data3")

TileGenerator = require 'tile_generator'

function Generator:initialize(attributes)
  for k,v in pairs(attributes or {}) do
    self[k] = v
  end

  local function hamming_weight(x)
    local sum = 0
    while x ~= 0 do
      sum = sum + bit.band(x, 1)
      x = bit.rshift(x, 1)
    end
    return sum
  end

  -- love.math.setRandomSeed(1391372537)
  print(love.math.getRandomSeed())
end

function Generator:generate(w, h)
  local tile_generator = TileGenerator:new()
  local grid = tile_generator:generate(w, h)

  -- bitmask the grid
  local function mask_neighbors(x, y, tile)
    local mask_value = 0
    local index = 0
    for dx=-1,1 do
      for dy=-1,1 do
        local ax, ay = x + dx, y + dy
        local adjacent_tile = grid:get(ax, ay)
        if ax == x or ay == y then
          local bit_value = 1
          if adjacent_tile then
            bit_value = adjacent_tile.bit_value
          end
          local tile_mask_value = bit_value * math.pow(2, index)
          mask_value = mask_value + tile_mask_value
          index = index + 1
        end
      end
    end
    return mask_value
  end

  for x, y, tile in grid:each() do
    local masked_value = mask_neighbors(x, y, tile)
    tile:set_mask_data(masked_value)
  end

  return grid
end

return Generator
