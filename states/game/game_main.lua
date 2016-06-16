local Main = Game:addState('Main')

local function colorNumToTable(num)
  return {
    bit.band(bit.rshift(num, 16), 255),
    bit.band(bit.rshift(num, 8), 255),
    bit.band(num, 255)
  }
end

local function inQuad(t, b, c, d) return c * math.pow(t / d, 2) + b end
local function inQuint(t, b, c, d) return c * math.pow(t / d, 5) + b end

local SIZE = 20

function Main:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  mesh = g.newMesh({
    {0, -SIZE / 2},
    {SIZE / 2, SIZE / 2},
    {-SIZE / 2, SIZE / 2}
  })

  g.setFont(self.preloaded_fonts["04b03_16"])
  self.camera:move(-g.getWidth() / 2, -g.getHeight() / 2)
end

function Main:update(dt)
  g.setWireframe(love.keyboard.isDown('space'))
end

function Main:draw()
  self.camera:set()

  do
    local tau = math.pi * 2
    local time = love.timer.getTime()
    local abs_t = time
    local rows = 4

    for y=1, rows do
      time = time * -1
      local columns = (y + 1) ^ 2
      local t = tau / columns
      local radius = SIZE * y
      for x=1,columns do
        local px = (radius + math.cos(x * t) * 20 + (math.cos(abs_t) + math.pi) * 10) * math.cos((x - 1) * t + time)
        local py = (radius + math.sin(x * t) * 20 + (math.sin(abs_t) + math.pi) * 10) * math.sin((x - 1) * t + time)
        local angle = math.atan2(px, -py)
        g.setColor(hsl2rgb(angle / tau, 1, y / rows - (math.sin(abs_t) + math.pi) / tau))
        -- g.setColor(hsl2rgb(angle / tau, 1, y / rows / 2 - math.sin(abs_t) * (rows - y) / rows / 2))
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
      local angle = (n + time * time_scale) * golden_mean * math.pi / arms - time * 1.9
      local ratio = n / num * radius

      local x = math.cos(angle) * ratio
      local y = math.sin(angle) * ratio

      g.setColor(hsl2rgb(i / num, 1, 0.5 - inQuint(ratio, 0, 0.5, radius)))
      -- g.setColor(hsl2rgb((angle % tau) / tau, 1, 0.5 - inQuint(ratio, 0, 0.5, radius)))
      -- g.setColor(hsl2rgb(ratio / radius, 1, 0.5 - inQuint(ratio, 0, 0.5, radius)))
      g.draw(mesh, x, y,  0, 1)
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

  do
    g.push()
    local time = love.timer.getTime()
    local tau = math.pi * 2
    local golden_mean = (1 + math.sqrt(5) / 2)
    local arms = 2
    local num = 50
    local radius = 125
    local time_scale = 10
    local cycle = ((time * time_scale) % -num) * -1 -- 0 through `num` exclusive

    g.translate(-g.getWidth() / 8, g.getHeight() / 2 - radius - SIZE / 2)

    for i=1,num do
      local n = (i + cycle) % num
      local arm_index = (i % arms)
      local angle = (n + time * time_scale) * golden_mean * math.pi / arms + arm_index * math.pi / 2
      local ratio = n / num * radius
      local x = math.cos(angle) * ratio
      local y = math.sin(angle) * ratio
      local red, green, blue = hsl2rgb(i / num, 1, 0.5)

      g.setColor(red, green, blue, inQuint(ratio, 0, 1, radius) * 255)
      g.draw(mesh, x, y, angle + math.pi)
    end
    g.pop()
  end

  do
    g.push()
    local radius = 125
    g.translate(g.getWidth() / 8, g.getHeight() / 2 - radius - SIZE / 2)

    local tau = math.pi * 2
    local num_rows = 5
    local time = love.timer.getTime()

    for row=1,num_rows do
      local n = row * 3
      local t = math.pi * 2 / n
      for i=1,n do
        local d = radius / num_rows
        local phi = i * t - math.pi / 2 + time
        local x = d * (row - 0.5) * math.cos(phi)
        local y = d * (row - 0.5) * math.sin(phi) * math.cos(phi)

        g.setColor(hsl2rgb(i / n, 1, 0.5))
        g.draw(mesh, x, y, math.atan2(y, x) + phi)
      end
    end

    g.pop()
  end

  do
    g.push()
    local radius = 125
    local time = love.timer.getTime()
    g.translate(g.getWidth() / 8, -g.getHeight() / 2 + radius + SIZE / 2)

    local tau = math.pi * 2
    local num_rows = 5

    for row=1,num_rows do
      local n = row * 3
      local t = math.pi * 2 / n
      for i=1,n do
        local d = radius / num_rows
        local phi = i * t - math.pi / 2 + time
        local x = d * (row - 0.5) * math.sin(phi)
        local y = d * (row - 0.5) * math.cos(phi) ^ 3

        local s = math.sin(time)
        local c = math.cos(time)
        local x, y = c * x - s * y, s * x + c * y

        g.setColor(hsl2rgb(i / n, 1, 0.5))
        g.draw(mesh, x, y, math.atan2(y, x) + phi)
      end
    end

    g.pop()
  end

  do
    g.push()
    local radius = 125
    local time = love.timer.getTime()
    g.translate(-g.getWidth() / 8, -g.getHeight() / 2 + radius + SIZE / 2)

    local tau = math.pi * 2
    local num_rows = 5

    for row=1,num_rows do
      local n = row * 3
      local t = math.pi * 2 / n
      for i=1,n do
        local d = radius / num_rows
        local phi = i * t - math.pi / 2 + time
        local x = d * (row - 0.5) * math.sin(phi)
        local y = d * (row - 0.5) * math.cos(phi)

        local s = math.sin(time)
        local c = math.cos(time)
        local x, y = c * x - s * y, s * x + c * y

        local r = math.atan2(y, x) + time
        g.setColor(hsl2rgb((r * math.pi) % tau / tau, 1, 0.5))
        g.draw(mesh, x, y, r)
      end
    end

    g.pop()
  end

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
