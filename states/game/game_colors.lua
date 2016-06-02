local Colors = Game:addState('Colors')

local function sum(values)
  local result = 0
  for i,v in ipairs(values) do
    result = result + v
  end
  return result
end

local function circAve2(values)
  local total = sum(values)
  local r1, r2 = total / #values, ((total + 1) / #values) % 1
  return total, r1, r2
  -- if math.min(math.abs(a1-r1), math.abs(a0-r1)) < math.min(math.abs(a0-r2), math.abs(a1-r2)) then
  --   return r1
  -- else
  --   return r2
  -- end
end

local function circAve(a0, a1)
  local r1, r2 = (a0 + a1) / 2, ((a0 + a1 + 1) / 2) % 1
  if math.min(math.abs(a1-r1), math.abs(a0-r1)) < math.min(math.abs(a0-r2), math.abs(a1-r2)) then
    return r1
  else
    return r2
  end
end

local SIZE = 80

colors = {}

function Colors:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  print(circAve(2/3, 3/3))
  print(circAve(1/3, 3/3))

  self.camera:move(-g.getWidth() / 2, -g.getHeight() / 2)
  g.setBackgroundColor(150, 150, 150)
end

function Colors:update(dt)
  g.setWireframe(love.keyboard.isDown('space'))
end

function Colors:draw()
  self.camera:set()

  if #colors >= 1 then
    local color = colors[1]
    for i=2,#colors do
      color = circAve(color, colors[i])
    end

    g.setColor(hsl2rgb(color, 1, 0.5))
  else
    g.setColor(255, 255, 255)
  end
  g.circle('fill', 0, 0, SIZE)

  g.setColor(0, 0, 0)
  g.print(#colors, 0, 0)

  for i=1,3 do
    g.setColor(hsl2rgb(i / 3, 1, 0.5))
    g.circle('fill', (i - 2) * SIZE * 1.5, SIZE * 2, SIZE / 2)
  end

  self.camera:unset()
end

function Colors:mousepressed(x, y, button, isTouch)
end

function Colors:mousereleased(x, y, button, isTouch)
  x, y = self.camera:mousePosition()

  for i=1,3 do
    local center_x = (i - 2) * SIZE * 1.5
    local center_y = SIZE * 2
    local clicked = (x - center_x)^2 + (y - center_y)^2 < (SIZE / 2)^2
    if clicked then
      table.insert(colors, i / 3)
    end
  end
end

function Colors:keypressed(key, scancode, isrepeat)
  if key == 'r' then colors = {} end
end

function Colors:keyreleased(key, scancode)
end

function Colors:gamepadpressed(joystick, button)
end

function Colors:gamepadreleased(joystick, button)
end

function Colors:focus(has_focus)
end

function Colors:exitedState()
  self.camera = nil
end

return Colors
