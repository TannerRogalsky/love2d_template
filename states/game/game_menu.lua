local Menu = Game:addState('Menu')

function Menu:enteredState()
  self.image = game.preloaded_images["title.png"]
end

function Menu:draw()
  g.setColor(COLORS.white:rgb())
  g.draw(self.image, 0, 0)
end

function Menu:keypressed(key)
  if key == "return" or key == " " then
    self:gotoState("Main")
  end
end

function Menu:gamepadpressed(joystick, button)
  if button == "start" then
    self:gotoState("Main")
  end
end

function Menu:exitedState()
  self.image = nil
end

return Menu
