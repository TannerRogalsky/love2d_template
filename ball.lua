Ball = class('Ball', Base)

function Ball:initialize(x, y, radius)
  Base.initialize(self)

  self.body = love.physics.newBody(World, x, y, "dynamic")
  self.shape = love.physics.newCircleShape(radius)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setRestitution(0.5)
end

function Ball:render()
  g.setColor(COLORS.black:rgb())
  local x, y = self.body:getWorldCenter()
  g.circle("fill", x, y, self.shape:getRadius())
end

function Ball:destroy()
  self.body:destroy()
end
