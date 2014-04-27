local Hazard = class('Hazard', Base):include(Stateful)

function Hazard:initialize(attributes)
  Base.initialize(self)

  self.tile_x = attributes.tile_x
  self.tile_y = attributes.tile_y

  self.body = love.physics.newBody(World, attributes.x, attributes.y, "static")
  self.shape = love.physics.newRectangleShape(attributes.width / 2, attributes.height / 2, attributes.width, attributes.height)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setSensor(true)
end

function Hazard:begin_contact(other)
  game:failure()
end

return Hazard
