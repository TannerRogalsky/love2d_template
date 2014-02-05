local Generator = class('Generator', Base)

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

  -- love.math.setRandomSeed(1391375350)
  print(love.math.getRandomSeed())
end

function Generator:generate(w, h)
  local TileGenerator = require('tile_generator')
  local tile_generator = TileGenerator:new()
  local grid = tile_generator:generate(w, h)

  -- identify contiguous regions
  local regions = {}
  local function visit(current_region, tile)
    if tile.region or tile.bit_value == 1 then return end

    tile.region = current_region
    table.insert(current_region, tile)
    for _, _, adjacent in grid:each(tile.x - 1, tile.y - 1, 3, 3) do
      visit(current_region, adjacent)
    end
  end
  for x, y, tile in grid:each() do
    if tile.region == nil and tile.bit_value == 0 then
      local new_region = {index = #regions}
      table.insert(regions, new_region)
      visit(new_region, tile)
    end
  end
  table.sort(regions, function(a, b) return #a > #b end)

  local section_attributes = {
    grid = grid,
    regions = regions,
    width = w,
    height = h,
  }
  return Section:new(section_attributes)
end

return Generator
