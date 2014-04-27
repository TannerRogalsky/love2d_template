local Title = Game:addState('Title')

function Title:enteredState()
  if self.title_image == nil then
    self.title_image = self.preloaded_images["friendshape_controls.png"]
    self.title_image:setFilter("nearest", "nearest")
  end
end

function Title:draw()
  g.setColor(COLORS.white:rgb())
  local bg = self.title_image
  g.draw(bg, 0, 0, 0, g.getWidth() / bg:getWidth(), g.getHeight() / bg:getHeight())
end

function Title:keypressed(key, unicode)
  if key == "escape" then
    love.event.quit()
  else
    self:gotoState("Menu")
  end
end

function Title:joystickpressed(joystick, button)
  if button == 10 then
      love.event.quit()
  else
    self:gotoState("Menu")
  end
end

function Title:exitedState()
end

return Title
