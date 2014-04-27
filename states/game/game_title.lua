local Title = Game:addState('Title')

function Title:enteredState()
end

function Title:draw()
  g.draw(self.preloaded_images["friendshape.png"], 0, 0)
end

function Title:keypressed(key, unicode)
  self:gotoState("Menu")
end

function Title:joystickpressed(joystick, button)
  self:gotoState("Menu")
end

function Title:exitedState()
end

return Title
