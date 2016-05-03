local Goal = class('Goal', Base):include(Stateful)

function Goal:initialize(world, x, y, radius)
  Base.initialize(self)

  self.radius = radius
  self.body = love.physics.newBody(world, x, y, 'dynamic')
  -- self.body:setLinearDamping(0.5)
  -- self.body:setAngularDamping(0.5)

  self.shape = love.physics.newCircleShape(0, 0, self.radius)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
end

function Goal:getRadius()
  return self.fixture:getShape():getRadius()
end

function Goal:destroy()
  game:over()
  self.body:destroy()
end

return Goal
