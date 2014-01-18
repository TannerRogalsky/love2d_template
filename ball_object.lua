BallObject = class('BallObject', Base):include(Stateful)
BallObject.static.RADIUS = 20
BallObject.static.instances = {}

function BallObject:initialize(x, y)
  Base.initialize(self)

  self.controlled_objects_touching = {}

  self.body = love.physics.newBody(World, x, y, "dynamic")
  self.shape = love.physics.newCircleShape(BallObject.RADIUS)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setRestitution(0.1)

  BallObject.instances[self.id] = self
end

function BallObject:destroy()
  BallObject.instances[self.id] = nil
  self.body:destroy()
end

function BallObject:update(dt)
  local body = self.body
  local vx, vy = body:getLinearVelocity()
  body:setLinearVelocity(vx, vy)
  body:applyForce(-vx, -vy) -- this works really nicely as drag/friction
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
