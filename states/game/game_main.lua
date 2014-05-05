local Main = Game:addState('Main')

function Main:enteredState()
  Collider = HC(100, self.on_start_collide, self.on_stop_collide)

  local Camera = require("lib/camera")
  self.camera = Camera:new()

  self.default_font = g.newFont("fonts/04b03.TTF", 8)
  g.setFont(self.default_font)

  self.pixels = Grid:new(32, 32)
  for x, y, _ in self.pixels:each() do
    local v = math.floor(love.math.noise(x, y) * 255)
    self.pixels:set(x, y, {
      r = v,
      g = v,
      b = v
    })
  end

  simplex_offset = {
    x = 0, y = 0
  }

  -- cron.every(0.3, function()
  --   simplex_offset.x = simplex_offset.x + 1
  --   simplex_offset.y = simplex_offset.y + 1
  -- end)
end

function Main:update(dt)
  for x, y, pixel in self.pixels:each() do
    local noise = love.math.noise(x + simplex_offset.x, y + simplex_offset.y)
    local red = math.floor(math.sin(noise) * 255)
    local blue = math.floor(math.cos(noise) * 255)
    local green = math.floor(math.tan(noise) * 255)
    pixel.r, pixel.g, pixel.b = find_closest_prefered_colour(red, green, blue)
  end
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

  for x, y, pixel in self.pixels:each() do
    g.setColor(pixel.r, pixel.g, pixel.b)
    g.point(x - 1, y - 1)
  end

  g.setColor(0, 0, 0, 200)
  for x, y, pixel in self.pixels:each(15, 15, 4, 4) do
    if x ~= y and x ~= 32 - y + 1 then
      g.point(x - 1, y - 1)
    end
  end

  -- pixel vignette
  for x, y, _ in self.pixels:each() do
    local dx = math.abs(x / 16.5 - 1)
    local dy = math.abs(y / 16.5 - 1)
    local a = (dx + dy) / 1 * 255
    g.setColor(0, 0, 0, a)
    g.point(x - 1, y - 1)
  end

  g.setColor(4, 174, 204)
  g.print("UP", 0, -1)
  g.print("RI", 24, -1)
  g.print("LE", 0, 26)
  g.print("DN", 23, 26)

  self.camera:unset()
end

function Main:mousepressed(x, y, button)
end

function Main:mousereleased(x, y, button)
end

function Main:move_down()
  simplex_offset.x = simplex_offset.x + 1
  simplex_offset.y = simplex_offset.y + 1
end

function Main:move_left()
  simplex_offset.x = simplex_offset.x - 1
  simplex_offset.y = simplex_offset.y + 1
end

function Main:move_up()
  simplex_offset.x = simplex_offset.x - 1
  simplex_offset.y = simplex_offset.y - 1
end

function Main:move_right()
  simplex_offset.x = simplex_offset.x + 1
  simplex_offset.y = simplex_offset.y - 1
end

function Main:keypressed(key, unicode)
  local action = self["move_" .. key]
  if is_func(action) then action(self) end
end

function Main:keyreleased(key, unicode)
end

function Main:joystickpressed(joystick, button)
end

function Main:joystickreleased(joystick, button)
end

function Main:focus(has_focus)
end

-- shape_one and shape_two are the colliding shapes. mtv_x and mtv_y define the minimum translation vector,
-- i.e. the direction and magnitude shape_one has to be moved so that the collision will be resolved.
-- Note that if one of the shapes is a point shape, the translation vector will be invalid.
function Main.on_start_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  local object_one, object_two = shape_one.parent, shape_two.parent

  if object_one and is_func(object_one.on_collide) then
    object_one:on_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  end

  if object_two and is_func(object_two.on_collide) then
    object_two:on_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  end
end

function Main.on_stop_collide(dt, shape_one, shape_two)
end

function Main:exitedState()
  Collider:clear()
  Collider = nil
end

return Main
