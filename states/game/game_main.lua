local Main = Game:addState('Main')
local frag_code = love.filesystem.read('shaders/test.c')

function Main:enteredState()
  love.math.setRandomSeed(1)

  local Camera = require("lib/camera")
  self.camera = Camera:new()

  self.default_font = g.newFont("fonts/04b03.TTF", 8)
  g.setFont(self.default_font)

  self.pixels = Grid:new(1024, 1024)
  for x, y, _ in self.pixels:each() do
    local red, green, blue = self:generate_color(x, y)
    self.pixels:set(x, y, {
      r = red,
      g = green,
      b = blue
    })
  end

  self.joystick = love.joystick.getJoysticks()[1]
  self.ui_off = false

  -- simplex_offset = {
  --   x = game_data.MapX + 1, y = game_data.MapY
  -- }
  -- simplex_offset = {x = 0, y = 0}
  simplex_offset = {
    x = math.floor(self.pixels.width / 2), y = math.floor(self.pixels.height / 2)
  }

  self.vignette = g.newCanvas(32, 32)
  g.setCanvas(self.vignette)
  for x, y, _ in self.pixels:each(1, 1, 32, 32) do
    local dx = math.abs(x / 16.5 - 1)
    local dy = math.abs(y / 16.5 - 1)
    local a = (dx + dy)  / 3 * 255
    g.setColor(0, 0, 0, a)
    g.point(x - 1, y - 1)
  end
  g.setCanvas()

  for i=1,10000 do
    self:make_thing(love.math.random(1, self.pixels.width - 1), love.math.random(1, self.pixels.height - 1))
  end

  self.test_shader = g.newShader(frag_code)

  self.movement_cron = cron.every(0.1, function()
    local dx = math.round(self.joystick_x)
    local dy = math.round(self.joystick_y)
    self:move(dx, dy)
  end)
end

function Main:update(dt)
  self.joystick_x, self.joystick_y = self.joystick:getAxes()
  self.movement_cron:update(dt)

  dt = dt * (self.speed_multiplier or 1)

  for id,thing in pairs(Thing.instances) do
    thing:update(dt)
  end
end

function Main:generate_empty_pixels()
  for x = simplex_offset.x, simplex_offset.x + 32 do
    for y = simplex_offset.y, simplex_offset.y + 32 do
      local pixel = self.pixels:get(x, y)
      if pixel == nil then
        local red, green, blue = self:generate_color(x, y)
        pixel = {
          r = red,
          g = green,
          b = blue
        }
        self.pixels:set(x, y, pixel)
      end
    end
  end
end

function Main:generate_color(x, y)
  local noise = love.math.noise(x, y)
  local red = math.floor(math.sin(noise) * 255)
  local blue = math.floor(math.cos(noise) * 255)
  local green = math.floor(math.tan(noise) * 255)
  return find_closest_prefered_colour(red, green, blue)
end

local prefered_colors = {
  {148, 146, 76},
  {73,  84,  65},
  {4, 174, 204},
  {148, 74,  28},
  {60,  136, 68},
  {252, 254, 252},
  {95,  57,  31},
  {108, 250, 220},
  {144, 144, 152},
  {50,  45,  35},
  {28,  62,  68},
  {220, 198, 124},
  {28,  70,  36},
  {164, 218, 196},
  {4, 92,  156},
}
function find_closest_prefered_colour(r, g, b)
  local closest_colour, delta = prefered_colors[1], math.huge

  for i,color in ipairs(prefered_colors) do
    local d = 0
    d = d + math.abs(r - color[1])
    d = d + math.abs(g - color[2])
    d = d + math.abs(b - color[3])
    if d < delta then
      delta = d
      closest_colour = color
    end
  end

  return unpack(closest_colour)
end

function Main:draw()
  self.camera:set()

  for x, y, pixel in self.pixels:each(simplex_offset.x, simplex_offset.y, 32, 32) do
    if x % 32 == 0 or y % 32 == 0 then
      g.setColor({255, 255, 255})
    else
      g.setColor(pixel.r, pixel.g, pixel.b)
    end

    g.point(x - simplex_offset.x, y - simplex_offset.y)
  end

  if self.ui_off == false then
    for id,thing in pairs(Thing.instances) do
      g.setColor(thing.r, thing.g, thing.b)
      g.rectangle("fill", thing.x - simplex_offset.x, thing.y - simplex_offset.y, 2, 2)
    end

    g.setColor(0, 0, 0, 200)
    for x, y, pixel in self.pixels:each(simplex_offset.x + 14, simplex_offset.y + 14, 4, 4) do
      x = x - simplex_offset.x
      y = y - simplex_offset.y
      if x ~= y and x ~= 30 - y + 1 then
        g.point(x, y)
      end
    end

    -- pixel vignette
    g.setColor(COLORS.white:rgb())
    g.draw(self.vignette, 0, 0)

    -- g.setColor(4, 174, 204)
    -- g.print("UP", 0, -1)
    -- g.print("RI", 24, -1)
    -- g.print("LE", 0, 26)
    -- g.print("DN", 23, 26)
    -- g.print(love.timer.getFPS(), 0, -1)
  end

  self.camera:unset()
