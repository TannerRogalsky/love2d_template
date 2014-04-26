local Loading = Game:addState('Loading')

function Loading:enteredState()
  self.loader = require 'lib/love-loader'
  self.preloaded_images = {}
  self.preloaded_fonts = {}
  self.preloaded_levels = {}

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

  for index, level in ipairs(love.filesystem.getDirectoryItems('levels')) do
    local level_name = level:match("(.*).lua$")
    if level_name then
      self.preloaded_levels[level_name] = require("levels/" .. level_name)
    end
  end

  self.loader.start(function()
    -- loader finished callback
    -- initialize game stuff here

    -- love.window.setFullscreen(true, "normal")
    self:gotoState("Menu")
  end)
end

function Loading:draw()
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
