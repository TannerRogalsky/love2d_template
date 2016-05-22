local Build = Game:addState('Build')

local drawResources = require('factories.draw_resources')

local function generateVertices(sides, radius)
  assert(type(sides) == 'number' and sides >= 3)

  local half_pi = math.pi / 2
  local t = (2 * math.pi) / sides

  local vertices = {}
  for i=1,sides do
    local x, y = radius * math.cos(i * t - half_pi), radius * math.sin(i * t - half_pi)

    local vertex = {x, y}
    table.insert(vertices, vertex)
  end

  return vertices
end

local SIZE = 40

function Build:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  meshes = {}
  for i=3,12 do
    table.insert(meshes, g.newMesh(generateVertices(i, SIZE)))
  end
  meshes[0] = g.newMesh(generateVertices(50, SIZE))

  factories = {
    Factory:new(1, 0, 0),
    Factory:new(0, SIZE * 2, SIZE)
  }

  factories[1].connections[1] = factories[2]
  factories[1].connections[1] = factories[1]

  g.setBackgroundColor(150, 150, 150)
  g.setFont(self.preloaded_fonts["04b03_16"])
  self.camera:move(-g.getWidth() / 2, -g.getHeight() / 2)
end

function Build:update(dt)
  g.setWireframe(love.keyboard.isDown('space'))
end

function Build:draw()
  self.camera:set()

  local time = love.timer.getTime()
  local cycle_length = 3
  local cycle = time % cycle_length

  for _,factory in ipairs(factories) do
    local mesh_type, x, y = factory.mesh_type, factory.x, factory.y
    local mesh = meshes[mesh_type]

    g.push()
    g.translate(x, y)

    g.setColor(255, 255, 255)
    g.draw(mesh, 0, 0)

    if mesh_type > 0 then
      drawResources(mesh, SIZE * cycle / cycle_length)
    end

    g.pop()
  end

  -- g.setColor(255, 255, 255)
  -- for i,mesh in ipairs(meshes) do
  --   g.draw(mesh, i * SIZE * 3 - g.getWidth() / 2, 0)
  -- end

  self.camera:unset()
end

function Build:mousepressed(x, y, button, isTouch)
end

function Build:mousereleased(x, y, button, isTouch)
end

function Build:keypressed(key, scancode, isrepeat)
end

function Build:keyreleased(key, scancode)
end

function Build:gamepadpressed(joystick, button)
end

function Build:gamepadreleased(joystick, button)
end

function Build:focus(has_focus)
end

function Build:exitedState()
  self.camera = nil
end

return Build
