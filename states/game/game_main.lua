local Main = Game:addState('Main')
Game.static.CURRENT_LEVEL = "level2"

function Main:enteredState()
  love.window.setFullscreen(true, "desktop")

  love.physics.setMeter(64)
  World = love.physics.newWorld(0, 0, true)
  World:setCallbacks(
    function(a, b, c) self:begin_contact(a, b, c) end,
    function(a, b, c) self:end_contact(a, b, c) end
  )

  -- set up players
  local player1 = Player:new({
    pressed = {
      [" "] = Player.shoot_ball,
      s = Player.cluster_controlled_objects
    },
    update = {
      up = Player.on_update_up,
      right = Player.on_update_right,
      down = Player.on_update_down,
      left = Player.on_update_left
    }
  }, COLORS.red, Direction.WEST)

  local player2 = Player:new({
    pressed = {
      [2] = Player.shoot_ball,
      [3] = Player.cluster_controlled_objects
    },
    update = {
      u = Player.on_update_up,
      r = Player.on_update_right,
      d = Player.on_update_down,
      l = Player.on_update_left
    }
  }, COLORS.green, Direction.EAST, love.joystick.getJoysticks()[1])

  local player3 = Player:new({
    pressed = {
      [2] = Player.shoot_ball,
      [3] = Player.cluster_controlled_objects
    },
    update = {
      u = Player.on_update_up,
      r = Player.on_update_right,
      d = Player.on_update_down,
      l = Player.on_update_left
    }
  }, COLORS.blue, Direction.SOUTH, love.joystick.getJoysticks()[2])

  local player4 = Player:new({
    pressed = {
      [2] = Player.shoot_ball,
      [3] = Player.cluster_controlled_objects
    },
    update = {
      u = Player.on_update_up,
      r = Player.on_update_right,
      d = Player.on_update_down,
      l = Player.on_update_left
    }
  }, COLORS.yellow, Direction.NORTH, love.joystick.getJoysticks()[3])


  -- create level
  self.current_level = Level:new(require("levels/" .. Game.CURRENT_LEVEL))
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

  for _,ball_object in pairs(BallObject.instances) do
    ball_object:render()
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
  World:destroy()
  World = nil
end

return Main
