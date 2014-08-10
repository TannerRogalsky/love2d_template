local Alpha = class('Alpha', Base)
Alpha.static.instances = {}
Alpha.static.RADIUS = 15
Alpha.static.SPEED = 100
Alpha.static.HEALTH = 10


function Alpha:initialize(player, position, image)
  Base.initialize(self)

  self.player = player
  self.image = image
  self.position = position:clone()
  self.radius = Alpha.RADIUS
  self.health = Alpha.HEALTH
  self.last_x, self.last_y = position.x, position.y
  self.angle = 0

  self._physics_body = Collider:addCircle(self.position.x, self.position.y, self.radius)
  self._physics_body.parent = self

  Alpha.instances[self.id] = self
end

function Alpha:on_collide(dt, object_two, mtv_x, mtv_y)
  if object_two:isInstanceOf(Beta) and self ~= object_two.alpha then
    print("damage")
    self:damage(1)
  elseif object_two:isInstanceOf(Predator) then
    self:damage(Alpha.HEALTH)
  end
end

function Alpha:update(dt)
  local x, y = self._physics_body:center()
  if x ~= self.last_x or y ~= self.last_y then
    self:bounds_check()
    self.angle = math.atan2(self.last_y - y, self.last_x - x) - math.pi / 2
    self.last_x, self.last_y = x, y
    self.position = Vector(x, y)
  end
end

function Alpha:bounds_check()
  local x1, y1, x2, y2 = self._physics_body:bbox()
  local dx, dy = 0, 0
  local w, h = LovePixlr._w,LovePixlr._h
  if x1 < 0 then dx = dy - x1 end
  if y1 < 0 then dy = dy - y1 end
  if x2 > w then dx = dx + (w - x2) end
  if y2 > h then dy = dy + (h - y2) end
  self._physics_body:move(dx, dy)
end

function Alpha:draw()
  g.setColor(COLORS.white:rgb())
  g.draw(self.image, self.position.x, self.position.y, self.angle, 1, 1, self.radius, self.radius)
end

function Alpha:damage(delta)
  self.health = self.health - delta
  if self.health <= 0 then
    self:die()
  end
end

function Alpha:die()
  local other_player
  for _,player in pairs(Player.instances) do
    if player ~= self.player then
      other_player = player
      break
    end
  end
  cron.after(0.1, function()
    game:gotoState("Over", other_player)
  end)
end

function Alpha:destroy()
  Collider:remove(self._physics_body)
  Alpha.instances[self.id] = nil
end

return Alpha
