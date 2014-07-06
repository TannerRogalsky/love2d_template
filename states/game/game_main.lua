local Main = Game:addState('Main')

function Main:enteredState()
  love.keyboard.setKeyRepeat(false)
  Collider = HC(100, self.on_start_collide, self.on_stop_collide)

  local Camera = require("lib/camera")
  self.camera = Camera:new()
  self.camera:scale(1 / 2)

  self.map = MapLoader.load("level1")

  g.setFont(self.preloaded_fonts["04b03_16"])

  self.bg = self.preloaded_images["bg.png"]

  self.player = Player:new()
  LoseField:new(0, self.map.height * 21, self.map.width * 21, 50)
  WinField:new((self.map.width - 1) * 21, 0, 50, self.map.height * 21)
end

function Main:update(dt)
  for k,player in pairs(Player.instances) do
    player:update(dt)
  end

  local pv = Vector(self.player.body:center())
  local cv = Vector(self.camera.x, self.camera.y)
  pv = Vector(pv.x - g.getWidth() / (2 / self.camera.scaleX), pv.y - g.getHeight() / (2 / self.camera.scaleY))
  local mag = pv:dist(cv)
  local dx, dy = (pv - cv):normalized():unpack()
  dx, dy = dx * mag, dy * mag
  local dx, dy = math.clamp(-mag / 20, dx, mag / 20), math.clamp(-mag / 20, dy, mag / 20)
  dx, dy = math.floor(dx * 2) / 2, math.floor(dy * 2) / 2
  self.camera:move(dx, dy)

  Collider:update(dt)
end

function Main:draw()
  g.setColor(COLORS.white:rgb())
  g.draw(self.bg, 0, 0)
  self.camera:set()

  g.setColor(COLORS.white:rgb())
  g.draw(self.map.tile_layers["Background"].sprite_batch)

  for k,player in pairs(Player.instances) do
    player:draw()
  end

  -- for k,platform in pairs(Platform.instances) do
  --   platform:draw()
  -- end

  -- for k,platform in pairs(LoseField.instances) do
  --   platform:draw()
  -- end

  -- for k,platform in pairs(WinField.instances) do
  --   platform:draw()
  -- end

  g.setColor(COLORS.white:rgb())
  g.draw(self.map.tile_layers["Foreground"].sprite_batch)

  self.camera:unset()
end

function Main:mousepressed(x, y, button)
end

function Main:mousereleased(x, y, button)
end

function Main:keypressed(key, unicode)
  for k,player in pairs(Player.instances) do
    player:keypressed(key, unicode)
  end
end

function Main:keyreleased(key, unicode)
  for k,player in pairs(Player.instances) do
    player:keyreleased(key, unicode)
  end
end

function Main:joystickpressed(joystick, button)
end

function Main:joystickreleased(joystick, button)
end

function Main:focus(has_focus)
end

-- shape_one and shape_two are the colliding shapes. mtv_x and mtv_y define the minimum translation vector,
-- i.e. the direction and magnitude shape_one has to be moved so that the collision will be resolved.
-- Note that if one of the shapes is a point shape, the translation vector will be invalid.
function Main.on_start_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  local object_one, object_two = shape_one.parent, shape_two.parent

  if object_one and is_func(object_one.on_collide) then
    object_one:on_collide(dt, object_two, mtv_x, mtv_y)
  end

  if object_two and is_func(object_two.on_collide) then
    object_two:on_collide(dt, object_one, -mtv_x, -mtv_y)
  end
end

function Main.on_stop_collide(dt, shape_one, shape_two)
end

function Main:exitedState()
  Collider:clear()
  Collider = nil
end

return Main
