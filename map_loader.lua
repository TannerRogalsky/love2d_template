local MapLoader = class('MapLoader', Base)
MapLoader.static.maps_folder = "levels/"

function MapLoader.load(map_name)
  local path = MapLoader.maps_folder .. map_name
  local map_data = require(path)
  local scale = map_data.properties.scale
  local map_area = {scale = scale}

  -- grab the tileset info from the data and build it
  local tileset_quads = {}

  local tileset_data = map_data.tilesets[1]
  tileset_data.image = g.newImage(MapLoader.fix_relative_path(tileset_data.image))
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
    local canvas = g.newCanvas(map_data.width * map_data.tilewidth, map_data.height * map_data.tileheight)
    canvas:setFilter("nearest", "nearest")
    g.setCanvas(canvas)
    local data_index = 0
    for y=0,tiles_metadata.height - 1 do
      for x=0,tiles_metadata.width - 1 do
        data_index = data_index + 1
        local quad_index = tiles_metadata.data[data_index]
        local quad = tileset_quads[quad_index]

        if quad_index ~= 0 then
          local w, h = map_data.tilewidth, map_data.tileheight
          g.draw(tileset_data.image, quad, x * w, y * h)
        end
      end
    end
    g.setCanvas()
    map_area.tile_layers[name] = canvas
  end

  for index, object in ipairs(layers.objectgroup["Physics"].objects) do
    local physics_object = {}
    physics_object.body = love.physics.newBody(World, object.x, object.y, "static")
    physics_object.shape = love.physics.newRectangleShape(object.width / 2, object.height / 2, object.width, object.height)
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
