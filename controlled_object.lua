ControlledObject = class('ControlledObject', Base):include(Stateful)
ControlledObject.static.RADIUS = 10
ControlledObject.static.MAX_VEL = 150

function ControlledObject:initialize(x, y)
  Base.initialize(self)

  self.body = love.physics.newBody(World, x, y, "dynamic")
  self.shape = love.physics.newCircleShape(ControlledObject.RADIUS)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)

  self.body:setMass(1)
end

function ControlledObject:destroy()
  local player = self:get_player()
  player.controlled_objects[self.id] = nil

  for _,ball in pairs(BallObject.instances) do
    if ball.controlled_objects_touching[self.id] then
      ball.controlled_objects_touching[self.id] = nil
    end
  end

  self.body:destroy()
end

function ControlledObject:get_player()
  for _,player in pairs(Player.instances) do
    if player.controlled_objects[self.id] then
      return player
    end
  end
end

function ControlledObject:begin_contact(other, contact)
  if instanceOf(BallObject, other) then
    other.controlled_objects_touching[self.id] = self
  end
end

function ControlledObject:end_contact(other, contact)
  if instanceOf(BallObject, other) then
    other.controlled_objects_touching[self.id] = nil
  end
end

function ControlledObject:update(dt)
  local body = self.body
  local vx, vy = body:getLinearVelocity()
  vx = math.clamp(-ControlledObject.MAX_VEL, vx, ControlledObject.MAX_VEL)
  vy = math.clamp(-ControlledObject.MAX_VEL, vy, ControlledObject.MAX_VEL)

  body:setLinearVelocity(vx, vy)
  body:applyForce(-vx, -vy) -- this works really nicely as drag/friction
end

function ControlledObject:render()
end

function ControlledObject:mousepressed(x, y, button)
end

function ControlledObject:mousereleased(x, y, button)
end

function ControlledObject:keypressed(key, unicode)
end

function ControlledObject:keyreleased(key, unicode)
end

function ControlledObject:joystickpressed(joystick, button)
end

function ControlledObject:joystickreleased(joystick, button)
end
