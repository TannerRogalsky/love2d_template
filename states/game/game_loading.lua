local Loading = Game:addState('Loading')

function Loading:enteredState()
  self.loader = require 'lib/love-loader'
  self.preloaded_images = {}
  self.preloaded_fonts = {}
  self.preloaded_sounds = {}
  local preloaded_sound_data = {}
  self.preloaded_sound_lengths = {}

  -- puts loaded images into the preloaded_images hash with they key being the file name
  for index, image in ipairs(love.filesystem.getDirectoryItems('images')) do
    if image:match('(.*).png$') ~= nil or image:match('(.*).gif$') ~= nil or image:match('(.*).jpg$') ~= nil then
      self.loader.newImage(self.preloaded_images, image, 'images/' .. image)
    end
  end

  local sizes = {12, 14, 16, 20, 24}
  -- for index, font in ipairs(love.filesystem.getDirectoryItems('fonts')) do
  --   if font:match('(.*).ttf$') ~= nil then
  --     for _,size in ipairs(sizes) do
  --       local key = font .. "_" .. tostring(size)
  --       self.loader.newFont(self.preloaded_fonts, key, 'fonts/' .. font, size)
  --     end
  --   end
  -- end

  for index, sound in ipairs(love.filesystem.getDirectoryItems('sounds')) do
    if sound:match('(.*).ogg$') ~= nil then
      self.loader.newSource(self.preloaded_sounds, sound, 'sounds/' .. sound)
      self.loader.newSoundData(preloaded_sound_data, sound, 'sounds/' .. sound)
    end
  end

  self.loader.start(function()
    -- loader finished callback
    -- initialize game stuff here
    for sound,data in pairs(preloaded_sound_data) do
      local sound_length = data:getSize() / data:getSampleRate() / data:getChannels() / (data:getBitDepth() / 8)
      self.preloaded_sound_lengths[self.preloaded_sounds[sound]] = sound_length
    end

    self:gotoState("Main")
  end)
end

function Loading:render()
  local percent = 0
  if self.loader.resourceCount ~= 0 then
    percent = self.loader.loadedCount / self.loader.resourceCount
  end
  g.setColor(255,255,255)
  g.print(("Loading .. %d%%"):format(percent*100), 10, g.getHeight() / 3 * 2 - 25)
  g.rectangle("line", 10, g.getHeight() / 3 * 2, g.getWidth() - 20, 25)
  g.rectangle("fill", 10, g.getHeight() / 3 * 2, (g.getWidth() - 20) * percent, 25)
end

function Loading:update(dt)
  self.loader.update()
end

function Loading:exitedState()
  self.loader = nil
end

return Loading
