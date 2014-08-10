local Over = Game:addState('Over')

function Over:enteredState(winner)
  self.image = winner.game_over_image
end

function Over:draw()
  g.setColor(COLORS.white:rgb())
  g.draw(self.image, 0, 0)
end

function Over:keypressed(key)
  if key == "return" or key == " " then
    self:gotoState("Menu")
  end
end

function Over:gamepadpressed(joystick, button)
  if button == "start" then
    self:gotoState("Menu")
  end
end

function Over:exitedState()
  self.image = nil
end

return Over
