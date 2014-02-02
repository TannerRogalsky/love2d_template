local TileGenerator = class('TileGenerator', Base)

function TileGenerator:initialize(attributes)
  for k,v in pairs(attributes or {}) do
    self[k] = v
  end
end

function TileGenerator:generate(w, h)
  local grid = Grid:new(w, h)

  for x, y, tile in grid:each() do
    local attributes = {
      x = x,
      y = y,
      width = game.tile_width,
      height = game.tile_height,
      bit_value = 0
    }
    grid:set(x, y, Tile:new(attributes))
  end

  -- local tile_fill_ratio = 8 / 20
  -- for x, y, tile in grid:each() do
  --   if math.random() < tile_fill_ratio then
  --     tile.bit_value = 1
  --   end
  -- end
  grid:get(3,3).bit_value = 1
  -- TileGenerator.fill_or_empty_on_ratio(5 / 10, grid, 1, 1, grid.width, grid.height, 3, 3)
  -- TileGenerator.fill_on(function(grid, x, y, dx, dy)
  --   local g = function(...) return grid:get(...) end
  --   local f = function(t) return t and t.bit_value == 1 end
  --   local a, b = g(x, y), g(x + 1, y + 1)
  --   local c, d = g(x + 1, y), g(x, y + 1)
  --   -- x0y0 & x1y1 | x1y0 & x0y1 exist and are set
  --   return f(a) and f(b) or f(c) and f(d)
  -- end, grid, 1, 1, grid.width, grid.height, 2, 2)

  return grid
end

function TileGenerator.get_filled_ratio(grid, x, y, w, h)
  local filled_count = 0
  local traversed_count = 0
  for x, y, tile in grid:each(x, y, w, h) do
    if tile.bit_value == 1 then
      filled_count = filled_count + 1
    end
    traversed_count = traversed_count + 1
  end
  return filled_count / traversed_count
end

function TileGenerator.fill_or_empty_on_ratio(ratio, grid, x, y, w, h, dx, dy)
  for x, y, tile in grid:each(x, y, w, h, dx, dy) do
    local fill_ratio = TileGenerator.get_filled_ratio(grid, x, y, dx, dy)
    local b_value = 0
    if fill_ratio > ratio then
      b_value = 1
    end
    for x, y, tile in grid:each(x, y, dx, dy) do
      tile.bit_value = b_value
    end
  end
end

function TileGenerator.fill_on(fill_condition, grid, x, y, w, h, dx, dy)
  for x, y, tile in grid:each(x, y, w, h) do
    if fill_condition(grid, x, y, dx, dy) then
      for x, y, tile in grid:each(x, y, dx, dy) do
        tile.bit_value = 1
      end
    end
  end
end

return TileGenerator
