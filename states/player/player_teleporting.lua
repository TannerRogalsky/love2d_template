local Teleporting = Player:addState('Teleporting')
local teleport_time = 1.2

function Teleporting:enteredState()
  cron.after(teleport_time, function()
    self.body:move(self.teleport_distance, 0)
    self:gotoState("Falling")
  end)
  self.teleport_progress = 0
end

function Teleporting:update(dt)
  self.teleport_progress = self.teleport_progress + dt
end

function Teleporting:keypressed(key, unicode)
end

function Teleporting:draw()
  local x1,y1, x2,y2 = self.body:bbox()
  local x, y, w, h = x1, y1, x2-x1, y2-y1
  local cx, cy = game.camera.x, game.camera.y
  local sx, sy = game.camera.scaleX, game.camera.scaleY
  local scissor_x, scissor_y = (x - cx) / sx, (y - cy) / sy
  g.setScissor(
    scissor_x,
    scissor_y,
    w / sx + 1,
    (h / sy) * (self.teleport_progress / teleport_time))
  g.setColor(COLORS.white:rgb())
  self.animation:draw(self.image, x, y, 0, 1 / 3)

  scissor_x = scissor_x + self.teleport_distance / sx
  x = x + self.teleport_distance
  g.setScissor(
    scissor_x,
    scissor_y + (h / sy) - (h / sy) * (self.teleport_progress / teleport_time),
    w / sx + 1,
    (h / sy) / (self.teleport_progress / teleport_time))
  g.setColor(COLORS.white:rgb())
  self.animation:draw(self.image, x, y, 0, 1 / 3)
  g.setScissor()
end

function Teleporting:exitedState()
  self.teleport_progress = nil
end

return Teleporting
