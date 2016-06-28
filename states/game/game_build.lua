local Build = Game:addState('Build')
local generateVertices = require('factories.generate_vertices')
local intervalIterator = require('factories.interval_iterator')

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

  self.factories = {}

  do
    local s = 3
    local radius = SIZE * 2.5
    for i=1,s do
      local d = radius * i
      local n = math.floor(math.pi * d / (SIZE * 1.5))
      local producer_interval = math.ceil(n / 3)
      for j, phi in intervalIterator(n) do
        local x = math.cos(phi) * d
        local y = math.sin(phi) * d

        if i == s then
          local p = (phi - math.pi / 2 + math.pi) % (math.pi * 2)
          if p % (math.pi * 2 / 3) == 0 then
            local factory = newProducingFactory(meshes[1], x, y)
            factory.providing_color = j / producer_interval / 3
            table.insert(self.factories, factory)
          else
            table.insert(self.factories, newProtoFactory(meshes[0], x, y))
          end
        else
          table.insert(self.factories, newProtoFactory(meshes[0], x, y))
        end
      end
    end
  end
  table.insert(self.factories, Combinator:new(0, 0))

  self.mouse_down = nil

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

  for _,factory in ipairs(self.factories) do
    factory:draw()
  end

  do
    local cycle_length = 3
    local cycle = time % cycle_length

    g.setBlendMode('multiply')
    -- g.setColor(100, 100, 100)
    for _,factory in ipairs(self.factories) do
      if factory.color then
        g.setColor(hsl2rgb(factory.color, 0.5, 0.5))
      else
        g.setColor(125, 125, 125)
      end
      factory:drawResources(SIZE, cycle / cycle_length)
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
      local t = (2 * math.pi) / sides
      local angle = math.atan2(first.y - y, first.x - x) - math.pi / 2
      local rotation_offset = half_pi
      if sides % 2 == 0 then angle = angle - t  / 2 end
      if angle < 0 then angle = angle + tau end
      local index = math.ceil(angle / ((math.pi * 2) / sides))

      if first.connections[index] == nil then
        first:addConnection(index, second)
      end
    end
  else
    local factory = getFactoryAtPoint(self.factories, x, y)
    if factory then
      for i,connection in pairs(factory.connections) do
        factory:removeConnection(i)
      end
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
