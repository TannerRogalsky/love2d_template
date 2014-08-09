local Alpha = class('Alpha', Base)
Alpha.static.instances = {}
Alpha.static.RADIUS = 10
Alpha.static.SPEED = 100
Alpha.static.HEALTH = 10


function Alpha:initialize(player, position)
  Base.initialize(self)

  self.player = player
  self.position = position:clone()
  self.radius = Alpha.RADIUS
  self.health = Alpha.HEALTH

  self._physics_body = Collider:addCircle(self.position.x, self.position.y, self.radius)
  self._physics_body.parent = self

  Alpha.instances[self.id] = self
end

function Alpha:on_collide(dt, object_two, mtv_x, mtv_y)
  if object_two:isInstanceOf(Beta) and self ~= object_two.alpha then
    print("damage")
    self:damage(1)
  end
end

function Alpha:update(dt)
  local x, y = self._physics_body:center()
  self.position = Vector(x, y)
end

function Alpha:draw()
  g.circle("fill", self.position.x, self.position.y, self.radius)
end

function Alpha:damage(delta)
  self.health = self.health - delta
  if self.health <= 0 then
    self:die()
  end
end

function Alpha:die()
  print("i died")
  self:destroy()
end

function Alpha:destroy()
  Collider:remove(self._physics_body)
  Alpha.instances[self.id] = nil
end

return Alpha
