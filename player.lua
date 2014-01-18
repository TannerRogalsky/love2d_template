Player = class('Player', Base):include(Stateful)
Player.static.instances = {}

function Player:initialize(control_map, color, spawn_point, joystick)
  Base.initialize(self)

  self.color = color
  self.spawn_point = spawn_point

  self.joystick = joystick
  self.control_map = control_map
  self.controlled_objects = {}

  Player.instances[self.id] = self
end

function Player:spawn_controlled_object(x, y)
  x, y = x or self.spawn_point.x, y or self.spawn_point.y
  local controlled_object = ControlledObject:new(x, y)
  self.controlled_objects[controlled_object.id] = controlled_object
  return controlled_object
end

function Player:update(dt)
  local velocity = {x = 0, y = 0}
  -- keyboard
  for key,action in pairs(self.control_map.update) do
    if love.keyboard.isDown(key) then
      action(self, dt, velocity)
    end
  end
  -- joystick stick
  if self.joystick then
    local x, y = self.joystick:getAxis(1), self.joystick:getAxis(2)
    velocity.x, velocity.y = velocity.x + x * 150, velocity.y + y * 150

    -- joystick hat
    local hat_action = self.joystick:getHat(1)
    for i=1,#hat_action do
      local action = self.control_map.update[hat_action:sub(i, i)]
      if is_func(action) then action(self, velocity) end
    end
  end
  -- set velocity of controlled balls
  -- for id, control_object in pairs(self.controlled_objects) do
  --   local body = control_object.body
  --   local vx, vy = body:getLinearVelocity()
  --   body:setLinearVelocity(velocity.x, velocity.y)
  -- end
  for _,controlled_object in pairs(self.controlled_objects) do
    controlled_object:update(dt)
  end
end

function Player:render()
  for id, control_object in pairs(self.controlled_objects) do
    local x, y = control_object.body:getPosition()
    g.setColor(self.color:rgb())
    g.circle("fill", x, y, control_object.shape:getRadius())
    g.setColor(COLORS.black:rgb())
    g.circle("line", x, y, control_object.shape:getRadius())
  end
end

function Player:mousepressed(x, y, button)
end

function Player:mousereleased(x, y, button)
end

function Player:keypressed(key, unicode)
  local action = self.control_map.pressed[key]
  if is_func(action) then action(self) end
end

function Player:keyreleased(key, unicode)
end

function Player:joystickpressed(button)
  print("pressed", self, button)
  local action = self.control_map.pressed[button]
  if is_func(action) then action(self) end
end

function Player:joystickreleased(button)
  -- print("released", self, button)
end

local velocity = 150
local force = 10000
function Player:on_update_up(dt, vel)
  -- vel.x, vel.y = vel.x + 0, vel.y - velocity
  self:apply_force_to_controlled_ojbects(dt, 0, -force)
end
function Player:on_update_right(dt, vel)
  -- vel.x, vel.y = vel.x + velocity, vel.y + 0
  self:apply_force_to_controlled_ojbects(dt, force, 0)
end
function Player:on_update_down(dt, vel)
  -- vel.x, vel.y = vel.x + 0, vel.y + velocity
  self:apply_force_to_controlled_ojbects(dt, 0, force)
end
function Player:on_update_left(dt, vel)
  -- vel.x, vel.y = vel.x  - velocity, vel.y + 0
  self:apply_force_to_controlled_ojbects(dt, -force, 0)
end

function Player:apply_force_to_controlled_ojbects(dt, fx, fy)
  fx, fy = fx * dt, fy * dt
  for id, control_object in pairs(self.controlled_objects) do
    local body = control_object.body
    body:applyForce(fx, fy)
  end
end

local shoot_force = 1
function Player:shoot_ball()
  for _,ball in pairs(BallObject.instances) do
    for _,controlled_object in pairs(ball.controlled_objects_touching) do
      if self.controlled_objects[controlled_object.id] then
        local x1, y1 = controlled_object.body:getPosition()
        local x2, y2 = ball.body:getPosition()
        ball.body:applyLinearImpulse((x2 - x1) * shoot_force, (y2 - y1) * shoot_force)
      end
    end
  end
end

local cluster_force = 1
function Player:cluster_controlled_objects()
  for _,controlled_object_a in pairs(self.controlled_objects) do
    for _,controlled_object_b in pairs(self.controlled_objects) do
        local x1, y1 = controlled_object_a.body:getPosition()
        local x2, y2 = controlled_object_b.body:getPosition()
        controlled_object_a.body:applyLinearImpulse((x2 - x1) * cluster_force, (y2 - y1) * cluster_force)
    end
  end
end
