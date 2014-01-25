Obstruction = class('Obstruction', Base):include(Stateful)

function Obstruction:initialize(x, y, w, h)
  Base.initialize(self)

  self.body = love.physics.newBody(World, x, y, "static")
  self.shape = love.physics.newRectangleShape(w, h)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
end

function Obstruction:update(dt)
end

function Obstruction:render()
  g.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end
