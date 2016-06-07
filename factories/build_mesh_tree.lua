local pointInside = require('factories.point_inside')

local tau = math.pi * 2
local half_pi = math.pi / 2

local function doShapesIntersect(size, shape_data_a, shape_data_b)
  local x1, y1 = shape_data_a.x, shape_data_a.y
  local x2, y2 = shape_data_b.x, shape_data_b.y
  local v1, v2 = shape_data_a.mesh:getVertexCount(), shape_data_b.mesh:getVertexCount()
  local r1, r2 = size * shape_data_a.scale * math.cos(math.pi / v1), size * shape_data_b.scale * math.cos(math.pi / v2)

  local dx, dy = x1 - x2, y1 - y2
  local d = math.sqrt(dx * dx + dy * dy)
  local inscriptions_overlap = d < (r1 + r2 - 0.1)

  return inscriptions_overlap

  -- if circumscriptions_overlap == false then
  --   print('early out')
  --   return false
  -- end

  -- local mesh1, mesh2 = shape_data_a.mesh, shape_data_b.mesh
  -- for i=1,mesh1:getVertexCount() do
  --   local x, y = mesh1:getVertex(i)
  --   x, y = x * shape_data_a.scale + x1, y * shape_data_a.scale + y1

  --   if pointInside(x, y, mesh2, x2, y2, shape_data_b.scale) then return true end
  -- end

  -- return false
end

local function intersectsAny(size, shape, all_shapes)
  for i,other in ipairs(all_shapes) do
    if doShapesIntersect(size, shape, other) then
      return true
    end
  end
  return false
end

local function newMeshData(mesh, x, y, rotation, scale)
  return {
    mesh = mesh,
    x = x,
    y = y,
    rotation = rotation,
    scale = scale
  }
end

local function build(size, meshes)
  local tree = {}
  local all_shapes = {}

  do
    local index = 1
    local mesh = meshes[index]

    local mesh_data = newMeshData(mesh, 0, 0, 0, 1)
    table.insert(tree, {mesh_data})
    table.insert(all_shapes, mesh_data)
  end

  for layer_index=2,#meshes do
    local previous_layer = tree[layer_index - 1]
    local current_layer = {}

    local previous_shape = previous_layer[1]
    local previous_mesh = previous_shape.mesh
    local previous_vertex_count = previous_mesh:getVertexCount()
    local previous_side_length = math.sin(math.pi / previous_vertex_count) * 2 * size

    local current_mesh = meshes[layer_index]
    local current_vertex_count = current_mesh:getVertexCount()
    local current_side_length = math.sin(math.pi / current_vertex_count) * 2 * size

    local t = tau / previous_vertex_count
    local inner_outer_ratio = previous_side_length / current_side_length * previous_shape.scale

    local previous_distance = size * math.cos(math.pi / previous_vertex_count) * previous_shape.scale
    local current_distance = size * math.cos(math.pi / current_vertex_count) * inner_outer_ratio
    local d = previous_distance + current_distance

    for i=0,previous_vertex_count-1 do
      for _,previous_shape in ipairs(previous_layer) do
        local phi = i * t + half_pi + previous_shape.rotation
        local dx, dy = math.cos(phi), math.sin(phi)
        local x = previous_shape.x + d * dx
        local y = previous_shape.y + d * dy

        local mesh_data = newMeshData(current_mesh, x, y, phi + half_pi, inner_outer_ratio)
        if intersectsAny(size, mesh_data, all_shapes) == false then
          table.insert(current_layer, mesh_data)
          table.insert(all_shapes, mesh_data)
        end
      end
    end

    if #current_layer > 0 then
      table.insert(tree, current_layer)
    else
      return tree
    end
  end

  return tree
end

return build
