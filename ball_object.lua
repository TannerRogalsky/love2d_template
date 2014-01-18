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
  self.body:setLinearDamping(0.8)
  self.body:setAngularDamping(100)
  self.fixture:setFriction(1)

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
