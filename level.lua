Level = class('Level', Base)

function Level:initialize(data)
  Base.initialize(self)

  self.obstructions = {}
  for _,obstructon_data in ipairs(data.obstructions) do
    local obstruction = self:new_obstruction(unpack(obstructon_data.geometry))
    self.obstructions[obstruction.fixture] = obstruction
  end
end

function Level:update(dt)
end

function Level:render()
  g.setColor(COLORS.blue:rgb())
  for _,obstruction in pairs(self.obstructions) do
    g.polygon("fill", obstruction.body:getWorldPoints(obstruction.shape:getPoints()))
  end
end

function Level:new_obstruction(x, y, w, h)
  local object = {}
  object.body = love.physics.newBody(World, x, y, "static")
  object.shape = love.physics.newRectangleShape(w, h)
  object.fixture = love.physics.newFixture(object.body, object.shape)
  return object
end
