local Title = Game:addState('Title')

function Title:enteredState()
  self.preloaded_images["friendshape.png"]:setFilter("nearest", "nearest")
end

function Title:draw()
  local bg = self.preloaded_images["friendshape.png"]
  g.draw(bg, 0, 0, 0, g.getWidth() / bg:getWidth(), g.getHeight() / bg:getHeight())
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
