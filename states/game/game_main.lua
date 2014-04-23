local Main = Game:addState('Main')

function Main:enteredState()
  love.physics.setMeter(32)
  World = love.physics.newWorld(0, 10 * 16, true)
  local physics_callback_names = {"begin_contact", "end_contact", "presolve", "postsolve"}
  local physics_callbacks = {}
  for _,callback_name in ipairs(physics_callback_names) do
    local function callback(fixture_a, fixture_b, contact, ...)
      local object_one, object_two = fixture_a:getUserData(), fixture_b:getUserData()
      -- print(callback_name, object_one, object_two, ...)
      local nx, ny = contact:getNormal()
      if object_one and is_func(object_one[callback_name]) then
        object_one[callback_name](object_one, object_two, contact, nx, ny, ...)
      end
      if object_two and is_func(object_two[callback_name]) then
        object_two[callback_name](object_two, object_one, contact, -nx, -ny, ...)
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



  player1 = PlayerCharacter:new(100, 100, 20, 20)
  player1.body = love.physics.newBody(World, 100, 100, "dynamic")
  player1.shape = love.physics.newRectangleShape(0, 0, 20, 20)
  player1.fixture = love.physics.newFixture(player1.body, player1.shape)
  player1.fixture:setUserData(player1)
  player1.fixture:setFriction(100000)
  function player1:draw()
    g.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
  end
  player1.controls = {
    w = PlayerCharacter.up,
    a = PlayerCharacter.left,
    d = PlayerCharacter.right
  }

  player2 = PlayerCharacter:new(200, 100, 20, 20)
  player2.body = love.physics.newBody(World, 200, 100, "dynamic")
  player2.shape = love.physics.newCircleShape(20 / 2)
  player2.fixture = love.physics.newFixture(player2.body, player2.shape)
  player2.fixture:setUserData(player2)
  player2.fixture:setFriction(100000)
  player2.body:setAngularDamping(2)
  function player2:draw()
    local x, y = self.body:getWorldCenter()
    local radius = 20 / 2
    g.circle("fill", x, y, radius, 25)
    g.setColor(COLORS.black:rgb())
    local angle = self.body:getAngle()
    g.line(x, y, x + math.cos(angle) * radius, y + math.sin(angle) * radius)
  end
  player2.controls = {
    up = PlayerCharacter.up,
    left = PlayerCharacter.left,
    right = PlayerCharacter.right
  }

  rope = love.physics.newRopeJoint( player1.body, player2.body, 100, 100, 200, 100, 100, true )
  rope_x, rope_y = 0, 0

  level = MapLoader.load("level1")
  self.camera:setScale(1 / level.scale, 1 / level.scale)
end

function Main:update(dt)
  World:update(dt)
  rope_x, rope_y = rope:getReactionForce(1/dt)

  for _,player in pairs(PlayerCharacter.instances) do
    player:update(dt)
  end
end

function Main:draw()
  self.camera:set()

  g.setColor(COLORS.white:rgb())
  g.draw(level.tile_layers["Background"])

  g.setColor(COLORS.blue:rgb())
  for _,player in pairs(PlayerCharacter.instances) do
    player:draw()
  end

  g.setColor(COLORS.white:rgb())
  g.draw(level.tile_layers["Foreground"])

  if math.abs(rope_x) >= 1 or math.abs(rope_y) >= 1 then
    g.setColor(COLORS.green:rgb())
  else
    g.setColor(COLORS.red:rgb())
  end
  g.line(rope:getAnchors())
  self.camera:unset()
end

function Main:mousepressed(x, y, button)
end

function Main:mousereleased(x, y, button)
end

function Main:keypressed(key, unicode)
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
