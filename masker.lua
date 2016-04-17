-- http://www.angryfishstudios.com/2011/04/adventures-in-bitmasking/
local e = love.physics.newEdgeShape

local SHAPES = {
  [0]  = {e(0, 0, 0, 1), e(0, 1, 1, 1), e(1, 1, 1, 0), e(1, 0, 0, 0)},
  [1]  = {e(0, 0, 0, 1), e(0, 1, 1, 1), e(1, 1, 1, 0)},
  [2]  = {e(0, 0, 0, 1), e(0, 1, 1, 1), e(0, 0, 1, 0)},
  [3]  = {e(0, 0, 0, 1), e(0, 1, 1, 1)},
  [4]  = {e(0, 1, 0, 0), e(0, 0, 1, 0), e(1, 0, 1, 1)},
  [5]  = {e(0, 0, 0, 1), e(1, 0, 1, 1)},
  [6]  = {e(0, 0, 0, 1), e(0, 0, 1, 0)},
  [7]  = {e(0, 0, 0, 1)},
  [8]  = {e(0, 1, 1, 1), e(1, 1, 1, 0), e(1, 0, 0, 0)},
  [9]  = {e(0, 1, 1, 1), e(1, 0, 1, 1)},
  [10] = {e(0, 0, 1, 0), e(0, 1, 1, 1)},
  [11] = {e(0, 1, 1, 1)},
  [12] = {e(0, 0, 1, 0), e(1, 0, 1, 1)},
  [13] = {e(1, 0, 1, 1)},
  [14] = {e(0, 0, 1, 0)},
  [15] = {},
}

local POSITIONERS = {
  edge = function(shape, x, y, w, h)
    local x1, y1, x2, y2 = shape:getPoints()
    return e(x1 * w + x, y1 * h + y, x2 * w + x, y2 * h + y)
  end
}

local function positionShape(shape, ...)
  return POSITIONERS[shape:getType()](shape, ...)
end

local function buildLookup(tiles)
  local lookup = {}
  for _,tile in ipairs(tiles) do
    local x, y = tile.x, tile.y
    lookup[x] = lookup[x] or {}
    lookup[x][y] = tile
  end

  return lookup
end

local function tileExistsInLookup(lookup, x, y)
  return lookup[x] and lookup[x][y]
end

local function getValue(tile, lookup)
  local v = 0
  if tileExistsInLookup(lookup, tile.x, tile.y - 1) then v = v + 1 end
  if tileExistsInLookup(lookup, tile.x + 1, tile.y) then v = v + 2 end
  if tileExistsInLookup(lookup, tile.x, tile.y + 1) then v = v + 4 end
  if tileExistsInLookup(lookup, tile.x - 1, tile.y) then v = v + 8 end
  return v
end

local function mask(tiles, world, tw, th)
  local lookup = buildLookup(tiles)

  local newFixture = love.physics.newFixture
  local body = love.physics.newBody(world)

  for _,tile in ipairs(tiles) do
    local x, y = tile.x * tw, tile.y * th
    local bitmaskValue = getValue(tile, lookup)
    for _,shape in ipairs(SHAPES[bitmaskValue]) do
      local positionedShape = positionShape(shape, x, y, tw, th)
      local fixture = newFixture(body, positionedShape)
    end
  end

  return body
end

return mask
