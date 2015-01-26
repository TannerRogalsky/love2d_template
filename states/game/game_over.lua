local Over = Game:addState('Over')

function Over:enteredState()
end

function Over:draw()
  g.draw(self.preloaded_images['bg_end.png'])
  local player = self.song.players[1]
  local percent = #player.successes / (#player.successes + #player.failures)
  g.printf(percent * 100 .. "%", 0, g.getHeight() / 2, g.getWidth() / 2, 'center')
  player = self.song.players[2]
  percent = #player.successes / (#player.successes + #player.failures)
  g.printf(percent * 100 .. "%", g.getWidth() / 2, g.getHeight() / 2, g.getWidth() / 2, 'center')
end

function Over:joystickpressed()
  self:gotoState("Menu")
end

function Over:exitedState()
end

return Over
