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
      action(self, velocity)
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
  for id, control_object in pairs(self.controlled_objects) do
    local body = control_object.body
    body:setLinearVelocity(velocity.x, velocity.y)
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
  -- print("pressed", self, button)
  local action = self.control_map.pressed[button]
  if is_func(action) then action(self) end
end

function Player:joystickreleased(button)
  -- print("released", self, button)
end

local velocity = 150
function Player:on_update_up(vel)
  vel.x, vel.y = vel.x + 0, vel.y - velocity
end
function Player:on_update_right(vel)
  vel.x, vel.y = vel.x + velocity, vel.y + 0
end
function Player:on_update_down(vel)
  vel.x, vel.y = vel.x + 0, vel.y + velocity
end
function Player:on_update_left(vel)
  vel.x, vel.y = vel.x  - velocity, vel.y + 0
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
