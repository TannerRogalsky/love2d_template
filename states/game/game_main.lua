local Main = Game:addState('Main')

local generate = require('generator')
local mask = require('masker')

local function debugRender(tiles)
  g.setColor(0, 255, 0)
  local w, h = 50, 50
  for _,tile in ipairs(tiles) do
    g.rectangle('fill', tile.x * w, tile.y * h, w, h)
  end
  g.setColor(255, 255, 255)
end

local function physicsDebugRender(body)
  g.push()
  local x, y = body:getPosition()
  g.translate(x, y)
  g.rotate(body:getAngle())

  for _,fixture in ipairs(body:getFixtureList()) do
    local shape = fixture:getShape()
    g.line(shape:getPoints())
  end
  g.pop()
end

function Main:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  self.world = love.physics.newWorld()
  self.world:setCallbacks(require('physics_callbacks'))
  tiles = generate()
  tilesBody = mask(tiles, self.world, 50, 50)

  self.ball = Ball:new(self.world, 25, 25, 10)

  g.setFont(self.preloaded_fonts["04b03_16"])

  self.camera:move(-100, -100)
end

function Main:update(dt)
  self.world:update(dt)
end

function Main:draw()
  self.camera:set()

  debugRender(tiles)
  physicsDebugRender(tilesBody)

  g.setColor(0, 0, 0)
  self.ball:draw()
  g.setColor(255, 255, 255)

  if not self.ball.body:isAwake() then
    local bx, by = self.ball.body:getPosition()
    local mx, my = self.camera:mousePosition()
    g.line(mx, my, bx, by)
  end

  self.camera:unset()
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
  if not self.ball.body:isAwake() then
    x, y = self.camera:mousePosition()
    local bx, by = self.ball.body:getPosition()
    local s = 30
    self.ball.body:applyForce((bx - x) * s, (by - y) * s)
  end
end

function Main:keypressed(key, scancode, isrepeat)
  if key == '=' then
    self.ball:setVertexNumber(self.ball.sides + 1)
  elseif key == '-' then
    self.ball:setVertexNumber(self.ball.sides - 1)
  elseif key == 'r' then
    self:gotoState('Main')
  end
end

function Main:keyreleased(key, scancode)
end

function Main:gamepadpressed(joystick, button)
end

function Main:gamepadreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
  self.world:destroy()
  self.camera = nil
end

return Main
