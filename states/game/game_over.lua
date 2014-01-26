local Over = Game:addState('Over')

function Over:enteredState(winner)
  self.winner = winner
  self.text = winner.color.name .. " player wins"

  cron.after(3, function()
    self.allow_continue = true
  end)
end

function Over:render()
  g.setColor(self.winner.color:rgb())
  g.printf(self.text, 0, g.getHeight() / 2, g.getWidth(), "center")
end

function Over:keyreleased(key, unicode)
  if self.allow_continue then
    self:gotoState("Menu")
  end
end

function Over:joystickreleased(joystick, button)
  if self.allow_continue then
    self:gotoState("Menu")
  end
end

function Over:exitedState()
  self.allow_continue = nil
  self.winner = nil
  self.text = nil
end

return Over
