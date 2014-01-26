PowerUp = class('PowerUp', Base):include(Stateful)
PowerUp.static.instances = {}

function PowerUp:initialize(x, y, width, height)
  Base.initialize(self)

  self.image = game.preloaded_images["upvote.png"]
  self.width = width or self.image:getWidth()
  self.height = height or self.image:getHeight()

  self.body = love.physics.newBody(World, x, y, "static")
  self.shape = love.physics.newRectangleShape(self.width, self.height)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setSensor(true)

  PowerUp.instances[self.id] = self
end

function PowerUp:update(dt)
end

function PowerUp:render()
  g.setColor(COLORS.white:rgb())
  local x, y = self.body:getWorldCenter()
  local iw, ih = self.image:getWidth(), self.image:getHeight()
  local sx, sy = self.width / iw, self.height / ih
  g.draw(self.image, x, y, 0, sx, sy, self.width / sx / 2, self.height / sy / 2)
end

function PowerUp:destroy()
  self.body:destroy()
  PowerUp.instances[self.id] = nil
end

function PowerUp:begin_contact(other, contact)
  if instanceOf(ControlledObject, other) then
    local player = other:get_player()
    player.time_to_spawn = player.time_to_spawn / Player.SPAWN_TIME_DIVISOR
    self:destroy()
  end
end
