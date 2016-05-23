local Build = Game:addState('Build')

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

local function newProtoFactory(...)
  local factory = Factory:new(...)
  factory:gotoState('Proto')
  return factory
end

local function newProducingFactory(...)
  local factory = Factory:new(...)
  factory:gotoState('Producing')
  return factory
end

local function getFactoryAtPoint(factories, x, y)
  for _,factory in ipairs(factories) do
    if factory:pointInside(x, y) then return factory end
  end
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

  self.factories = {
    newProducingFactory(meshes[1], 0, 0),
  }

  for x=-5,5 do
    for y=-3,3 do
      if x ~= 0 or y ~= 0 then
        table.insert(self.factories, newProtoFactory(meshes[0], SIZE * 3 * x, SIZE * 3 * y))
      end
    end
  end

  self.mouse_down = nil

  g.setBackgroundColor(150, 150, 150)
  g.setFont(self.preloaded_fonts["04b03_16"])
  self.camera:move(-g.getWidth() / 2, -g.getHeight() / 2)
end

function Build:update(dt)
  g.setWireframe(love.keyboard.isDown('space'))
end

local drawResources = require('factories.draw_resources')
function Build:draw()
  self.camera:set()
  local time = love.timer.getTime()

  for _,factory in ipairs(self.factories) do
    factory:draw()
  end

  do
    local cycle_length = 3
    local cycle = time % cycle_length

    g.setBlendMode('subtract')
    g.setColor(100, 100, 100)
    for _,factory in ipairs(self.factories) do
      if factory.connections then
        local vertex_count = factory.mesh:getVertexCount()
        local t = (2 * math.pi) / vertex_count
        local vertex_offset = math.pi / vertex_count + math.pi / 2

        for i=1,vertex_count do
          local connection = factory.connections[i]
          local cx = factory.x + SIZE * math.cos(i * t - vertex_offset)
          local cy = factory.y + SIZE * math.sin(i * t - vertex_offset)

          local curve
          if connection then
            curve = love.math.newBezierCurve(factory.x, factory.y, cx, cy, connection.x, connection.y)
            g.line(curve:render())
          else
            curve = love.math.newBezierCurve(factory.x, factory.y, cx, cy)
          end

          local x, y = curve:evaluate(cycle / cycle_length)
          g.draw(factory.mesh, x, y, math.atan2(factory.x - x, factory.y - y), 0.2)
        end

      end
    end
    g.setBlendMode('alpha')
  end

  if self.mouse_down then
    local dx, dy = self.mouse_down.x, self.mouse_down.y
    local mx, my = self.camera:mousePosition()
    g.setColor(0, 0, 0)
    g.line(dx, dy, mx, my)
  end

  self.camera:unset()
end

function Build:mousepressed(x, y, button, isTouch)
  local addConnection = isTouch or button == 1
  local mx, my = self.camera:mousePosition()

  if addConnection then
    local factory = getFactoryAtPoint(self.factories, mx, my)
    if factory and factory.connections then self.mouse_down = factory end
  end
end

function Build:mousereleased(x, y, button, isTouch)
  x, y = self.camera:mousePosition()
  local addConnection = isTouch or button == 1

  if addConnection then
    local first = self.mouse_down
    local second = getFactoryAtPoint(self.factories, x, y)
    self.mouse_down = nil

    if first and second then
      local tau = math.pi * 2
      local sides = first.mesh:getVertexCount()
      local angle = math.atan2(first.y - y, first.x - x) - math.pi / 2
      if angle < 0 then angle = angle + tau end
      local index = math.ceil(angle / ((math.pi * 2) / sides))
      first:addConnection(index, second)
    end
  else
    local factory = getFactoryAtPoint(self.factories, x, y)
    if factory then
      factory:removeConnection(#factory.connections)
    end
  end
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
