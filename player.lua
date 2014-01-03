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
  g.setColor(self.color:rgb())
  for id, control_object in pairs(self.controlled_objects) do
    local x, y = control_object.body:getPosition()
    g.circle("fill", x, y, control_object.shape:getRadius())
  end
end

function Player:mousepressed(x, y, button)
end

function Player:mousereleased(x, y, button)
end

function Player:keypressed(key, unicode)
end

function Player:keyreleased(key, unicode)
end

function Player:joystickpressed(joystick, button)
end

function Player:joystickreleased(joystick, button)
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