end

function Main:mousepressed(x, y, button)
end

function Main:mousereleased(x, y, button)
end

function Main:move_down()
  self:move(0, 1)
end

function Main:move_left()
  self:move(-1, 0)
end

function Main:move_up()
  self:move(0, -1)
end

function Main:move_right()
  self:move(1, 0)
end

function Main:move(dx, dy)
  simplex_offset.x = simplex_offset.x + dx
  simplex_offset.y = simplex_offset.y + dy

  if self.paint_colors then
    local index = 1
    for x, y, pixel in self.pixels:each(simplex_offset.x + 15, simplex_offset.y + 15, 2, 2) do
      local color = self.paint_colors[index]
      pixel.r, pixel.g, pixel.b = unpack(color)
      index = index + 1
    end
  end
end

function Main:make_thing(x, y)
  local thing = Thing:new(x, y, self.pixels)
end

function Main:smooth_pixels()
  local colors = {}
  for x, y, pixel in self.pixels:each(simplex_offset.x + 15, simplex_offset.y + 15, 2, 2) do
    for _, color in ipairs(prefered_colors) do
      local r, g, b = unpack(color)
      if r == pixel.r and g == pixel.g and b == pixel.b then
        colors[color] = colors[color] or 0
        colors[color] = colors[color] + 1
        break
      end
    end
  end

  local smoothing_color = nil
  local highest = 0
  for color,num in pairs(colors) do
    if num > highest then
      highest = num
      smoothing_color = color
    end
  end

  if highest >= 3 then
    local r, g, b = unpack(smoothing_color)
    for x, y, pixel in self.pixels:each(simplex_offset.x + 15, simplex_offset.y + 15, 2, 2) do
      pixel.r = r
      pixel.g = g
      pixel.b = b
    end
  end
end

function Main:begin_paint()
  self.paint_colors = {}
  for x, y, pixel in self.pixels:each(simplex_offset.x + 15, simplex_offset.y + 15, 2, 2) do
    table.insert(self.paint_colors, {pixel.r, pixel.g, pixel.b})
  end
end

function Main:end_paint()
  self.paint_colors = nil
end

function Main:restart()
  g.clear()
  self:gotoState('Main')
end

function Main:speed_up()
  self.speed_multiplier = 10
end

function Main:slow_down()
  self.speed_multiplier = 1
end

function Main:turn_off_ui()
  self.ui_off = true
end

function Main:turn_on_ui()
  self.ui_off = false
end

local commands = {
  keyboard = {
    down = Main.move_down,
    left = Main.move_left,
    up = Main.move_up,
    right = Main.move_right,
    [' '] = Main.speed_up,
    a = Main.smooth_pixels,
    s = Main.begin_paint,
    q = Main.restart,
  },
  keyboard_released = {
    s = Main.end_paint,
    [' '] = Main.slow_down
  },
  gamepadpressed = {
    a = Main.begin_paint,
    b = Main.speed_up,
    back = Main.restart,
    start = Main.restart,
    rightshoulder = Main.turn_off_ui
  },
  gamepadreleased = {
    a = Main.end_paint,
    b = Main.slow_down,
    rightshoulder = Main.turn_on_ui
  }
}

function Main:keypressed(key, unicode)
  local action = commands.keyboard[key]
  if is_func(action) then action(self) end
end

function Main:keyreleased(key, unicode)
  local action = commands.keyboard_released[key]
  if is_func(action) then action(self) end
end

function Main:gamepadpressed(joystick, button)
  local action = commands.gamepadpressed[button]
  if is_func(action) then action(self) end
end

function Main:gamepadreleased(joystick, button)
  local action = commands.gamepadreleased[button]
  if is_func(action) then action(self) end
end

function Main:joystickpressed(joystick, button)
end

function Main:joystickreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
end

return Main
