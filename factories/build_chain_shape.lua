local abs, cos, sin = math.abs, math.cos, math.sin
local newChainShape = love.physics.newChainShape

local function insertAll(t, v, ...)
  if v then
    table.insert(t, v)
    insertAll(t, ...)
  end
end

local function insertPoint(t, x, y)
  local n = #t
  if n < 2 or abs(t[n - 1] - x) >= 0.5 or abs(t[n] - y) >= 0.5 then
    t[n + 1] = x
    t[n + 2] = y
  -- else
  --   print('DENIED', n < 2, abs(t[n - 1] - x) >= 0.5, abs(t[n] - y) >= 0.5, (abs(t[n - 1] - x) >= 0.5 and abs(t[n] - y) >= 0.5))
  end
end

local function pointDist(x1, y1, x2, y2)
  return math.round(abs(x1 - x2)), math.round(abs(y1 - y2))
end

local function pointEquals(x1, y1, x2, y2)
  return abs(x1 - x2) < 0.5 and abs(y1 - y2) < 0.5
end

local function getVertex(shape, index)
  local vx, vy = shape.mesh:getVertex(index)
  local c, s = cos(shape.rotation), sin(shape.rotation)
  local scale = shape.scale

  local x = shape.x + (c * vx - s * vy) * scale
  local y = shape.y + (s * vx + c * vy) * scale

  return x, y
end

local function sharesPointWith(x1, y1, shapes)
  for shape_index,shape in ipairs(shapes) do
    local mesh = shape.mesh
    local vertex_count = mesh:getVertexCount()

    for vertex_index=1,mesh:getVertexCount() do
      local vx_i, vy_i = getVertex(shape, vertex_index)

      if pointEquals(x1, y1, vx_i, vy_i) then
        return shape_index, vertex_index
      end
    end
  end

  return nil
end

local function sharesEdgeWith(x1, y1, x2, y2, shapes, debug)
  for shape_index,shape in ipairs(shapes) do
    local mesh = shape.mesh
    local vertex_count = mesh:getVertexCount()
    local j = vertex_count

    if debug then print('') end
    for i=1,vertex_count do
      local vx_i, vy_i = getVertex(shape, i)
      local vx_j, vy_j = getVertex(shape, j)

      if debug then print('--------') end
      if debug then print(i, j, x1, y1, x2, y2, vx_i, vy_i, vx_j, vy_j) end
      if debug then print('') end
      if debug then print(pointDist(x1, y1, vx_i, vy_i)) end
      if debug then print(pointDist(x2, y2, vx_j, vy_j)) end
      if debug then print('') end
      if debug then print(pointDist(x1, y1, vx_j, vy_j)) end
      if debug then print(pointDist(x2, y2, vx_i, vy_i)) end
      if pointEquals(x1, y1, vx_j, vy_j) and pointEquals(x2, y2, vx_i, vy_i) or -- this satisfies (almost?) all the time
         pointEquals(x1, y1, vx_i, vy_i) and pointEquals(x2, y2, vx_j, vy_j) then
        return shape_index, i
      end

      j = i
    end
  end

  return nil
end

local function addAllVertices(vertices, mesh_tree, layer_index, shape_index, starting_vertex_index)
  local shape = mesh_tree[layer_index][shape_index]
  local mesh = shape.mesh
  local vertex_count = mesh:getVertexCount()

  for i=1,vertex_count - 1 do
    local index = (i + starting_vertex_index - 1) % vertex_count + 1
    local x, y = getVertex(shape, index)
    print('added all', index, math.round(x), math.round(y))
    insertPoint(vertices, x, y)
  end
end

local function addVerticesUntilShared(vertices, mesh_tree, layer_index, shape_index, starting_vertex_index)
  if layer_index >= #mesh_tree then
    print('adding all')
    addAllVertices(vertices, mesh_tree, layer_index, shape_index, starting_vertex_index)
    return
  end

  local shape = mesh_tree[layer_index][shape_index]
  local mesh = shape.mesh
  local vertex_count = mesh:getVertexCount()
  local j = vertex_count

  for i=1,vertex_count do
    print('vert', (i + starting_vertex_index - 2) % vertex_count + 1, (j + starting_vertex_index - 2) % vertex_count + 1)
    local vx_i, vy_i = getVertex(shape, (i + starting_vertex_index - 2) % vertex_count + 1)
    local vx_j, vy_j = getVertex(shape, (j + starting_vertex_index - 2) % vertex_count + 1)

    print('!!!!!!!!!', i)
    local other_shape_index, shared_vertex_index = sharesEdgeWith(vx_i, vy_i, vx_j, vy_j, mesh_tree[layer_index + 1], false)

    if other_shape_index then
      print('found shared', other_shape_index, shared_vertex_index)
      addVerticesUntilShared(vertices, mesh_tree, layer_index + 1, other_shape_index, shared_vertex_index)
    else
      print('added not shared', math.round(vx_i), math.round(vy_i))
      insertPoint(vertices, vx_i, vy_i)
    end
    j = i
  end
end

local function buildChainShape(mesh_tree)
  local vertices = {}
  addVerticesUntilShared(vertices, mesh_tree, 1, 1, 1)
  -- addAllVertices(vertices, mesh_tree, 1, 1, 1)
  -- print(inspect(vertices))
  -- local rounded_verts = {}
  -- for i,v in ipairs(vertices) do
  --   rounded_verts[i] = math.round(v)
  -- end
  -- print(inspect(rounded_verts))

  local n = #vertices
  if abs(vertices[n - 1] - vertices[1]) < 0.5 and abs(vertices[n] - vertices[2]) and 0.5 then
    table.remove(vertices)
    table.remove(vertices)
  end


  return newChainShape(true, vertices), vertices
  -- return nil, vertices
end

return buildChainShape
