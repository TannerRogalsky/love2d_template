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

  self.alpha = 0
  local images = {
    circle = game.preloaded_images["beam_pi.png"],
    square = game.preloaded_images["beam_rec.png"]
  }
  self.background_image = images[self.player]
  self.background_image:setFilter("nearest", "nearest")

  self.triggered = false
end

local trigger_time = 1
function Goal:begin_contact(other)
  if self.player and self.player == other.player_name then
    self.trigger_cron = cron.after(trigger_time, function()
      self.triggered = true
      if Goal.check_all_triggered() then
        game:victory()
      end
    end)
  end
end

function Goal:draw()
  local x, y = self.body:getWorldCenter()
  g.setColor(255, 255, 255, self.alpha)
  g.draw(self.background_image, x, y, 0, 1, 1, 0, 21 * 3)
end

function Goal:update(dt)
  if self.trigger_cron then
    self.alpha = math.min(self.alpha + 255 / trigger_time * dt, 255)
  end
end

function Goal:end_contact(other)
  if self.player and self.player == other.player_name then
    self.triggered = false
    self.alpha = 0
    if self.trigger_cron then cron.cancel(self.trigger_cron) end
    self.trigger_cron = nil
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
