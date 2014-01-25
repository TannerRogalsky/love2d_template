Trap = class('Trap', Base):include(Stateful)

function Trap:initialize(x, y, w, h)
  Base.initialize(self)

  self.body = love.physics.newBody(World, x, y, "kinematic")
  self.shape = love.physics.newRectangleShape(w, h)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setSensor(true)
end

function Trap:update(dt)
end

function Trap:render()
  g.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

function Trap:begin_contact(other, contact)
  if instanceOf(ControlledObject, other) then
    other:destroy()
  end
end
