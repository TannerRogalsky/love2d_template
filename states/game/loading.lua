local Loading = Game:addState('Loading')

function Loading:enteredState()
  self.loader = require 'lib/love-loader'
  self.preloaded_image = {}

  -- puts loaded images into the preloaded_image hash with they key being the file name
  for index, image in ipairs(love.filesystem.enumerate('images')) do
    if image:match('(.*).png$') ~= nil or image:match('(.*).gif$') ~= nil or image:match('(.*).jpg$') ~= nil then
      self.loader.newImage(self.preloaded_image, image, 'images/' .. image)
    end
  end

  self.loader.start(function()
    -- loader finished callback
    -- initialize game stuff here

    self:gotoState("Menu")
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
