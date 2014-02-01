local Loading = Game:addState('Loading')

function Loading:enteredState()
  self.loader = require 'lib/love-loader'
  self.preloaded_images = {}
  self.preloaded_fonts = {}

  -- puts loaded images into the preloaded_images hash with they key being the file name
  local filetypes = {png = true, gif = true, jpg = true}
  local function load_images(container, directory)
    for index, file_name in ipairs(love.filesystem.getDirectoryItems(directory)) do
      -- build the full, relative path of the file
      local full_name = directory .. '/' .. file_name
      if love.filesystem.isDirectory(full_name) then
        -- recurse
        local subcontainer = {}
        container[file_name] = subcontainer
        load_images(subcontainer, full_name)
      else
        -- match the filetype and then queue the image for loading
        local file_name, filetype = full_name:match("^.*/(.+)%.(%a+)$")
        if filetypes[filetype] then
          local key = file_name .. "." .. filetype
          self.loader.newImage(container, key, full_name)
        end
      end
    end
  end
  -- load_images(self.preloaded_images, "images")

  local sizes = {12, 14, 16, 20, 24}
  -- for index, font in ipairs(love.filesystem.getDirectoryItems('fonts')) do
  --   if font:match('(.*).ttf$') ~= nil then
  --     for _,size in ipairs(sizes) do
  --       local key = font .. "_" .. tostring(size)
  --       self.loader.newFont(self.preloaded_fonts, key, 'fonts/' .. font, size)
  --     end
  --   end
  -- end

  self.loader.start(function()
    -- loader finished callback
    -- initialize game stuff here

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
