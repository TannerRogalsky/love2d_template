BallObject = class('BallObject', Base):include(Stateful)
BallObject.static.RADIUS = 20
BallObject.static.instances = {}
BallObject.static.friction_coefficient = 1

function BallObject:initialize(x, y)
  Base.initialize(self)

  self.body = love.physics.newBody(World, x, y, "dynamic")
  self.shape = love.physics.newCircleShape(BallObject.RADIUS)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setRestitution(1)

  BallObject.instances[self.id] = self
end

function BallObject:destroy()
  BallObject.instances[self.id] = nil
  self.body:destroy()
end

function BallObject:update(dt)
  local ball_friction = BallObject.friction_coefficient * dt
  local body = self.body
  local vx, vy = body:getLinearVelocity()
  if vx >= ball_friction then vx = vx - ball_friction
  elseif vx <= -ball_friction then vx = vx + ball_friction
  else vx = 0 end
  if vy >= ball_friction then vy = vy - ball_friction
  elseif vy <= -ball_friction then vy = vy + ball_friction
  else vy = 0 end
  body:setLinearVelocity(vx, vy)
end

function BallObject:render()
  g.setColor(COLORS.green:rgb())
  local x, y = self.body:getPosition()
  g.circle("fill", x, y, self.shape:getRadius())
end

function BallObject:mousepressed(x, y, button)
end

function BallObject:mousereleased(x, y, button)
end

function BallObject:keypressed(key, unicode)
end

function BallObject:keyreleased(key, unicode)
end

function BallObject:joystickpressed(joystick, button)
end

function BallObject:joystickreleased(joystick, button)
end
