local Grid = require('grid')

local function merge(t, o, ...)
  if o then
    for k,v in pairs(o) do
      t[k] = t[k] or v
    end
    return merge(t, ...)
  else
    return t
  end
end

local function populateTiles(batch, tileset, layer, tw, th)
  local index = 1
  for y=0,layer.height - 1 do
    for x=0,layer.width - 1 do
      local id = layer.data[index]
      local tile = tileset[id]
      if tile then
        batch:add(tile.quad, x * tw, y * th)
      end

      index = index + 1
    end
  end
end

local function interactiveLayerData(layer, tileset, tw, th)
  local interactives = {}
  local index = 1
  for y=0,layer.height - 1 do
    for x=0,layer.width - 1 do
      local id = layer.data[index]
      if id > 0 then
        table.insert(interactives, merge({
          x = x * tw,
          y = y * th,
          id = id
        }, tileset[id].properties))
      end

      index = index + 1
    end
  end

  return interactives
end

local function buildPaths(layer)
  local paths = {}
  local index = 1
  for y=0,layer.height - 1 do
    for x=0,layer.width - 1 do
      local id = layer.data[index]
      if id > 0 then
        local row = paths[x]
        if row == nil then
          row = {}
          paths[x] = row
        end
        row[y] = true
      end

      index = index + 1
    end
  end
  return paths
end

local function buildMap(map_data)
  local tileset = {}
  local tileset_data = map_data.tilesets[1]
  local newQuad = love.graphics.newQuad

  local properties_by_id = {}
  for i,tile in ipairs(tileset_data.tiles) do
    properties_by_id[tile.id] = tile.properties
  end

  local tilewidth = tileset_data.tilewidth
  local tileheight = tileset_data.tileheight
  local spacing = tileset_data.spacing
  local imagewidth = tileset_data.imagewidth
  local imageheight = tileset_data.imageheight

  local index = 0
  for y=1,imageheight,tileheight + spacing do
    for x=1,imagewidth,tilewidth + spacing do
      table.insert(tileset, {
        properties = properties_by_id[index],
        quad = newQuad(x, y, tilewidth, tileheight, imagewidth, imageheight)
      })
      index = index + 1
    end
  end

  local layers_by_name = {}
  for i,layer in ipairs(map_data.layers) do
    layers_by_name[layer.name] = layer
  end

  local image = game.preloaded_images['tiles.png']
  local num_sprites = map_data.width * map_data.height -- 2 layers
  local layers = {}
  do
    local tiles = love.graphics.newSpriteBatch(image, num_sprites * 2, 'static')
    populateTiles(tiles, tileset, layers_by_name.Background, tilewidth, tileheight)
    populateTiles(tiles, tileset, layers_by_name.Paths, tilewidth, tileheight)
    table.insert(layers, tiles)
  end
  do
    local tiles = love.graphics.newSpriteBatch(image, num_sprites, 'static')
    populateTiles(tiles, tileset, layers_by_name.Interactive, tilewidth, tileheight)
    table.insert(layers, tiles)
  end
  do
    local tiles = love.graphics.newSpriteBatch(image, num_sprites, 'static')
    populateTiles(tiles, tileset, layers_by_name.Foreground, tilewidth, tileheight)
    table.insert(layers, tiles)
  end

  local paths = buildPaths(layers_by_name.Paths)
  local interactives = interactiveLayerData(layers_by_name.Interactive, tileset, tilewidth, tileheight)

  local grid = Grid:new(map_data.width, map_data.height, tilewidth, tileheight)

  return {
    width = tilewidth * map_data.width,
    height = tileheight * map_data.height,
    tileset = tileset,
    layers = layers,
    interactives = interactives,
    grid = grid,
    paths = paths
  }
end

return buildMap
