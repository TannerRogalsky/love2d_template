local Goal = class('Goal', Base):include(Stateful)

function Goal:initialize(attributes)
  Base.initialize(self)

  self.tile_x = attributes.tile_x
  self.tile_y = attributes.tile_y
  self.player = attributes.properties.player

  self.body = love.physics.newBody(World, attributes.x, attributes.y, "static")
  self.shape = love.physics.newRectangleShape(attributes.width / 2, attributes.height / 2, attributes.width, attributes.height)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setSensor(true)

  self.triggered = false
end

function Goal:begin_contact(other)
  if self.player and self.player == other.player_name then
    self.triggered = true
    if Goal.check_all_triggered() then
      game:victory()
    end
  end
end

function Goal:end_contact(other)
  if self.player and self.player == other.player_name then
    self.triggered = false
  end
end

function Goal.static.check_all_triggered()
  for _,goal in pairs(level.typed_triggers["Goal"]) do
    if goal.triggered == false then
      return false
    end
  end
  return true
end

return Goal
