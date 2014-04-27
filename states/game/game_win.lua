local Win = Game:addState('Win')

local victorysound = love.audio.newSource( "/sounds/victorysound.ogg", "static" )
victorysound:setVolume(0.2)

function Win:enteredState()
  self.waiting = true
  cron.after(0.5, function()
    self.waiting = false
  end)
  bgm:stop()
  victorysound:play()
end

function Win:draw()
  g.setColor(COLORS.white:rgb())
  g.draw(self.final_screen, 0, 0)
  g.setColor(0, 0, 0, 255 / 2)
  g.rectangle("fill", 0, 0, g.getWidth(), g.getHeight())
  g.setColor(COLORS.white:rgb())
  local fg = self.preloaded_images["win.png"]
  g.draw(fg, 0, 0, 0, g.getWidth() / fg:getWidth(), g.getHeight() / fg:getHeight())
end

function Win:keypressed(key, unicode)
  if self.waiting then return end
  self:gotoState("Menu")
end

function Win:joystickpressed(joystick, button)
  if self.waiting then return end
  self:gotoState("Menu")
end

function Win:exitedState()
  love.audio.stop()
  love.audio.play(intromusic)
end

return Win
