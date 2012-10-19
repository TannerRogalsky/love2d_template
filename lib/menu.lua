-- BUTTON (internal class)
local Button = class('Button')

-- settings for all buttons
local width = 200
local height = 50
local spacing = 20 -- vertical spacing


-- private methods
local function getBoundingBox(self)
  local x = love.graphics.getWidth() / 2 - width / 2
  local y = 200 + (self.position - 1) * (height + spacing)

  return x,y,width,height
end

local function getFontYOffset(y)
  local font = love.graphics.getFont()
  if font then return y + (height / 2) - (font:getHeight() / 2) end
  return 0
end

local function isInside(self, mx, my)
  local x, y, width, height = getBoundingBox(self)
  return x <= mx and mx <= x+width and y <= my and my <= y+height
end

-- public methods
function Button:initialize(position,label,callback)
  self.position = position
  self.label = label
  self.callback = callback
end

function Button:draw()
  local x, y, width, height = getBoundingBox(self)
  love.graphics.rectangle('line', x, y, width, height)
  love.graphics.printf(self.label, x, getFontYOffset(y), width, 'center')
end

function Button:mousepressed(mx, my, button)
  if button == 'l' and isInside(self, mx, my) then
    self.callback()
  end
end



-- MENU
local Menu = class('Menu')


-- private methods
local function parseButtonOptions(self, buttonOptions)
  local options, label, callback

  for i=1, #buttonOptions do
    options = buttonOptions[i]
    label = options[1]
    callback = options[2]
    table.insert(self.buttons, Button:new(i, label, callback))
  end
end


-- public methods

function Menu:initialize(buttonOptions)
  self.buttons = {}
  parseButtonOptions(self, buttonOptions)
end

function Menu:draw()
  for i=1, #self.buttons do
    self.buttons[i]:draw()
  end
end

function Menu:mousepressed(x,y,button)
  for i=1, #self.buttons do
    self.buttons[i]:mousepressed(x,y,button)
  end
end

return Menu
