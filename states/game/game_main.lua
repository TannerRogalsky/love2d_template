local Main = Game:addState('Main')

local function colorNumToTable(num)
  return {
    bit.band(bit.rshift(num, 16), 255),
    bit.band(bit.rshift(num, 8), 255),
    bit.band(num, 255)
  }
end

local function hue2rgb(p, q, t)
  if t < 0 then t = t + 1 end
  if t > 1 then t = t - 1 end
  if t < 1/6 then return p + (q - p) * 6 * t end
  if t < 1/2 then return q end
  if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
  return p
end

local function hsl2rgb(h, s, l)
  local r,g,b

  if s == 0 then
    r,g,b = l,l,l -- achromatic
  else
    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    r = hue2rgb(p, q, h + 1/3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1/3)
  end

  return r * 255, g * 255, b * 255
end

local function inQuint(t, b, c, d) return c * math.pow(t / d, 5) + b end

local SIZE = 20

function Main:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  local num_blocks = 4
  blocks = {
    {0xff0000, 0x00ff00, 0x0000ff},
  }
  for y=1,num_blocks - 1 do
    local colors = {}
    local prev_row = blocks[y]

    for x=1,#prev_row do
      local prev_color_1 = prev_row[x]
      local prev_color_2 = prev_row[x + 1]
      if prev_color_2 == nil then prev_color_2 = prev_row[1] end

      table.insert(colors, prev_color_1)
      -- table.insert(colors, bit.bor(prev_color_1, prev_color_2))
      table.insert(colors, (prev_color_1 + prev_color_2) / 2)
    end

    table.insert(blocks, colors)
  end

  -- for b=1,5 do
  --   for i=1,5 do
  --     print(i, b, (i + b) % 5)
  --   end
  --   print('')
  -- end

  -- mesh = g.newMesh({
  --   {-SIZE / 2, -SIZE / 2},
  --   {-SIZE / 2, SIZE / 2},
  --   {SIZE / 2, SIZE / 2},
  --   {SIZE / 2, -SIZE / 2},
  -- })
  mesh = g.newMesh({
    {0, -SIZE / 2},
    {SIZE / 2, SIZE / 2},
    {-SIZE / 2, SIZE / 2}
  })

  -- for i,row in ipairs(blocks) do
  --   local t = {}
  --   for i,block in ipairs(row) do
  --     table.insert(t, bit.tohex(block))
  --   end
  --   print(unpack(t))
  -- end

  g.setFont(self.preloaded_fonts["04b03_16"])
  self.camera:move(-g.getWidth() / 2, -g.getHeight() / 2)
end

function Main:update(dt)
  g.setWireframe(love.keyboard.isDown('space'))
end

function Main:draw()
  self.camera:set()

  -- do
  --   local size = 20
  --   local padding_x, padding_y = 5, 10
  --   local y = 0
  --   g.setColor(255, 255, 255)
  --   for i=3,num_blocks do
  --     local half_width = i / 2
  --     for x=1,i do
  --       local px = (x - 1 - half_width) * (size + padding_x) + g.getWidth() / 2
  --       local py = y * (size + padding_y) + 100
  --       g.rectangle('fill', px, py, size, size)
  --     end
  --     y = y + 1
  --   end
  -- end

  do
    local tau = math.pi * 2
    local time = love.timer.getTime()
    for y,row in ipairs(blocks) do
      time = time * -1
      local t = tau / #row
      local radius = SIZE * y
      for x,block in ipairs(row) do
        local px = (radius + math.cos(x * t) * 10 + (math.cos(math.abs(time)) + math.pi) * 10) * math.cos((x - 1) * t + time)
        local py = (radius + math.sin(x * t) * 10 + (math.sin(math.abs(time)) + math.pi) * 10) * math.sin((x - 1) * t + time)
        local angle = math.atan2(px, -py)
        g.setColor(hsl2rgb(angle / tau, 1, y / #blocks - (math.sin(math.abs(time)) + math.pi) / tau))
        g.draw(mesh, px, py, angle)
      end
    end
  end

  do
    g.push()
    g.translate(g.getWidth() / 4, 0)
    local tau = math.pi * 2
    local golden_mean = (1 + math.sqrt(5) / 2)
    local time = love.timer.getTime()
    local num = 75
    local arms = 2
    local radius = 150
    local time_scale = 10
    local cycle = ((time * time_scale) % -num) * -1 -- 0 through `num` exclusive

    for i=1,num do
      local n = (i + cycle) % num
      local angle = (n + time * time_scale) * golden_mean * math.pi / arms - time * 2
      local ratio = n / num * radius

      local x = math.cos(angle) * ratio
      local y = math.sin(angle) * ratio

      g.setColor(hsl2rgb(i / num, 1, 0.5 - inQuint(ratio, 0, 0.5, radius)))
      -- g.setColor(hsl2rgb((angle % tau) / tau, 1, 0.5 - inQuint(ratio, 0, 0.5, radius)))
      -- g.setColor(hsl2rgb(ratio / radius, 1, 0.5 - inQuint(ratio, 0, 0.5, radius)))
      g.draw(mesh, x, y,  math.atan2(-x, y), 1)
    end

    g.pop()
  end

  do
    g.push()
    g.translate(-g.getWidth() / 4, 0)
    local time = love.timer.getTime()
    local tau = math.pi * 2
    local golden_mean = (1 + math.sqrt(5) / 2)
    local num = 50

    for i=1,num do
      local angle = i * golden_mean * math.pi + time
      local ratio = i * 3
      local x = math.cos(angle) * ratio
      local y = math.sin(angle) * ratio
      local red, green, blue = hsl2rgb(i / num, 1, 0.5)

      g.setColor(red, green, blue, (1 - inQuint(i, 0, 1, num)) * 255)
      g.draw(mesh, x, y, angle + math.pi)
    end
    g.pop()
  end

  -- do
  --   local num_lines = 6
  --   g.setColor(255, 255, 255)
  --   for i=1,num_lines do
  --     local t = (2 * math.pi) / num_lines
  --     g.line(0, 0, math.cos(i * t) * 1000, math.sin(i * t) * 1000)
  --   end
  -- end

  -- do
  --   local y = 0
  --   g.setColor(100, 100, 100)
  --   for i=3,num_blocks - 1 do
  --     local half_width = i / 2
  --     for x=1,i do
  --       local px = (x - 1 - half_width) * (size + padding_x) + g.getWidth() / 2
  --       local py = y * (size + padding_y) + 100
  --       local lx, ly = px + size / 2, py + size / 2
  --       g.line(lx, ly, lx - ((size) / 2), ly + (size * 0.8) + padding_y)
  --       g.line(lx, ly, lx + ((size) / 2), ly + (size * 0.8) + padding_y)
  --     end
  --     y = y + 1
  --   end
  -- end

  self.camera:unset()
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
end

function Main:keypressed(key, scancode, isrepeat)
end

function Main:keyreleased(key, scancode)
end

function Main:gamepadpressed(joystick, button)
end

function Main:gamepadreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
  self.camera = nil
end

return Main
