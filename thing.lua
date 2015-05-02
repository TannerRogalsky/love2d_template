local Thing = class('Thing', Base):include(Stateful)
Thing.static.instances = {}

function Thing:initialize(x, y)
  Base.initialize(self)

  self.x = x
  self.y = y

  self.r = 28
  self.g = 62
  self.b = 68

  Thing.instances[self.id] = self

  self.move_cron = cron.every(1, function()
    self.x = self.x + love.math.random(3) - 2
    self.y = self.y + love.math.random(3) - 2

    self:timed_move()
  end)
end

function Thing:timed_move()

end

function Thing:update(dt)
  self.move_cron:update(dt)
end

function Thing:destroy()
  Thing.instances[self.id] = nil
end

return Thing