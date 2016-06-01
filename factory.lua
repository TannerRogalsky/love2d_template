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

local function circAve(a0, a1)
  local r1, r2 = (a0 + a1) / 2, ((a0 + a1 + 1) / 2) % 1
  if math.min(math.abs(a1-r1), math.abs(a0-r1)) < math.min(math.abs(a0-r2), math.abs(a1-r2)) then
    return r1
  else
    return r2
  end
end

local DEFAULT_COLOR = {255, 255, 255}

function Factory:initialize(mesh, x, y)
  Base.initialize(self)

  self.mesh = mesh
  self.x = x
  self.y = y

  self.providing_color = nil
  self.color = nil
end

function Factory:pointInside(x, y)
  return pointInside(x, y, self.mesh, self.x, self.y)
end

function Factory:draw()
  self.color = nil

  if self.providing_color or self.reverse_connections then
    local colors = {}
    if self.reverse_connections then
      for k,v in pairs(self.reverse_connections) do
        if v.color then table.insert(colors, v.color) end
      end
    end
    if self.providing_color then table.insert(colors, self.providing_color) end

    if #colors == 1 then
      self.color = colors[1]
      g.setColor(hsl2rgb(colors[1], 1, 0.6))
    elseif #colors >= 2 then
      local color = colors[1]
      for i=2,#colors do
        color = circAve(color, colors[i])
      end

      self.color = color
      g.setColor(hsl2rgb(color, 1, 0.6))
    else
      g.setColor(DEFAULT_COLOR)
    end
  else
    g.setColor(DEFAULT_COLOR)
  end
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
  self.reverse_connections[other.id] = other

  local colors = {}
  if self.reverse_connections then
    for k,v in pairs(self.reverse_connections) do
      if v.color then table.insert(colors, v.color) end
    end
  end
  if self.providing_color then table.insert(colors, self.providing_color) end
  print(unpack(colors))
end

function Factory:disconnected(other)
  self.reverse_connections[other.id] = nil
  local newMeshIndex = getMeshIndex(self.mesh) - 1
  self.mesh = meshes[newMeshIndex]
  if newMeshIndex == 0 then
    for _,connection in pairs(self.connections) do
      connection:disconnected(self)
    end
    self:gotoState('Proto')
  end
end

return Factory
