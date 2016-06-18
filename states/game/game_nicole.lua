local Nicole = Game:addState('Nicole')

local ffi = require("ffi")

function Nicole:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  text = {'H','A','P','P','Y',' ','B','I','R','T','H','D','A','Y',' ','N','I','C','O','L','E','!'}

  -- g.setBackgroundColor(150, 150, 150)
  -- g.setFont(self.preloaded_fonts["04b03_96"])
  font = g.setNewFont('fonts/04b03.TTF', 96)
  -- local f = g.setNewFont('fonts/BlackLarch.ttf', 96)
  self.camera:move(
    (g.getWidth() - font:getWidth(table.concat(text, ''))) / 2 * -1,
    -g.getHeight() / 2 + font:getHeight() / 2
  )
end

function Nicole:update(dt)
  g.setWireframe(love.keyboard.isDown('space'))

  local points = self.points
  local velocities = self.velocities
  local random = love.math.random
  if points then
    point_timer = point_timer + dt
    for i,point in ipairs(points) do
      local v = velocities[i]
      v[2] = v[2] + random()

      point[1] = point[1] + v[1]
      point[2] = point[2] + v[2]
    end
  end
end

function Nicole:draw()
  self.camera:set()

  if self.points then
    g.push()
    g.origin()
    g.setColor(255, 255, 255)
    g.points(self.points)
    g.pop()
  else
    local previous_text = '';
    for i,letter in ipairs(text) do
      g.setColor(hsl2rgb(i / #text, 1, 0.7))
      g.print(letter, font:getWidth(previous_text), 0)
      previous_text = previous_text .. letter
    end
  end

  self.camera:unset()
end

function Nicole:mousepressed(x, y, button, isTouch)
end

function Nicole:mousereleased(x, y, button, isTouch)
end

function Nicole:keypressed(key, scancode, isrepeat)
  if key == 'p' then
    local screen = g.newScreenshot()
    local string_data = screen:getString()
    local data = ffi.cast("unsigned char*", string_data)

    local white_pixel_count = 0
    local w, h = g.getWidth(), g.getHeight()
    local floor = math.floor
    local points = {}
    local velocities = {}
    local random = love.math.random
    local ci = 0
    for i=0,w * h do
      ci = i * 4
      if data[ci] ~= 0 then
        local x = i % w
        local y = floor(i / w)
        table.insert(points, {
          x, y,
          data[ci], data[ci + 1], data[ci + 2], data[ci + 3]
        })
        table.insert(velocities, {
          random(10) - 5, random(-50, -20)
        })
        white_pixel_count = white_pixel_count + 1
      end
    end

    self.points = points
    self.velocities = velocities
    point_timer = 0
  end
end

function Nicole:keyreleased(key, scancode)
end

function Nicole:gamepadpressed(joystick, button)
end

function Nicole:gamepadreleased(joystick, button)
end

function Nicole:focus(has_focus)
end

function Nicole:exitedState()
  self.camera = nil
end

return Nicole
