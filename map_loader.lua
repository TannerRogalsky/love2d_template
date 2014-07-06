local MapLoader = class('MapLoader', Base)
MapLoader.static.maps_folder = "levels/"
MapLoader.static.triggers_folder = "levels/triggers/"

function MapLoader.load(map_name)
  local path = MapLoader.maps_folder .. map_name
  local map_data = game.preloaded_levels[map_name]
  local scale = map_data.properties.scale
  local width, height = map_data.width, map_data.height
  local map_area = {
    width = width,
    height = height,
    scale = scale
  }

  -- grab the tileset info from the data and build it
  local tileset_quads = {}

  local tileset_data = map_data.tilesets[1]
  tileset_data.created_image = g.newImage(MapLoader.fix_relative_path(tileset_data.image))
  tileset_data.created_image:setFilter("nearest", "nearest")
  for y = tileset_data.margin, tileset_data.imageheight - 1, tileset_data.tileheight + tileset_data.spacing do
    for x = tileset_data.margin, tileset_data.imagewidth - 1, tileset_data.tilewidth + tileset_data.spacing do
      local tile_width, tile_height = tileset_data.tilewidth, tileset_data.tileheight
      local image_width, image_height = tileset_data.imagewidth, tileset_data.imageheight

      table.insert(tileset_quads, g.newQuad(x, y, tile_width, tile_height, image_width, image_height))
    end
  end

  -- layers by type and name
  local layers = {}
  for _,layer in ipairs(map_data.layers) do
    if layers[layer.type] == nil then layers[layer.type] = {} end
    layers[layer.type][layer.name] = layer
  end

  -- tile layers
  map_area.tile_layers = {}
  g.setColor(COLORS.white:rgb())
  for name, tiles_metadata in pairs(layers.tilelayer) do
    local sprite_batch = g.newSpriteBatch(tileset_data.created_image, map_data.width * map_data.height, "dynamic")
    local sprite_lookup = DictGrid:new()
    local quad_lookup = DictGrid:new()
    sprite_batch:bind()
    local data_index = 0
    for y=0,tiles_metadata.height - 1 do
      for x=0,tiles_metadata.width - 1 do
        data_index = data_index + 1
        local quad_index = tiles_metadata.data[data_index]
        local quad = tileset_quads[quad_index]

        if quad_index ~= 0 then
          local w, h = map_data.tilewidth, map_data.tileheight
          local sprite_id = sprite_batch:add(quad, x * w, y * h)
          quad_lookup:set(x, y, quad)
          sprite_lookup:set(x, y, sprite_id)
        end
      end
    end
    sprite_batch:unbind()
    map_area.tile_layers[name] = {}
    map_area.tile_layers[name].quad_lookup = quad_lookup
    map_area.tile_layers[name].sprite_lookup = sprite_lookup
    map_area.tile_layers[name].sprite_batch = sprite_batch
  end

  for index, object in ipairs(layers.objectgroup["Physics"].objects) do
    Platform:new(object.x, object.y, object.width, object.height)
  end

  for index, object in ipairs(layers.objectgroup["Lose Fields"].objects) do
    LoseField:new(object.x, object.y, object.width, object.height)
  end

  map_area.tileset_data = tileset_data
  map_area.tileset_quads = tileset_quads
  map_area.triggers = trigger_objects

  return map_area
end

function get_shape(data)
  if data.shape == "rectangle" then
    return love.physics.newRectangleShape(data.width / 2, data.height / 2, data.width, data.height)
  elseif data.shape == "polygon" then
    local points = {}
    for i,point in ipairs(data.polygon) do
      table.insert(points, point.x)
      table.insert(points, point.y)
    end
    return love.physics.newPolygonShape(unpack(points))
  end
end

function MapLoader.parse_grid_coords(sibling_name)
  local x, y = sibling_name:match("n_(..)(..)")
  return tonumber(x), tonumber(y)
end

function MapLoader.fix_relative_path(asset_path)
  local path = asset_path:gsub(".*/images", "images")
  return path
end

return MapLoader
