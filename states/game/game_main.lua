local Main = Game:addState('Main')
Game.static.WIDTH = 32
Game.static.HEIGHT = 32

function Main:enteredState()
  love.physics.setMeter(Game.HEIGHT)
  World = love.physics.newWorld(0, 10 * 16, true)
  local physics_callback_names = {"begin_contact", "end_contact", "presolve", "postsolve"}
  local physics_callbacks = {}
  for _,callback_name in ipairs(physics_callback_names) do
    local function callback(fixture_a, fixture_b, contact, ...)
      -- print(callback_name, fixture_a, fixture_b, contact, ...)
      local object_one, object_two = fixture_a:getUserData(), fixture_b:getUserData()
      if object_one and is_func(object_one[callback_name]) then
        object_one[callback_name](object_one, object_two, contact, ...)
      end
      if object_two and is_func(object_two[callback_name]) then
        object_two[callback_name](object_two, object_one, contact, ...)
      end
    end
    self[callback_name] = callback
    table.insert(physics_callbacks, callback)
  end
  World:setCallbacks(unpack(physics_callbacks))

  self.default_font = g.newFont(18)
  g.setFont(self.default_font)

  self.width, self.height = Game.WIDTH, Game.HEIGHT
  self.tile_width, self.tile_height = 16, 16
  self.pixel_width, self.pixel_height = self.width * self.tile_width, self.height * self.tile_height

  self.generator = Generator:new()
  self:new_map(3, 3)
  cron.after(0.001, function()
    self:new_map(3, 3)
  end)

  -- love.window.setMode(self.pixel_width * 3, self.pixel_height * 3)
  love.window.setMode(self.pixel_width, self.pixel_height)
end

function Main:update(dt)
  World:update(dt)

  if self.circle then
    local bx, by = self.circle.body:getWorldCenter()
    local cx, cy = self.camera.x, self.camera.y
    bx, by = bx - g.getWidth() / 2, by - g.getHeight() / 2
    local mag = vector.dist(bx, by, cx, cy)
    local dx, dy = vector.normalize(bx - cx, by - cy)
    dx, dy = dx * mag, dy * mag
    dx, dy = math.clamp(-mag / 10, dx, mag / 10), math.clamp(-mag / 10, dy, mag / 10)
    self.camera:move(dx, dy)
  end
end

function Main:render()
  self.camera:set()

  self.map:render()

  if self.circle then
    self.circle:render()
  end

  self.camera:unset()

  if self.circle == nil then
    g.setColor(COLORS.black:rgb())
    g.print("Click anywhere in the light grey.", 5, 5)
  end

  g.setColor(COLORS.green:rgb())
  g.print(love.timer.getFPS(), 0, 0)
end

function Main:new_map(w, h)
  self.circle = nil
  for _,body in ipairs(World:getBodyList()) do
    body:destroy()
  end
  cron.reset()
  self.map = Map:new({
    width = Game.WIDTH,
    height = Game.HEIGHT
  })
  for x=1,w do
    for y=1,h do
      local section = self.generator:generate(self.width, self.height)
      self.map:add_section(x, y, section)
    end
  end
  self.map:bitmask_sections()
  -- self.camera:setPosition(self.pixel_width, self.pixel_height)
end

function Main:mousepressed(x, y, button)
  x, y = self.camera:mousePosition(x, y)
  if self.circle then
    self.circle:destroy()
  end
  self.circle = Ball:new(x, y, Ball.RADIUS)
end

function Main:mousereleased(x, y, button)
end

function Main:keypressed(key, unicode)
  if key == "r" then
    self:new_map(3, 3)
  end
end

function Main:keyreleased(key, unicode)
end

function Main:joystickpressed(joystick, button)
end

function Main:joystickreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
  Collider:clear()
  Collider = nil
end

return Main
