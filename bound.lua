Bound = class('Bound', Base)

function Bound:initialize(x1, y1, x2, y2, section, direction)
  Base.initialize(self)

  self.section = section
  self.direction = direction

  self.body = love.physics.newBody(World, 0, 0, "static")
  self.shape = love.physics.newEdgeShape(x1, y1, x2, y2)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setSensor(true)
end

function Bound:render()
  g.setColor(COLORS.green:rgb())
  g.line(self.body:getWorldPoints(self.shape:getPoints()))
end

function Bound:begin_contact(other, contact)
  local x, y = contact:getNormal()
  print(self.direction.cardinal_name, x, y)
end

function Bound:destroy()
  self.body:destroy()
end
