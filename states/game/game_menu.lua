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
    local level = g.newCanvas(200, 200)
    g.setCanvas(level)
    g.setColor(COLORS.aliceblue:rgb())
    g.rectangle("fill", 0, 0, 200, 200)
    g.setColor(COLORS.white:rgb())
    local tile_layers = MapLoader.load(name).tile_layers
    g.draw(tile_layers["Background"].sprite_batch, 0, 0, 0, 0.25, 0.25)
    g.draw(tile_layers["Foreground"].sprite_batch, 0, 0, 0, 0.25, 0.25)
    g.setCanvas()
    self.all_levels[name] = level
  end

  self.selected_level_index = 1
end

function Menu:draw()
  for index, name in pairs(self.sorted_names) do
    local level = self.all_levels[name]
    g.setColor(COLORS.white:rgb())
    g.draw(self.all_levels[name], (index - 1) * 250, 0)
    if index == self.selected_level_index then
      g.setColor(COLORS.yellow:rgb())
      local old_width = g.getLineWidth()
      g.setLineWidth(4)
      g.rectangle("line", (index - 1) * 250, 0, 200, 200)
      g.setLineWidth(old_width)
    end
  end
end

function Menu:keypressed(key, unicode)
  if key == "return" then
    intromusic:stop()
    self:gotoState("Main", self.sorted_names[self.selected_level_index])
  elseif key == "right" then
    self.selected_level_index = self.selected_level_index + 1
  elseif key == "left" then
    self.selected_level_index = self.selected_level_index - 1
  end
end

function Menu:exitedState()
  self.selected_level_index = nil
  self.all_levels = nil
end

return Menu
