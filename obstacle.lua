local Obstacle = class('Obstacle', Base):include(Stateful)

Obstacle.static.instances = {}

function Obstacle:initialize(world, x, y, radius)
  Base.initialize(self)

  self.radius = radius
  self.body = love.physics.newBody(world, x, y, 'dynamic')
  -- self.body:setLinearDamping(0.5)
  -- self.body:setAngularDamping(0.5)

  self.shape = love.physics.newCircleShape(0, 0, self.radius)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)

  Obstacle.instances[self.id] = self
end

function Obstacle:getRadius()
  return self.fixture:getShape():getRadius()
end

function Obstacle:destroy()
  Obstacle.instances[self.id] = nil
  self.body:destroy()
end

return Obstacle
