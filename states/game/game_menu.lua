local Menu = Game:addState('Menu')

function Menu:enteredState()
  self.menu_font = g.newFont("fonts/04b03.TTF", 48)
  g.setFont(self.menu_font)

  self.sorted_names = {}
  for name,_ in pairs(self.preloaded_levels) do
    table.insert(self.sorted_names, name)
  end
  table.sort(self.sorted_names)

  self.all_levels = {}
  for _, name in pairs(self.sorted_names) do
    local level = g.newCanvas()
    g.setCanvas(level)
    g.setColor(COLORS.cornflowerblue:rgb())
    g.rectangle("fill", 0, 0, level:getWidth(), level:getHeight())
    g.setColor(COLORS.white:rgb())
    local level_data = MapLoader.load(name)
    local tile_layers = level_data.tile_layers
    g.draw(tile_layers["Background"].sprite_batch, 0, 0, 0, level_data.scale, level_data.scale)
    g.draw(tile_layers["Foreground"].sprite_batch, 0, 0, 0, level_data.scale, level_data.scale)
    g.setCanvas()
    self.all_levels[name] = level
  end

  self.selected_level_index = 1

end

function Menu:draw()
  g.setColor(COLORS.white:rgb())
  g.draw(self.all_levels[self.sorted_names[self.selected_level_index]], 0, 0)

  local dy = love.graphics.getFont():getHeight() + 3
  for index,name in ipairs(self.sorted_names) do
    local x, y = 5, index * dy
    g.setColor(COLORS.black:rgb())
    g.printf(name, 0, y, g.getWidth(), "center")

    if index == self.selected_level_index then
      g.setColor(COLORS.yellow:rgb())
      local old_width = g.getLineWidth()
      g.setLineWidth(2)
      g.rectangle("line", g.getWidth() / 3, y - 2, g.getWidth() / 3, dy)
      g.setLineWidth(old_width)
    end
  end
end

function Menu:keypressed(key, unicode)
  if key == "return" then
    self:gotoState("Main", self.sorted_names[self.selected_level_index])
    return
  elseif key == "down" then
    self.selected_level_index = self.selected_level_index + 1
  elseif key == "up" then
    self.selected_level_index = self.selected_level_index - 1
  elseif key == "escape" then
    love.event.push("quit")
  end
  self.selected_level_index = math.clamp(1, self.selected_level_index, #self.sorted_names)
end

function Menu:exitedState()
  self.selected_level_index = nil
  self.all_levels = nil
end

return Menu
