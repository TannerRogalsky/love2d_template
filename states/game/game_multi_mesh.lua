local MultiMeshTest = Game:addState('MultiMesh')

local half_pi = math.pi / 2
local function generateVertices(sides, radius)
  assert(type(sides) == 'number' and sides >= 3)

  local t = (2 * math.pi) / sides

  local rotation_offset = half_pi
  if sides % 2 == 0 then
    rotation_offset = half_pi - t  / 2
  end

  -- radius = radius + radius / sides

  local vertices = {}
  for i=0,sides-1 do
    local x, y = radius * math.cos(i * t - rotation_offset), radius * math.sin(i * t - rotation_offset)

    local vertex = {x, y}
    table.insert(vertices, vertex)
  end

  return vertices
end

local function getSideLength(mesh)
  local x1, y1 = mesh:getVertex(1)
  local x2, y2 = mesh:getVertex(2)
  local dx, dy = x1 - x2, y1 - y2

  return math.sqrt(dx * dx + dy * dy)
end

local function printMesh(mesh)
  for i=1,mesh:getVertexCount() do
    local x, y = mesh:getVertex(i)
    print(x, y)
  end
end

local SIZE = 80
local center_mesh_index = 1
local outer_mesh_index = 1

function MultiMeshTest:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  meshes = {}
  for i=3,12 do
    table.insert(meshes, g.newMesh(generateVertices(i, SIZE * (1 / math.cos(math.pi / i)))))
  end

  self.camera:move(-g.getWidth() / 2, -g.getHeight() / 2)
  g.setBackgroundColor(150, 150, 150)
end

function MultiMeshTest:update(dt)
  g.setWireframe(love.keyboard.isDown('space'))
end

function MultiMeshTest:draw()
  self.camera:set()

  do
    local center_mesh = meshes[center_mesh_index]
    local vertex_count = center_mesh:getVertexCount()
    local t = math.pi * 2 / vertex_count

    g.setColor(0, 0, 0)
    g.draw(center_mesh, 0, 0)

    -- g.setColor(255, 0, 0)
    -- g.circle('fill', 0, 0, SIZE)

    local outer_mesh = meshes[outer_mesh_index]
    local outer_vertex_count = outer_mesh:getVertexCount()
    local inner_outer_ratio = getSideLength(center_mesh) / getSideLength(outer_mesh)

    g.setColor(255, 255, 255)
    for i=0,vertex_count-1 do
      local x = SIZE * (1 + inner_outer_ratio) * math.cos(i * t + math.pi / 2)
      local y = SIZE * (1 + inner_outer_ratio) * math.sin(i * t + math.pi / 2)

      g.draw(outer_mesh, x, y, t * i + math.pi, inner_outer_ratio)
    end
  end

  self.camera:unset()
end

function MultiMeshTest:mousepressed(x, y, button, isTouch)
end

function MultiMeshTest:mousereleased(x, y, button, isTouch)
end

function MultiMeshTest:keypressed(key, scancode, isrepeat)
  if key == '=' then center_mesh_index = math.min(#meshes, center_mesh_index + 1) end
  if key == '-' then center_mesh_index = math.max(1, center_mesh_index - 1) end

  if key == 'k' then outer_mesh_index = math.min(#meshes, outer_mesh_index + 1) end
  if key == 'j' then outer_mesh_index = math.max(1, outer_mesh_index - 1) end
end

function MultiMeshTest:keyreleased(key, scancode)
end

function MultiMeshTest:gamepadpressed(joystick, button)
end

function MultiMeshTest:gamepadreleased(joystick, button)
end

function MultiMeshTest:focus(has_focus)
end

function MultiMeshTest:exitedState()
  self.camera = nil
end

return MultiMeshTest
