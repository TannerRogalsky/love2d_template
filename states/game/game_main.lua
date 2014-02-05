local Main = Game:addState('Main')
Game.static.WIDTH = 16
Game.static.HEIGHT = 16

function Main:enteredState()
  love.physics.setMeter(Game.HEIGHT)
  World = love.physics.newWorld(0, 10 * Game.HEIGHT, true)
  World:setCallbacks(
    function(a, b, c) self:begin_contact(a, b, c) end,
    function(a, b, c) self:end_contact(a, b, c) end
  )

  self.default_font = g.newFont(12)
  g.setFont(self.default_font)

  self.width, self.height = Game.WIDTH, Game.HEIGHT
  self.tile_width, self.tile_height = 16, 16

  self.generator = Generator:new()

  self.map = Map:new({
    width = Game.WIDTH,
    height = Game.HEIGHT
  })
  for x=1,3 do
    for y=1,3 do
      local section = self.generator:generate(self.width, self.height)
      self.map:add_section(x, y, section)
    end
  end


  love.window.setMode(self.tile_width * self.width * 3, self.tile_height * self.height * 3)
  self:new_bounds()

  self.circles = {}
end

function Main:update(dt)
  World:update(dt)
end

function Main:render()
  self.camera:set()

  self.map:render()

  g.setColor(COLORS.black:rgb())
  for _,circle in ipairs(self.circles) do
    local x, y = circle.body:getWorldCenter()
    g.circle("fill", x, y, 8)
  end

  self.camera:unset()
end

function Main:mousepressed(x, y, button)
  local circle = {}
  circle.body = love.physics.newBody(World, x, y, "dynamic")
  circle.shape = love.physics.newCircleShape(8)
  circle.fixture = love.physics.newFixture(circle.body, circle.shape)
  circle.fixture:setRestitution(0.5)

  table.insert(self.circles, circle)
end

function Main:mousereleased(x, y, button)
end

function Main:keypressed(key, unicode)
  if key == "r" then
    self.circles = {}
    for _,body in ipairs(World:getBodyList()) do
      body:destroy()
    end
    self:new_bounds()
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

function Main:new_bounds()
  local function new_bound(x1, y1, x2, y2)
    local object = {}
    object.body = love.physics.newBody(World, 0, 0, "static")
    object.shape = love.physics.newEdgeShape(x1, y1, x2, y2)
    object.fixture = love.physics.newFixture(object.body, object.shape)

    return object
  end
  local w, h = self.tile_width * self.width, self.tile_height * self.height
  new_bound(0, 0, w, 0)
  new_bound(w, 0, w, h)
  new_bound(w, h, 0, h)
  new_bound(0, h, 0, 0)
end

function Main:begin_contact(fixture_a, fixture_b, contact)
  print("collide")
  local object_one, object_two = fixture_a:getUserData(), fixture_b:getUserData()

  if object_one and is_func(object_one.begin_contact) then
    object_one:begin_contact(object_two, contact)
  end

  if object_two and is_func(object_two.begin_contact) then
    object_two:begin_contact(object_one, contact)
  end
end

function Main:end_contact(fixture_a, fixture_b, contact)
  local object_one, object_two = fixture_a:getUserData(), fixture_b:getUserData()

  if object_one and is_func(object_one.end_contact) then
    object_one:end_contact(object_two, contact)
  end

  if object_two and is_func(object_two.end_contact) then
    object_two:end_contact(object_one, contact)
  end
end

function Main:exitedState()
  Collider:clear()
  Collider = nil
end

return Main
