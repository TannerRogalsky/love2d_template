local Menu = Game:addState('Menu')

function Menu:enteredState()
  self:randomize_title()
end

function Menu:render()
  g.print(table.concat(self.title), 0, 0)
end

function Menu:keypressed(key, unicode)
  if key == "r" then
    self:randomize_title()
  else
    self:gotoState("Main")
  end
end

function Menu:randomize_title()
  local title_words = {"mega", "hyper", "penguin", "sportball", "ultra", "super"}
  self.title = {}
  for i=1,4 do
    table.insert(self.title, table.sample(title_words))
  end

  local runtime = 0.1
  for _,title_word in ipairs(self.title) do
    local sound = self.preloaded_sounds[title_word .. ".ogg"]
    local sound_length = self.preloaded_sound_lengths[sound]
    cron.after(runtime, love.audio.play, sound)
    runtime = runtime + sound_length + 0.2
  end
end

function Menu:exitedState()
end

return Menu
