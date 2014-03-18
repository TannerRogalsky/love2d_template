local Main = Game:addState('Main')

function Main:enteredState()
  Collider = HC(100, self.on_start_collide, self.on_stop_collide)

  lines = {}
  local function box(x, y, w, h)
    table.insert(lines, {
      x1 = x, y1 = y,
      x2 = x + w, y2 = y
    })
    table.insert(lines, {
      x1 = x + w, y1 = y,
      x2 = x + w, y2 = y + h
    })
    table.insert(lines, {
      x1 = x + w, y1 = y + h,
      x2 = x, y2 = y + h
    })
    table.insert(lines, {
      x1 = x, y1 = y + h,
      x2 = x, y2 = y
    })
  end

  -- table.insert(lines, {
  --   x1 = 2, y1 = 1,
  --   x2 = 36, y2 = 2,
  -- })

  box(100, 100, 100, 100)
  box(300, 100, 100, 100)
  box(300, 300, 100, 100)
  box(100, 300, 100, 100)
  box(0, 0, g.getWidth(), g.getHeight())
end

function Main:get_intersection(ray, segment)
  -- RAY in parametric: Point + Direction*T1
  local r_px = ray.x1
  local r_py = ray.y1
  local r_dx = ray.x2 - ray.x1
  local r_dy = ray.y2 - ray.y1

  -- SEGMENT in parametric: Point + Direction*T2
  local s_px = segment.x1
  local s_py = segment.y1
  local s_dx = segment.x2 - segment.x1
  local s_dy = segment.y2 - segment.y1

  -- Are they parallel? If so, no intersect
  local r_mag = math.sqrt(r_dx*r_dx+r_dy*r_dy)
  local s_mag = math.sqrt(s_dx*s_dx+s_dy*s_dy)
  if r_dx/r_mag==s_dx/s_mag and r_dy/r_mag==s_dy/s_mag then -- Directions are the same.
    return nil
  end

  -- SOLVE FOR T1 & T2
  -- r_px+r_dx*T1 = s_px+s_dx*T2 && r_py+r_dy*T1 = s_py+s_dy*T2
  -- ==> T1 = (s_px+s_dx*T2-r_px)/r_dx = (s_py+s_dy*T2-r_py)/r_dy
  -- ==> s_px*r_dy + s_dx*T2*r_dy - r_px*r_dy = s_py*r_dx + s_dy*T2*r_dx - r_py*r_dx
  -- ==> T2 = (r_dx*(s_py-r_py) + r_dy*(r_px-s_px))/(s_dx*r_dy - s_dy*r_dx)
  local T2 = (r_dx*(s_py-r_py) + r_dy*(r_px-s_px))/(s_dx*r_dy - s_dy*r_dx)
  local T1 = (s_px+s_dx*T2-r_px)/r_dx

  if T1<0 then return nil end
  if T2<0 or T2>1 then return nil end

  -- Return the POINT OF INTERSECTION
  return {
    x = r_px+r_dx*T1,
    y = r_py+r_dy*T1,
    param = T1
  }
end

function Main:update(dt)
  local mx, my = self.camera:mousePosition()
  local px = g.getWidth() / 2
  local py = g.getHeight() / 2

  local ray = {
    x1 = px, y1 = py,
    x2 = mx, y2 = my,
  }

  local closest_intersection = nil
  for _,line in ipairs(lines) do
    local intersection = self:get_intersection(ray, line)
    if intersection then
      if closest_intersection == nil or intersection.param < closest_intersection.param then
        closest_intersection = intersection
      end
    end
  end

  global_ray = {px, py, closest_intersection.x, closest_intersection.y}
end

function Main:render()
  self.camera:set()

  g.setColor(COLORS.white:rgb())
  for _,line in ipairs(lines) do
    g.line(line.x1, line.y1, line.x2, line.y2)
  end

  if global_ray then
    local r = global_ray
    g.setColor(COLORS.red:rgb())
    g.line(unpack(r))
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
