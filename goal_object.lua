GoalObject = class('GoalObject', Base):include(Stateful)
GoalObject.static.instances = {}

function GoalObject:initialize(player, x, y, w, h)
  Base.initialize(self)

  self.player = player

  self.body = love.physics.newBody(World, x + w / 2, y + h / 2, "kinematic")
  self.shape = love.physics.newRectangleShape(w, h)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setSensor(true)

  GoalObject.instances[self.id] = self
end

function GoalObject:update(dt)
end

function GoalObject:render()
  g.setColor(self.player.color:rgb())
  g.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

function GoalObject:mousepressed(x, y, button)
end

function GoalObject:mousereleased(x, y, button)
end

function GoalObject:keypressed(key, unicode)
end

function GoalObject:keyreleased(key, unicode)
end

function GoalObject:joystickpressed(joystick, button)
end

function GoalObject:joystickreleased(joystick, button)
end

function GoalObject:begin_contact(other, contact)
  if instanceOf(BallObject, other) then
    self.player:add_score(1)
    other:destroy()
  end
end
