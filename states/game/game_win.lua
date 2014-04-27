local Win = Game:addState('Win')

function Win:enteredState()
end

function Win:draw()
  g.setColor(COLORS.white:rgb())
  g.draw(self.final_screen, 0, 0)
  g.setColor(0, 0, 0, 255 / 2)
  g.rectangle("fill", 0, 0, g.getWidth(), g.getHeight())
  g.setColor(COLORS.white:rgb())
  g.draw(self.preloaded_images["win.png"], 0, 0)
end

function Win:keypressed(key, unicode)
  self:gotoState("Menu")
end

function Win:joystickpressed(joystick, button)
  self:gotoState("Menu")
end

function Win:exitedState()
end

return Win
