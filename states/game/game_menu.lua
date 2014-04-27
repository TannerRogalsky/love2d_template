local Menu = Game:addState('Menu')

intromusic = love.audio.newSource("/sounds/intromusic.ogg", "stream")
intromusic:play()
intromusic:setVolume(0.5)
intromusic:setLooping("true")


function Menu:enteredState()
  self.sorted_names = {}
  for name,_ in pairs(self.preloaded_levels) do
    table.insert(self.sorted_names, name)
  end
  table.sort(self.sorted_names)

  self.all_levels = {}
  for _, name in pairs(self.sorted_names) do
    local level = g.newCanvas(400, 400)
    g.setCanvas(level)
    g.setColor(COLORS.cornflowerblue:rgb())
    g.rectangle("fill", 0, 0, 400, 400)
    g.setColor(COLORS.white:rgb())
    local tile_layers = MapLoader.load(name).tile_layers
    g.draw(tile_layers["Background"].sprite_batch, 0, 0, 0, 0.5, 0.5)
    g.draw(tile_layers["Foreground"].sprite_batch, 0, 0, 0, 0.5, 0.5)
    g.setCanvas()
    self.all_levels[name] = level
  end

  self.selected_level_index = 1

end

function Menu:draw()
  local dy = love.graphics.getFont():getHeight() + 3
  for index,name in ipairs(self.sorted_names) do
    local x, y = 5, index * dy
    g.setColor(COLORS.white:rgb())
    g.print(name, x, y)

    if index == self.selected_level_index then
      g.setColor(COLORS.yellow:rgb())
      local old_width = g.getLineWidth()
      g.setLineWidth(2)
      g.rectangle("line", x - 2, y - 2, g.getFont():getWidth(name) + 4, dy)
      g.setLineWidth(old_width)
    end
  end

  g.setColor(COLORS.white:rgb())
  g.draw(self.all_levels[self.sorted_names[self.selected_level_index]], 200, 100)
end

function Menu:keypressed(key, unicode)
  if key == "return" then
    intromusic:stop()
    self:gotoState("Main", self.sorted_names[self.selected_level_index])
    return
  elseif key == "down" then
    self.selected_level_index = self.selected_level_index + 1
  elseif key == "up" then
    self.selected_level_index = self.selected_level_index - 1
  end
  self.selected_level_index = math.clamp(1, self.selected_level_index, #self.sorted_names)
end

function Menu:exitedState()
  self.selected_level_index = nil
  self.all_levels = nil
end

return Menu
