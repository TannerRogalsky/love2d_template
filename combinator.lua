local Combinator = class('Combinator', Factory)

local function generateVertices(width, height)
  local sides = 50
  local verts = {}
  local t = (2 * math.pi) / sides

  for i=0,sides - 1 do
    local x = width * math.sin(i * t)
    local y = height * math.sin(i * t) * math.cos(i * t)

    table.insert(verts, {x, y})
  end

  return verts
end

local function copyVertex(index, mesh, ox, oy, r)
  local x, y = mesh:getVertex(index)
  local c, s = math.cos(r), math.sin(r)
  return {ox + (c*x - s*y), oy + (s*x + c*y)}
end

local function copyVertices(mesh, verts, x, y, r)
  local origin = copyVertex(1, mesh, x, y, r)

  for i=2,mesh:getVertexCount() - 1 do
    table.insert(verts, origin)
    table.insert(verts, copyVertex(i, mesh, x, y, r))
    table.insert(verts, copyVertex(i + 1, mesh, x, y, r))
  end

  return verts
end

local SIZE = 40
local mesh = g.newMesh(generateVertices(SIZE, SIZE))

function Combinator:initialize(x, y)
  Factory.initialize(self, mesh, x, y)

  self.resource_mesh_vertices = {}
  self.resource_mesh = nil

  self.connected_meshes = {}
end

function Combinator:drawResources(size, cycle)
  if #self.connected_meshes > 0 then
    local tau = math.pi * 2
    for i=1,2 do
      cycle = cycle * -1
      local x = self.x + size * math.sin(cycle * tau)
      local y = self.y + size * math.sin(cycle * tau) * math.cos(cycle * tau)
      g.draw(self.resource_mesh.mesh, x, y, 0, 0.2)
    end
  end
end

function Combinator:connected(other)
  print(other.mesh:getVertexCount() .. ' vertex shaped connected to combinator.')

  -- local ox, oy, r = 0, 0, 0
  local previous_mesh = self.connected_meshes[#self.connected_meshes]
  if previous_mesh then
    -- ox = 0
    -- oy = SIZE * #self.connected_meshes
    -- r = math.pi / other.mesh:getVertexCount()
    self.resource_mesh:addMesh(other.mesh, math.atan2(other.x - self.x, other.y - self.y))
  else
    self.resource_mesh = MultiMesh:new(other.mesh)
  end
  -- copyVertices(other.mesh, self.resource_mesh_vertices, ox, oy, r)
  -- self.resource_mesh = g.newMesh(self.resource_mesh_vertices, 'triangles')

  table.insert(self.connected_meshes, other.mesh)
end

function Combinator:disconnected(other)
  print(other.mesh:getVertexCount() .. ' vertex shaped disconnected to combinator.')
end

return Combinator
