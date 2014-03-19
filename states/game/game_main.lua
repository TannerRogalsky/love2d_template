local Main = Game:addState('Main')

function Main:enteredState()
  Collider = HC(100, self.on_start_collide, self.on_stop_collide)

  lines = {}
  local function box(x, y, w, h)
    table.insert(lines, Line.new(x, y, x + w, y))
    table.insert(lines, Line.new(x + w, y, x + w, y + h))
    table.insert(lines, Line.new(x + w, y + h, x, y + h))
    table.insert(lines, Line.new(x, y + h, x, y))
  end

  box(100, 100, 100, 100)
  box(300, 100, 100, 100)
  box(300, 300, 100, 100)
  box(100, 300, 100, 100)
  box(0, 0, g.getWidth(), g.getHeight())
end

function Main:update(dt)
  local mx, my = self.camera:mousePosition()
  local px = g.getWidth() / 2
  local py = g.getHeight() / 2

  local ray = Line.new(px, py, mx, my)

  local closest_intersection = nil
  for _,line in ipairs(lines) do
    local intersection = ray:intersects(line)
    if intersection then
      if closest_intersection == nil or intersection < closest_intersection then
        closest_intersection = intersection
      end
    end
  end

  global_ray = closest_intersection
end

function Main:render()
  self.camera:set()

  g.setColor(COLORS.white:rgb())
  for _,line in ipairs(lines) do
    g.line(line:unpack())
  end

  if global_ray then
    g.setColor(COLORS.red:rgb())
    g.line(global_ray:unpack())
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
