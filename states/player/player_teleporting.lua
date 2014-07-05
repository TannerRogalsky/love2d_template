local Teleporting = Player:addState('Teleporting')
local teleport_time = 1

function Teleporting:enteredState()
  cron.after(teleport_time, function()
    self.body:move(self.teleport_distance, 0)
    self:gotoState()
  end)
  self.teleport_progress = 0
end

function Teleporting:update(dt)
  self.teleport_progress = self.teleport_progress + dt
end

function Teleporting:draw()
  local x1,y1, x2,y2 = self.body:bbox()
  local x, y, w, h = x1, y1, x2-x1, y2-y1
  g.setColor(COLORS.red:rgb())
  g.setScissor(x, y, w+1, h * (self.teleport_progress / teleport_time))
  g.rectangle('fill', x, y, w, h)

  x = x + self.teleport_distance
  g.setScissor(x, y + h * (self.teleport_progress / teleport_time), w+1, h / (self.teleport_progress / teleport_time))
  g.rectangle('fill', x, y, w, h)
  g.setScissor()
end

function Teleporting:exitedState()
  self.teleport_progress = nil
end

return Teleporting
