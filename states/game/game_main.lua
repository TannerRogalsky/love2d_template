local Main = Game:addState('Main')

function Main:enteredState()
  love.physics.setMeter(32)
  World = love.physics.newWorld(0, 10 * 16, true)
  local physics_callback_names = {"begin_contact", "end_contact", "presolve", "postsolve"}
  local physics_callbacks = {}
  for _,callback_name in ipairs(physics_callback_names) do
    local function callback(fixture_a, fixture_b, contact, ...)
      -- print(callback_name, fixture_a, fixture_b, contact, ...)
      local object_one, object_two = fixture_a:getUserData(), fixture_b:getUserData()
      if object_one and is_func(object_one[callback_name]) then
        object_one[callback_name](object_one, object_two, contact, ...)
      end
      if object_two and is_func(object_two[callback_name]) then
        object_two[callback_name](object_two, object_one, contact, ...)
      end
    end
    self[callback_name] = callback
    table.insert(physics_callbacks, callback)
  end
  World:setCallbacks(unpack(physics_callbacks))

  local Camera = require("lib/camera")
  self.camera = Camera:new()

  self.default_font = g.newFont(16)
  g.setFont(self.default_font)

  love.keyboard.setKeyRepeat(false)

  local function up(player)
    player.body:applyLinearImpulse(0, -100)
  end

  local function left(player)
    player.body:applyLinearImpulse(-50, 0)
  end

  local function right(player)
    player.body:applyLinearImpulse(50, 0)
  end

  player1 = PlayerCharacter:new(100, 100, 20, 20)
  player1.controls = {
    w = up,
    a = left,
    d = right
  }

  player2 = PlayerCharacter:new(200, 100, 20, 20)
  player2.controls = {
    up = up,
    left = left,
    right = right
  }

  rope = love.physics.newRopeJoint( player1.body, player2.body, 100, 100, 200, 100, 100, true )

  level = MapLoader.load("level1")
  self.camera:setScale(1 / level.scale, 1 / level.scale)
end

function Main:update(dt)
  World:update(dt)
  -- print("force", rope:getReactionForce(1/dt))
end

function Main:draw()
  self.camera:set()

  g.setColor(COLORS.white:rgb())
  g.draw(level.tile_layers["Background"])

  g.setColor(COLORS.blue:rgb())
  for _,player in pairs(PlayerCharacter.instances) do
    g.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))
  end

  g.setColor(COLORS.white:rgb())
  g.draw(level.tile_layers["Foreground"])

  g.setColor(COLORS.red:rgb())
  g.line(rope:getAnchors())
  self.camera:unset()
end

function Main:mousepressed(x, y, button)
end

function Main:mousereleased(x, y, button)
end

function Main:keypressed(key, unicode)
  local action = player1.controls[key]
  if is_func(action) then action(player1) end

  local action = player2.controls[key]
  if is_func(action) then action(player2) end
end

function Main:keyreleased(key, unicode)
end

function Main:joystickpressed(joystick, button)
end

function Main:joystickreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
end

return Main
