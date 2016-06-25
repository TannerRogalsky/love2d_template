local Menu = Game:addState('Menu')

function Menu:enteredState()
  self.level_index = 1

  local font = g.getFont()
  self.max_text_width = 0
  for i,name in ipairs(self.sorted_names) do
    local width = font:getWidth(name)
    if width > self.max_text_width then
      self.max_text_width = width
    end
  end
  self.max_text_width = self.max_text_width + 20
  self.max_text_height = font:getHeight() + 10
end

function Menu:draw()
  do
    g.setColor(255, 255, 255)
    local level = self.preloaded_levels[self.sorted_names[self.level_index]]
    local w, h = level.width, level.height
    local s = g.getHeight() / h
    local bg = self.sprites.quads['bg']
    local _, _, bgw, bgh = bg:getViewport()
    g.draw(self.sprites.texture, bg, 0, 0, 0, g.getHeight() / bgh)
    for i,layer in ipairs(level.layers) do
      g.draw(layer, g.getWidth() / 2 - w / 2 * s, g.getHeight() / 2 - h / 2 * s, 0, s)
    end
  end

  g.push()
  g.translate(g.getWidth() / 2, g.getHeight() / 2)
  for i,level_name in ipairs(self.sorted_names) do
    local index = i - self.level_index
    local x = -self.max_text_width / 2
    local y = self.max_text_height / 2 + index * self.max_text_height
    if i == self.level_index then
      g.setColor(255, 255, 0)
      g.rectangle('line', x, y - self.max_text_height / 4, self.max_text_width, self.max_text_height)
    else
      g.setColor(0, 0, 0)
    end
    g.printf(level_name, -g.getWidth() / 2, y, g.getWidth(), 'center')
  end
  g.pop()
end

function Menu:keypressed(key, scancode, isrepeat)
  if key == 'up' then
    self.level_index = math.max(1, self.level_index - 1)
  elseif key == 'down' then
    self.level_index = math.min(#self.sorted_names, self.level_index + 1)
  end
end

function Menu:keyreleased(key, scancode)
  if key == 'return' then
    self:gotoState('Main')
  elseif key == "escape" then
    love.event.push("quit")
  end
end

function Menu:gamepadpressed(joystick, button)
  print(joystick, button)
end

function Menu:gamepadreleased(joystick, button)
  print(joystick, button)
end

function Menu:exitedState()
end

return Menu
