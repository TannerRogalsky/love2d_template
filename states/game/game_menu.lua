local Menu = Game:addState('Menu')

function Menu:enteredState()
end

function Menu:draw()
  g.draw(self.preloaded_images['bg_menu.png'])
end

function Menu:joystickpressed()
  self:gotoState("Main")
end

function Menu:exitedState()
end

return Menu
