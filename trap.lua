Trap = class('Trap', Base):include(Stateful)
Trap.static.SIZE_INCREASE = 1.5

function Trap:initialize(x, y, w, h)
  Base.initialize(self)

  self.body = love.physics.newBody(World, x, y, "kinematic")
  self.shape = love.physics.newRectangleShape(w, h)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setSensor(true)

  -- we want slightly larger box to render than the collision box
  self.render_vertices = {}
  local points = {self.shape:getPoints()}
  for _,vertex in ipairs(points) do
    table.insert(self.render_vertices, vertex * Trap.SIZE_INCREASE)
  end
end

function Trap:update(dt)
end

function Trap:render()
  g.setColor(COLORS.red:rgb())
  g.polygon("fill", self.body:getWorldPoints(unpack(self.render_vertices)))

  g.setColor(COLORS.black:rgb())
  g.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

function Trap:begin_contact(other, contact)
  if instanceOf(ControlledObject, other) then
    other:destroy()
  end
end
