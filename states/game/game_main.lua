local Main = Game:addState('Main')
Game.static.WIDTH = 32
Game.static.HEIGHT = 32

function Main:enteredState()
  love.physics.setMeter(Game.HEIGHT)
  World = love.physics.newWorld(0, 10 * Game.HEIGHT, true)
  -- World:setCallbacks(
  --   function(a, b, c) self:begin_contact(a, b, c) end,
  --   function(a, b, c) self:end_contact(a, b, c) end
  -- )

  self.default_font = g.newFont(12)
  g.setFont(self.default_font)

  self.width, self.height = Game.WIDTH, Game.HEIGHT
  self.tile_width, self.tile_height = 16, 16

  Generator = require("generator")
  self.generator = Generator:new()
  self.grid = self.generator:generate(self.width, self.height)

  love.window.setMode(self.tile_width * self.width, self.tile_height * self.height)
  self:new_bounds()

  self.circles = {}
end

function Main:update(dt)
  World:update(dt)
end

function Main:render()
  self.camera:set()

  g.setColor(COLORS.background_grey:rgb())
  local w, h = self.tile_width, self.tile_height
  g.rectangle("fill", 0, 0, self.grid.width * w, self.grid.height * h)
  for x, y, tile in self.grid:each() do
    tile:render(w, h)
  end
  -- for _,body in ipairs(World:getBodyList()) do
  --   for _,fixture in ipairs(body:getFixtureList()) do
  --     local shape = fixture:getShape()
  --     if shape.getPoints then
  --       g.setColor(COLORS.white:rgb())
  --       g.polygon("fill", body:getWorldPoints(shape:getPoints()))
  --     end
  --   end
  -- end

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
    self.grid = self.generator:generate(self.width, self.height)
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
