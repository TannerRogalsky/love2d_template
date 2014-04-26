local MapLoader = class('MapLoader', Base)
MapLoader.static.maps_folder = "levels/"

function MapLoader.load(map_name)
  local path = MapLoader.maps_folder .. map_name
  local map_data = game.preloaded_levels[map_name]
  local scale = map_data.properties.scale
  local map_area = {scale = scale}
  map_area.player1 = {}
  local px, py = map_data.properties.player1_pos:match("(%d*),(%d*)")
  map_area.player1.x, map_area.player1.y = tonumber(px) * map_data.tilewidth - map_data.tilewidth / 2, tonumber(py) * map_data.tileheight - map_data.tileheight / 2
  map_area.player2 = {}
  px, py = map_data.properties.player2_pos:match("(%d*),(%d*)")
  map_area.player2.x, map_area.player2.y = tonumber(px) * map_data.tilewidth - map_data.tilewidth / 2, tonumber(py) * map_data.tileheight - map_data.tileheight / 2

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
          sprite_lookup:set(x, y, sprite_lookup)
        end
      end
    end
    sprite_batch:unbind()
    map_area.tile_layers[name] = {}
    map_area.tile_layers[name].sprite_lookup = sprite_lookup
    map_area.tile_layers[name].sprite_batch = sprite_batch
  end

  for index, object in ipairs(layers.objectgroup["Physics"].objects) do
    local physics_object = {}
    physics_object.body = love.physics.newBody(World, object.x, object.y, "static")
    if object.shape == "rectangle" then
      physics_object.shape = love.physics.newRectangleShape(object.width / 2, object.height / 2, object.width, object.height)
    elseif object.shape == "polygon" then
      local points = {}
      for i,point in ipairs(object.polygon) do
        table.insert(points, point.x)
        table.insert(points, point.y)
      end
      physics_object.shape = love.physics.newPolygonShape(unpack(points))
    end
    physics_object.fixture = love.physics.newFixture(physics_object.body, physics_object.shape)
    physics_object.fixture:setUserData(physics_object)
    physics_object.terrain = true
  end

  map_area.tileset_data = tileset_data
  map_area.tileset_quads = tileset_quads

  return map_area
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
