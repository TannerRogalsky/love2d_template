local Menu = Game:addState('Menu')

function Menu:enteredState()
  love.window.setFullscreen(true, "desktop")
  self.background = game.preloaded_images["title.png"]
  self.two_player_button = {414,444, 800,444, 800,530, 414,530}
  self.four_player_button = {414,565, 800,565, 800,650, 414,650}

  love.audio.play(game.preloaded_sounds["sportball_music.ogg"])
end

function Menu:render()
  g.setColor(COLORS.white:rgb())
  g.draw(self.background, 0, 0)
end

function Menu:check_point(rect, x, y)
  local x1,y1, x2,y2, x3,y3, x4,y4 = unpack(rect)
  if x > x1 and x < x2 and y > y1 and y < y4 then
    return true
  end
  return false
end

function Menu:keypressed(key, unicode)
  if key == "2" or key == "4" then
    self:gotoState("Main", "level" .. key)
  end
end

function Menu:mousepressed(x, y, button)
  if self:check_point(self.two_player_button, x, y) then
    self:gotoState("Main", "level2")
  elseif self:check_point(self.four_player_button, x, y) then
    self:gotoState("Main", "level4")
  end
end

function Menu:exitedState()
  self.background = nil
end

return Menu
