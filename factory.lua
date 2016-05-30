local Factory = class('Factory', Base):include(Stateful)

local drawResources = require('factories.draw_resources')
local pointInside = require('factories.point_inside')

local function getMeshIndex(mesh)
  for i,v in ipairs(meshes) do
    if v == mesh then return i end
  end
end

local function contains(list, value)
  for _,v in pairs(list) do
    if v == value then return true end
  end
  return false
end

function Factory:initialize(mesh, x, y)
  Base.initialize(self)

  self.mesh = mesh
  self.x = x
  self.y = y
end

function Factory:pointInside(x, y)
  return pointInside(x, y, self.mesh, self.x, self.y)
end

local function getClosestSideToAngle(requested_rotation, mesh)
  local vertex_count = mesh:getVertexCount()
  local j = vertex_count

  for i=1,vertex_count do
    local ix, iy = mesh:getVertex(i)
    local jx, jy = mesh:getVertex(j)

    local mx, my = (ix + jx) / 2, (jx + jy) / 2

    local angle = math.atan2(mx, my) - math.pi / 2
    -- if angle < 0 then angle = angle + math.pi * 2 end

    j = i
  end
end

function Factory:draw()
  g.setColor(255, 255, 255)
  g.draw(self.mesh, self.x, self.y)
end

function Factory:drawResources(size, cycle)
  drawResources(self.mesh, self.x, self.y, self.connections, size, cycle)
end

function Factory:addConnection(index, connection)
  assert(index > 0 and index <= self.mesh:getVertexCount())
  assert(connection:isInstanceOf(Factory))
  assert(self ~= connection)
  assert(self.connections[index] == nil)

  if connection.connections then
    assert(contains(connection.connections, self) == false, "No switchback connections!")
  end

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
