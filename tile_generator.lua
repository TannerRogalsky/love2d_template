local TileGenerator = class('TileGenerator', Base)

function TileGenerator:initialize(attributes)
  for k,v in pairs(attributes or {}) do
    self[k] = v
  end
end

function TileGenerator:generate(w, h)
  local tile_fill_ratio = 8 / 20
  local grid = Grid:new(w, h)

  for x, y, tile in grid:each() do
    local b_value = 0
    if math.random() < tile_fill_ratio then
      b_value = 1
    end
    local attributes = {
      x = x,
      y = y,
      width = game.tile_width,
      height = game.tile_height,
      bit_value = b_value
    }
    grid:set(x, y, Tile:new(attributes))
  end

  TileGenerator.fill_if_over_ratio(5 / 10, grid, 1, 1, grid.width, grid.height, 3, 3)
  -- TileGenerator.fill_if_over_ratio(1 / 2, grid, 1, 1, grid.width, grid.height, 2, 2)

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

function TileGenerator.fill_if_over_ratio(ratio, grid, x, y, w, h, dx, dy)
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

return TileGenerator
