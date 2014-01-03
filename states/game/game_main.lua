local Main = Game:addState('Main')

function Main:enteredState()
  -- Collider = HC(100, self.on_start_collide, self.on_stop_collide)
  love.physics.setMeter(64)
  World = love.physics.newWorld(0, 0, true)

  -- set up players
  local player = Player:new({
    pressed = {
      [" "] = Player.shoot_ball
    },
    update = {
      up = Player.on_update_up,
      right = Player.on_update_right,
      down = Player.on_update_down,
      left = Player.on_update_left
    }
  }, COLORS.red, {x = g.getWidth() / 4, y = g.getHeight() / 2})
  player:spawn_controlled_object()

  player = Player:new({
    pressed = {
      [" "] = Player.shoot_ball
    },
    update = {
      u = Player.on_update_up,
      r = Player.on_update_right,
      d = Player.on_update_down,
      l = Player.on_update_left
    }
  }, COLORS.purple, {x = g.getWidth() / 4 * 3, y = g.getHeight() / 2}, love.joystick.getJoysticks()[1])
  player:spawn_controlled_object()

  cron.every(5, function()
    for _,player in pairs(Player.instances) do
      player:spawn_controlled_object()
    end
  end)

  -- set up obstacles
  self.blocking_objects = {}
  function new_blocking_object(x, y, w, h)
    local object = {}
    object.body = love.physics.newBody(World, x, y, "static")
    object.shape = love.physics.newRectangleShape(w, h)
    object.fixture = love.physics.newFixture(object.body, object.shape)
    return object
  end
  table.insert(self.blocking_objects, new_blocking_object(g.getWidth() / 4, g.getHeight() / 4, 50, 100))
  table.insert(self.blocking_objects, new_blocking_object(g.getWidth() / 4, g.getHeight() / 4 * 3, 50, 100))
  table.insert(self.blocking_objects, new_blocking_object(g.getWidth() / 4 * 3, g.getHeight() / 4 * 3, 50, 100))
  table.insert(self.blocking_objects, new_blocking_object(g.getWidth() / 4 * 3, g.getHeight() / 4, 50, 100))

  -- set up bounds
  function new_bound(x1, y1, x2, y2)
    local object = {}
    object.body = love.physics.newBody(World, 0, 0, "static")
    object.shape = love.physics.newEdgeShape(x1, y1, x2, y2)
    object.fixture = love.physics.newFixture(object.body, object.shape)
    return object
  end
  new_bound(0, 0, g.getWidth(), 0)
  new_bound(0, 0, 0, g.getHeight())
  new_bound(g.getWidth(), 0, g.getWidth(), g.getHeight())
  new_bound(0, g.getHeight(), g.getWidth(), g.getHeight())

  -- the ball(s)
  self.ball_objects = {}
  function new_ball_object(x, y)
    local object = {}
    object.body = love.physics.newBody(World, x, y, "dynamic")
    object.shape = love.physics.newCircleShape(20)
    object.fixture = love.physics.newFixture(object.body, object.shape)
    return object
  end
  table.insert(self.ball_objects, new_ball_object(g.getWidth() / 2, g.getHeight() / 2))
end

function Main:update(dt)
  for id,player in pairs(Player.instances) do
    player:update(dt)
  end

  local ball_friction = 1 * dt
  for _,ball_object in ipairs(self.ball_objects) do
    local body = ball_object.body
    local vx, vy = body:getLinearVelocity()
    if vx >= ball_friction then vx = vx - ball_friction
    elseif vx <= -ball_friction then vx = vx + ball_friction
    else vx = 0 end
    if vy >= ball_friction then vy = vy - ball_friction
    elseif vy <= -ball_friction then vy = vy + ball_friction
    else vy = 0 end
    body:setLinearVelocity(vx, vy)
  end

  World:update(dt)
end

function Main:render()
  self.camera:set()

  for id,player in pairs(Player.instances) do
    player:render()
  end

  g.setColor(COLORS.blue:rgb())
  for _,blocking_object in ipairs(self.blocking_objects) do
    g.polygon("fill", blocking_object.body:getWorldPoints(blocking_object.shape:getPoints()))
  end

  g.setColor(COLORS.green:rgb())
  for _,ball_object in ipairs(self.ball_objects) do
    local x, y = ball_object.body:getPosition()
    g.circle("fill", x, y, ball_object.shape:getRadius())
  end

  self.camera:unset()
end

function Main:shoot_ball()
  for index,contact in ipairs(World:getContactList()) do
    print(index, contact)
  end
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
  print(joystick, button)
end

function Main:joystickreleased(joystick, button)
  print(joystick, button)
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
  -- Collider:clear()
  -- Collider = nil
end

return Main
