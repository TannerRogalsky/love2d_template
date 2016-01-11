-- local image = self.preloaded_images['brick.jpg']
-- batch = g.newSpriteBatch(image, 4)
-- batch:add(0, 0, 0, 100 / image:getHeight())
-- batch:add(100, 100, 0, 100 / image:getHeight())
-- batch:add(0, 200, 0, 100 / image:getHeight())
-- batch:add(300, 0, 0, 100 / image:getHeight())
-- local mesh, attributes = newMeshedBatch({
--   {"VertexColor", "byte", 4},
--   {"CoolVertexAttribute", "float", 2}
-- }, batch)

-- local shader = g.newShader('shaders/mesh_shader.glsl')
-- g.setShader(shader)

-- local function update_attrs()
--   for i = 1, mesh:getVertexCount() do
--     mesh:setVertexAttribute(i, attributes['VertexColor'], math.random(255), math.random(255), math.random(255))
--     mesh:setVertexAttribute(i, attributes['CoolVertexAttribute'], math.random(100), math.random(100))
--   end
-- end
-- timer = cron.every(0.1, update_attrs)

local function dup(num, verts)
  local new = {}
  for i=1,num do
    for _,vert in ipairs(verts) do
      table.insert(new, vert)
    end
  end
  return new
end

local function contains(vertex_format, attributeName)
  local does_contain = false
  for i,attributeFormat in ipairs(vertex_format) do
    if attributeFormat[1] == attributeName then
      return true
    end
  end
  return does_contain
end

local function merge(table_a, table_b, ...)
  for i,v in ipairs(table_b) do
    if not contains(table_a, v[1]) then
      table.insert(table_a, v)
    end
  end

  if ... then
    return merge(table_a, ...)
  else
    return table_a
  end
end

local DEFAULT_VERTEX_FORMAT = {
  {"VertexPosition", "float", 2}, -- The x,y position of each vertex.
  {"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
  {"VertexColor", "byte", 4},     -- The r,g,b,a color of each vertex.
}

local function newMeshedBatch(vertex_format, sprite_batch)
  local w, h = 1, 1
  local vertices = {
    { 0, 0, 0, 0 },
    { w, 0, 1, 0 },
    { w, h, 1, 1 },
    { 0, h, 0, 1 },
  }

  local vf = merge({}, vertex_format, DEFAULT_VERTEX_FORMAT)
  local mesh = love.graphics.newMesh(vf, dup(sprite_batch:getBufferSize(), vertices))

  local attributes = {}
  for i, attr in ipairs(vertex_format) do
    local name = attr[1]
    attributes[name] = i
    sprite_batch:attachAttribute(name, mesh)
  end

  return mesh, attributes
end

return newMeshedBatch
