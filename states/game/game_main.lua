local Main = Game:addState('Main')
Game.static.CURRENT_LEVEL = "level2"
Game.static.SCORE_TO_WIN = 5

function Main:enteredState(level_reference)
  love.physics.setMeter(64)
  World = love.physics.newWorld(0, 0, true)
  World:setCallbacks(
    function(a, b, c) self:begin_contact(a, b, c) end,
    function(a, b, c) self:end_contact(a, b, c) end
  )

  -- create level
  level_reference = level_reference or Game.CURRENT_LEVEL
  self.current_level = Level:new(require("levels/" .. level_reference))
end

function Main:update(dt)
  for id,player in pairs(Player.instances) do
    player:update(dt)
  end

  for _,ball_object in pairs(BallObject.instances) do
    ball_object:update(dt)
  end

  self.current_level:update(dt)

  World:update(dt)
end

function Main:render()
  self.camera:set()
  self.camera:setPosition(-self.current_level.offset.x, -self.current_level.offset.y)

  self.current_level:render()

  for id,player in pairs(Player.instances) do
    player:render()
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
  for _,player in pairs(Player.instances) do
    player:keypressed(key, unicode)
  end
end

function Main:keyreleased(key, unicode)
end

function Main:joystickpressed(joystick, button)
  for _,player in pairs(Player.instances) do
    if joystick == player.joystick then
      player:joystickpressed(button)
    end
  end
end

function Main:joystickreleased(joystick, button)
  for _,player in pairs(Player.instances) do
    if joystick == player.joystick then
      player:joystickreleased(button)
    end
  end
end

function Main:focus(has_focus)
end

function Main:begin_contact(fixture_a, fixture_b, contact)
  local object_one, object_two = fixture_a:getUserData(), fixture_b:getUserData()

  if object_one and is_func(object_one.begin_contact) then
    object_one:begin_contact(object_two, contact)
  end

  if object_two and is_func(object_two.begin_contact) then
    object_two:begin_contact(object_one, contact)
  end
end

function Main:end_contact(fixture_a, fixture_b, contact)
  local object_one, object_two = fixture_a:getUserData(), fixture_b:getUserData()

  if object_one and is_func(object_one.end_contact) then
    object_one:end_contact(object_two, contact)
  end

  if object_two and is_func(object_two.end_contact) then
    object_two:end_contact(object_one, contact)
  end
end

function Main:exitedState()
  self.screen_shot = g.newImage(g.newScreenshot(false))

  for _,ball_object in pairs(BallObject.instances) do
    ball_object:destroy()
  end

  for _,goal in pairs(GoalObject.instances) do
    goal:destroy()
  end

  for _,powerup in pairs(PowerUp.instances) do
    powerup:destroy()
  end

  for _,player in pairs(Player.instances) do
    player:destroy()
  end

  cron.reset()

  World:destroy()
  World = nil
end

return Main
