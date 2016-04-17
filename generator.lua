local function newTile(x, y, z)
  return {
    x = x,
    y = y,
    z = z
  }
end

local function generate()
  local tiles = {}
  local x, y = 0, 0
  for i=0,10 do
    local tile = newTile(x, y, 0)
    table.insert(tiles, tile)
    if love.math.random() < 0.5 then
      x = x+1
    else
      y = y+1
    end
  end
  return tiles
end

return generate
