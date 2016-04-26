local function newTile(x, y)
  return {
    x = x,
    y = y
  }
end

local lookupmt = {}
function lookupmt.__index()
  return setmetatable({}, lookupmt)
end

local function generate()
  local tiles, lookup = {}, setmetatable({}, lookupmt)
  local x, y = 0, 0

  for i=0,10 do
    local tile = newTile(x, y)
    lookup[x][y] = tile
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
