local Main = Game:addState('Main')

local function buildBounds(world, w, h)
  local e, f = love.physics.newEdgeShape, love.physics.newFixture
  local bounds = love.physics.newBody(world)
  f(bounds, e(0, 0, w, 0))
  f(bounds, e(w, 0, w, h))
  f(bounds, e(w, h, 0, h))
  f(bounds, e(0, h, 0, 0))
  return bounds
end

local function drawBody(body, color)
  local bodyX=body:getX()
  local bodyY=body:getY()
  local bodyAngle=body:getAngle()
  for i,fixture in ipairs(body:getFixtureList()) do
    local shape=fixture:getShape()
    local shapeType = shape:type()
    local shapeR=shape:getRadius()
    if shapeType=="CircleShape" then
      color[4]=255
      love.graphics.setColor(color)
      love.graphics.circle("line", bodyX, bodyY, shapeR)
      love.graphics.line(bodyX,bodyY,bodyX+math.cos(bodyAngle)*shapeR,bodyY+math.sin(bodyAngle)*shapeR)
      color[4]=50
      love.graphics.setColor(color)
      love.graphics.circle("fill", bodyX, bodyY, shapeR)
    elseif shapeType=="ChainShape" or shapeType=="EdgeShape" then
      color[4]=255
      love.graphics.setColor(color)
      love.graphics.line(body:getWorldPoints(shape:getPoints()))
    else
      color[4]=255
      love.graphics.setColor(color)
      love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
      color[4]=50
      love.graphics.setColor(color)
      love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
    end
  end
end

function Main:enteredState(level_data)
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  self.world = love.physics.newWorld()
  self.world:setCallbacks(unpack(require('physics_callbacks')))

  self.world_width, self.world_height = 500, 500
  buildBounds(self.world, self.world_width, self.world_height)

  for _,object in ipairs(level_data) do
    if object.type == 'start' then
      self.ball = Ball:new(self.world, object.x, object.y, 50)
      self.ball.body:setAngle(math.pi / 2)
      -- self.ball = Ball:new(self.world, 250, 250, 250)
    elseif object.type == 'obstacle' then
      Obstacle:new(self.world, object.x, object.y, object.radius)
    elseif object.type == 'end' then
      self.goal = Goal:new(self.world, object.x, object.y, object.radius)
      -- self.goal = Goal:new(self.world, 1000, 1000, object.radius)
    end
  end

  g.setBackgroundColor(255, 255, 255)
  love.mouse.setGrabbed(true)
  local cx, cy = self.world_width / 2 - g.getWidth() / 2, self.world_height / 2 - g.getHeight() / 2
  self.camera.bounds.negative_x = -500
  self.camera.bounds.negative_y = -500
  self.camera.bounds.positive_x = 0
  self.camera.bounds.positive_y = 0
  self.camera:setPosition(cx, cy)
  g.setFont(self.preloaded_fonts["04b03_16"])

  self.sphere_shader = g.newShader('shaders/sphere.glsl')
end

function Main:update(dt)
  self.world:update(dt)
  self.ball:update(dt)

  -- self.sphere_shader:send('time', love.timer.getTime() / 100)

  local delta = 5
  local mx, my = self.camera:mousePosition()
  local cx, cy = 0, 0

  if mx <= self.camera.x + delta then cx = cx - delta end
  if mx >= self.camera.x + g.getWidth() - delta then cx = cx + delta end
  if my <= self.camera.y + delta then cy = cy - delta end
  if my >= self.camera.y + g.getHeight() - delta then cy = cy + delta end

  -- if cx == 0 and cy == 0 then
  --   cx = math.clamp(-delta, (self.world_width / 2 - g.getWidth() / 2) - self.camera.x, delta)
  --   cy = math.clamp(-delta, (self.world_height / 2 - g.getHeight() / 2) - self.camera.y, delta)
  -- end

  self.camera:move(cx, cy)
end

function Main:draw()
  self.camera:set()

  g.setWireframe(love.keyboard.isDown('space'))

  g.setColor(0, 0, 0)
  g.rectangle('fill', 0, 0, 500, 500)

  -- g.setShader(self.sphere_shader)
  -- g.draw(game.preloaded_images['earth.png'], 500, 0, 0, 0.5)
  -- g.setShader()

  g.setColor(255, 0, 0)
  -- g.setShader(self.sphere_shader)
  self.ball:draw()
  -- g.setShader()

  local ballRadius = self.ball:getRadius()
  for id, obstacle in pairs(Obstacle.instances) do
    local color = obstacle:getRadius() < ballRadius and {255, 0, 255, 255} or {0, 255, 255, 255}
    drawBody(obstacle.body, color)
  end

  drawBody(self.goal.body, {0, 255, 0, 255})

  local bx, by = self.ball.body:getLinearVelocity()
  if math.abs(bx) <= 1 and math.abs(by) <= 1 then
    self.ball.body:setLinearVelocity(0, 0)
    local bx, by = self.ball.body:getPosition()
    local mx, my = self.camera:mousePosition()
    g.setColor(0, 255, 0)
    g.line(mx, my, bx, by)
  end

  self.camera:unset()
end

function Main:wheelmoved(x, y)
  local sd = 0.1
  if y > 0 then
    self.camera:scale(1 - sd, 1 - sd)
  elseif y < 0 then
    self.camera:scale(1 + sd, 1 + sd)
  end
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
  if not self.ball.body:isAwake() then
    x, y = self.camera:mousePosition()
    local bx, by = self.ball.body:getPosition()
    local s = 100
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
