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
  box(0, 0, g.getWidth(), g.getHeight())

  table.insert(lines, Line.new(100, 150, 120, 50))
  table.insert(lines, Line.new(120, 50, 200, 80))
  table.insert(lines, Line.new(200, 80, 140, 210))
  table.insert(lines, Line.new(140, 210, 100, 150))

  table.insert(lines, Line.new(100, 200, 120, 250))
  table.insert(lines, Line.new(120, 250, 60, 300))
  table.insert(lines, Line.new(60, 300, 100, 200))

  table.insert(lines, Line.new(200, 260, 220, 150))
  table.insert(lines, Line.new(220, 150, 300, 200))
  table.insert(lines, Line.new(300, 200, 350, 320))
  table.insert(lines, Line.new(350, 320, 200, 260))

  table.insert(lines, Line.new(340, 60, 360, 40))
  table.insert(lines, Line.new(360, 40, 370, 70))
  table.insert(lines, Line.new(370, 70, 340, 60))

  table.insert(lines, Line.new(450, 190, 560, 170))
  table.insert(lines, Line.new(560, 170, 540, 270))
  table.insert(lines, Line.new(540, 270, 430, 290))
  table.insert(lines, Line.new(430, 290, 450, 190))

  table.insert(lines, Line.new(400,95, 580,50))
  table.insert(lines, Line.new(580,50, 480,150))
  table.insert(lines, Line.new(480,150, 400,95))

  global_rays = {}
end

function Main:update(dt)
  local mx, my = self.camera:mousePosition()
  local px = g.getWidth() / 2
  local py = g.getHeight() / 2

  local unique_vertices = {}
  local rays = {}
  local function gen_ray(point)
    local key = tostring(point)
    if unique_vertices[key] == nil then
      unique_vertices[key] = point
      local ray = Line.new(mx, my, point.x, point.y)
      table.insert(rays, ray)
      table.insert(rays, ray:rotate(0.001))
      table.insert(rays, ray:rotate(-0.001))
    end
  end
  for _,line in ipairs(lines) do
    gen_ray(line.origin)
    gen_ray(line.destination)
  end

  global_rays = {}
  for _,ray in ipairs(rays) do
    local closest_intersection = nil
    for _,line in ipairs(lines) do
      local intersection = ray:intersects(line)
      if intersection then
        if closest_intersection == nil or intersection < closest_intersection then
          closest_intersection = intersection
        end
      end
    end
    table.insert(global_rays, closest_intersection)
  end

  table.sort(global_rays, function(a, b)
    return a.delta:angleTo() < b.delta:angleTo()
  end)
end

function Main:render()
  self.camera:set()

  g.setColor(COLORS.white:rgb())
  for _,line in ipairs(lines) do
    g.line(line:unpack())
  end

  if #global_rays > 0 then
    g.setColor(COLORS.red:rgb())
    local x1, y1 = self.camera:mousePosition()
    for i = 1, #global_rays - 1 do
      local x2, y2 = global_rays[i].destination:unpack()
      local x3, y3 = global_rays[i + 1].destination:unpack()
      g.polygon("fill", x1, y1, x2, y2, x3, y3)
    end
    g.polygon("fill", x1, y1,
      global_rays[#global_rays].destination.x, global_rays[#global_rays].destination.y,
      global_rays[1].destination.x, global_rays[1].destination.y)
  end

  g.setColor(COLORS.green:rgb())
  g.print(love.timer.getFPS(), 0, 0)

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
