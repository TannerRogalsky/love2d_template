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

  self:timed_move()
end

function Thing:timed_move()
  cron.after(math.random(5), function()
    self.x = self.x + math.random(3) - 2
    self.y = self.y + math.random(3) - 2

    self:timed_move()
  end)
end

function Thing:update(dt)

end

function Thing:destroy()
  Thing.instances[self.id] = nil
end

return Thing