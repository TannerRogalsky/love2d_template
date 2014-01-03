ControlledObject = class('ControlledObject', Base):include(Stateful)
ControlledObject.static.RADIUS = 10

function ControlledObject:initialize(x, y)
  Base.initialize(self)

  self.body = love.physics.newBody(World, x, y, "dynamic")
  self.shape = love.physics.newCircleShape(ControlledObject.RADIUS)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
end

function ControlledObject:destroy()
  local player = self:get_player()
  player.controlled_objects[self.id] = nil
  self.body:destroy()
end

function ControlledObject:get_player()
  for _,player in pairs(Player.instances) do
    if player.controlled_objects[self.id] then
      return player
    end
  end
end

function ControlledObject:update(dt)
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
