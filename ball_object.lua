BallObject = class('BallObject', Base):include(Stateful)
BallObject.static.RADIUS = 20
BallObject.static.MASS = 0.1
BallObject.static.LINEAR_DAMPING = 0.8
BallObject.static.instances = {}

function BallObject:initialize(x, y)
  Base.initialize(self)

  self.controlled_objects_touching = {}

  self.body = love.physics.newBody(World, x, y, "dynamic")
  self.shape = love.physics.newCircleShape(BallObject.RADIUS)
  self.fixture = love.physics.newFixture(self.body, self.shape)

  self.fixture:setUserData(self)
  self.fixture:setRestitution(0.1)
  self.fixture:setFriction(1)

  self.body:setLinearDamping(BallObject.LINEAR_DAMPING)
  self.body:setAngularDamping(100)
  self.body:setMass(BallObject.MASS)

  BallObject.instances[self.id] = self
end

function BallObject:destroy()
  BallObject.instances[self.id] = nil
  self.body:destroy()
end

function BallObject:update(dt)
end

function BallObject:render()
  g.setColor(COLORS.green:rgb())
  local x, y = self.body:getPosition()
  g.circle("fill", x, y, self.shape:getRadius())

  local vx, vy = self.body:getLinearVelocity()
  local vnx, vny = Vector.normalize(vx, vy)
  local vnx, vny = vnx * self.shape:getRadius(), vny * self.shape:getRadius()
  g.setColor(COLORS.black:rgb())
  g.line(x, y, x + vnx, y + vny)
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
