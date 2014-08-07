local Main = Game:addState('Main')
local Vector  = require('lib.vector')

function Main:enteredState()
  Collider = HC(100, self.on_start_collide, self.on_stop_collide)

  local Camera = require("lib/camera")
  self.camera = Camera:new()

  g.setFont(self.preloaded_fonts["04b03_16"])

  self.boids = {}
  for i=1,10 do
    -- table.insert(self.boids, Boid:new(Vector(10 * i + 100, 10 * i + 100)))
    table.insert(self.boids, Boid:new(Vector(math.random(g.getWidth()), math.random(g.getHeight()))))
  end
end

function Main:update(dt)
  for i,boid in ipairs(self.boids) do
    boid:update(dt)
  end
end

function Main:draw()
  self.camera:set()

  for i,boid in ipairs(self.boids) do
    g.circle("fill", boid.position.x, boid.position.y, 5, 10)
  end

  self.camera:unset()
end

function Main:mousepressed(x, y, button)
end

function Main:mousereleased(x, y, button)
end

function Main:keypressed(key, unicode)
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
    object_one:on_collide(dt, object_two, mtv_x, mtv_y)
  end

  if object_two and is_func(object_two.on_collide) then
    object_two:on_collide(dt, object_one, -mtv_x, -mtv_y)
  end
end

function Main.on_stop_collide(dt, shape_one, shape_two)
end

function Main:exitedState()
  Collider:clear()
  Collider = nil
end

return Main
