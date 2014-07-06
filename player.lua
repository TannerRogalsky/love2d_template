local Player = class('Player', Base):include(Stateful)
Player.static.instances = {}
local sprite_name = "p1_spritesheet"
local spritesheet_coords = require('images/' .. sprite_name)
local walk_sprites = {
  "walk01",
  "walk02",
  "walk03",
  "walk04",
  "walk05",
  "walk06",
  "walk07",
  "walk08",
  "walk09",
  "walk10",
  "walk11",
}

function Player:initialize()
  Base.initialize(self)

  self.run_speed = 5 * 21
  self.gravity = 5
  self.jump_speed = -2
  self.teleport_distance = -3 * 21

  self.body = Collider:addRectangle(0 * 21, 0, 72 / 3, math.floor(97 / 3))
  self.body.parent = self
  self.velocity = Vector(0, 0)

  self.image = game.preloaded_images[sprite_name .. ".png"]
  local quads = {}
  local iw, ih = self.image:getWidth(), self.image:getHeight()
  for i,sprite_name in ipairs(walk_sprites) do
    local x, y, w, h = unpack(spritesheet_coords[sprite_name])
    table.insert(quads, love.graphics.newQuad(x, y, w, h, iw, ih))
  end
  self.animation = anim8.newAnimation(quads, 0.1)

  Player.instances[self.id] = self
end

function Player:destroy()
  Player.instances[self.id] = nil
  Collider:remove(self.body)
end

function Player:update(dt)
  local dx = self.run_speed
  local dy = self.gravity

  self.velocity = Vector(dx * dt, self.velocity.y + dy * dt)
  self.body:move(self.velocity:unpack())

  self.animation:update(dt)
end

function Player:draw()
  local x1,y1, x2,y2 = self.body:bbox()
  local x, y, w, h = x1, y1, x2-x1, y2-y1
  g.setColor(COLORS.white:rgb())
  self.animation:draw(self.image, x, y, 0, 1 / 3)
end

function Player:on_collide(dt, other, mtv_x, mtv_y)
  self.body:move(mtv_x, mtv_y)
  self.velocity = Vector(self.velocity.x, math.min(0, self.velocity.y))
end

function Player:keypressed(key, unicode)
  if key == " " then
    self:gotoState("Jumping")
  end
end

function Player:keyreleased(key, unicode)
end

return Player
