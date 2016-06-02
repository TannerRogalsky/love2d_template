local Loading = Game:addState('Loading')

local function generate_numbers(quant)
  local numbers = {}
  for i=1,quant do
    numbers[i] = math.random(math.pow(2, 12), math.pow(2, 16) - 1)
  end
  return numbers
end

function Loading:enteredState()
  self.loader = require 'lib/love-loader/love-loader'
  self.preloaded_images = {}
  self.preloaded_fonts = {}

  -- puts loaded images into the preloaded_images hash with they key being the file name
  for index, image in ipairs(love.filesystem.getDirectoryItems('images')) do
    if image:match('(.*).png$') ~= nil or image:match('(.*).gif$') ~= nil or image:match('(.*).jpg$') ~= nil then
      self.loader.newImage(self.preloaded_images, image, 'images/' .. image)
    end
  end

  local sizes = {12, 14, 16, 20, 24}
  for index, filename in ipairs(love.filesystem.getDirectoryItems('fonts')) do
    font = filename:match('(.*).ttf$') or filename:match('(.*).TTF$')
    if font then
      for _,size in ipairs(sizes) do
        local key = font .. "_" .. tostring(size)
        self.preloaded_fonts[key] = g.newFont('fonts/' .. filename, size)
      end
    end
  end

  g.setFont(self.preloaded_fonts["04b03_16"])

  self.loader.start(function()
    -- loader finished callback
    -- initialize game stuff here

    self:gotoState("MultiMesh")
  end)

  local hexFormatStringPart = '%X '
  local numbers = {}
  self.numbers_text = g.newText(self.preloaded_fonts['fixedsys_12'])
  local partWidth = self.numbers_text:getFont():getWidth(string.format(hexFormatStringPart, math.pow(2, 12)))
  local partsPerLine = math.ceil(g.getWidth() / partWidth)
  local lineHeight = self.numbers_text:getFont():getHeight()
  local pageLines = math.floor(g.getHeight() / lineHeight)

  local numbers_string = ''
  for i=1,partsPerLine do
    numbers_string = numbers_string .. hexFormatStringPart
  end
  local numLines = pageLines
  for i=0,pageLines do
    local nums = generate_numbers(partsPerLine)
    numbers[i + 1] = nums
    self.numbers_text:add(string.format(numbers_string, unpack(nums)), 0, lineHeight * i)
  end
  self.loading_shader = g.newShader('shaders/loading_shader.glsl')

  self.numbers_update = cron.every(0.1, function()
    table.remove(numbers, 1)
    table.insert(numbers, generate_numbers(partsPerLine))
    self.numbers_text:clear()
    for i=0,pageLines do
      self.numbers_text:add(string.format(numbers_string, unpack(numbers[i + 1])), 0, lineHeight * i)
    end
  end)
end

function Loading:draw()
  local percent = 0
  if self.loader.resourceCount ~= 0 then
    percent = self.loader.loadedCount / self.loader.resourceCount
  end

  g.setColor(255,255,255)
  g.setShader(self.loading_shader)
  g.draw(self.numbers_text, 0, 35)
  g.setShader()

  g.setColor(0, 0, 0)
  g.rectangle("fill", 10, 35, g.getWidth() - 20, 25)
  g.setColor(255, 255, 255)
  g.print(("Loading .. %d%%"):format(percent*100), 10, 10)
  g.rectangle("line", 10, 35, g.getWidth() - 20, 25)
  g.rectangle("fill", 10, 35, (g.getWidth() - 20) * percent, 25)
end

function Loading:update(dt)
  self.numbers_update:update(dt)
  self.loader.update()
end

function Loading:exitedState()
  self.numbers = nil
  self.numbers_text:clear()
  self.numbers_text = nil
  self.numbers_update = nil
  self.loader = nil
end

return Loading
