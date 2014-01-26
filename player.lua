Player = class('Player', Base):include(Stateful)
Player.static.instances = {}
Player.static.SPAWN_TIME_DIVISOR = 1.2

function Player:initialize(control_map, color, direction, joystick)
  Base.initialize(self)

  self.score = 0
  self.score_font = game.preloaded_fonts["visitor1.ttf_60"]

  self.time_to_spawn = 0.5
  self.spawn_timer = 0

  self.color = color
  self.direction = direction

  self.joystick = joystick
  self.control_map = control_map
  self.controlled_objects = {}

  Player.instances[self.id] = self
end

function Player:spawn_controlled_object(x, y)
  x, y = x or self.spawn_point.x, y or self.spawn_point.y
  x, y = x + math.random(-5, 5), y + math.random(-5, 5)

  local controlled_object = ControlledObject:new(x, y)
  self.controlled_objects[controlled_object.id] = controlled_object
  return controlled_object
end

function Player:update(dt)
  -- keyboard
  for key,action in pairs(self.control_map.update) do
    if love.keyboard.isDown(key) then
      action(self, dt)
    end
  end
  -- joystick
  if self.joystick then
    -- joystick stick
    local x, y = self.joystick:getAxis(1), self.joystick:getAxis(2)
    local fx, fy = ControlledObject.MOVE_FORCE * x, ControlledObject.MOVE_FORCE * y
    self:apply_force_to_controlled_ojbects(dt, fx, fy)

    -- joystick hat
    local hat_action = self.joystick:getHat(1)
    for i=1,#hat_action do
      local action = self.control_map.update[hat_action:sub(i, i)]
      if is_func(action) then action(self, dt) end
    end
  end

  for _,controlled_object in pairs(self.controlled_objects) do
    controlled_object:update(dt)
  end

  self.spawn_timer = self.spawn_timer + dt
  if self.spawn_timer > self.time_to_spawn then
    self:spawn_controlled_object()
    self.spawn_timer = self.spawn_timer - self.time_to_spawn
  end
end

function Player:render()
  for id, control_object in pairs(self.controlled_objects) do
    control_object:render(self.color)
  end

  g.setFont(self.score_font)
  g.print(self.score, self.score_text_position.x, self.score_text_position.y)
end

function Player:add_score(delta)
  self.score = self.score + delta
  if self.score >= Game.SCORE_TO_WIN then
    game:gotoState("Over", self)
  end
end

function Player:destroy()
  for _,controlled_object in pairs(self.controlled_objects) do
    controlled_object:destroy()
  end

  Player.instances[self.id] = nil
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
function Player:on_update_up(dt, vel)
  -- vel.x, vel.y = vel.x + 0, vel.y - velocity
  self:apply_force_to_controlled_ojbects(dt, 0, -ControlledObject.MOVE_FORCE)
end
function Player:on_update_right(dt, vel)
  -- vel.x, vel.y = vel.x + velocity, vel.y + 0
  self:apply_force_to_controlled_ojbects(dt, ControlledObject.MOVE_FORCE, 0)
end
function Player:on_update_down(dt, vel)
  -- vel.x, vel.y = vel.x + 0, vel.y + velocity
  self:apply_force_to_controlled_ojbects(dt, 0, ControlledObject.MOVE_FORCE)
end
function Player:on_update_left(dt, vel)
  -- vel.x, vel.y = vel.x  - velocity, vel.y + 0
  self:apply_force_to_controlled_ojbects(dt, -ControlledObject.MOVE_FORCE, 0)
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
