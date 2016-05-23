local Factory = class('Factory', Base):include(Stateful)

local drawResources = require('factories.draw_resources')

local function getMeshIndex(mesh)
  for i,v in ipairs(meshes) do
    if v == mesh then return i end
  end
end

function Factory:initialize(mesh, x, y)
  Base.initialize(self)

  self.mesh = mesh
  self.x = x
  self.y = y
end

function Factory:pointInside(x, y)
  local vertex_count = self.mesh:getVertexCount()
  local i, j, result = 0, vertex_count, false

  for i=1,vertex_count do
    local vx_i, vy_i = self.mesh:getVertex(i)
    local vx_j, vy_j = self.mesh:getVertex(j)
    vx_i, vy_i = vx_i + self.x, vy_i + self.y
    vx_j, vy_j = vx_j + self.x, vy_j + self.y

    if ((vy_i > y) ~= (vy_j > y) and (x < (vx_j - vx_i) * (y - vy_i) / (vy_j-vy_i) + vx_i)) then
      result = not result;
    end

    j = i
  end
  return result;
end

function Factory:draw()
  g.setColor(255, 255, 255)
  g.draw(self.mesh, self.x, self.y)
end

function Factory:addConnection(index, connection)
  assert(index > 0 and index <= self.mesh:getVertexCount())
  assert(connection:isInstanceOf(Factory))
  assert(self ~= connection)
  assert(self.connections[index] == nil)

  self.connections[index] = connection
  connection:connected(self)
end

function Factory:removeConnection(index)
  assert(index > 0 and index <= self.mesh:getVertexCount(), 'Index out of bounds: ' .. index)
  assert(self.connections[index]:isInstanceOf(Factory))

  local other = self.connections[index]
  self.connections[index] = nil
  other:disconnected(self)
end

function Factory:connected(other)
  self.mesh = meshes[getMeshIndex(self.mesh) + 1]
end

function Factory:disconnected(other)
  local newMeshIndex = getMeshIndex(self.mesh) - 1
  self.mesh = meshes[newMeshIndex]
  if newMeshIndex == 0 then
    self:gotoState('Proto')
  end
end

return Factory
