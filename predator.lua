local Predator = class('Predator', Base)
Predator.static.instances = {}
Predator.static.RADIUS = 20
Predator.static.SPEED = 100
Predator.static.HEALTH = 20

function Predator:initialize(section, origin)
  Base.initialize(self)

  self.radius = Predator.RADIUS
  self.health = Predator.HEALTH
  self.dt = love.math.random(100)
  self.section = section
  self.origin = origin:clone()
  self.x, self.y = self.origin.x, self.origin.y
  self.ox, self.oy = math.random(3), math.random(3)

  self._physics_body = Collider:addCircle(self.x, self.y, self.radius)
  self._physics_body.parent = self

  Predator.instances[self.id] = self
end

function Predator:update(dt)
  self.dt = self.dt + dt
  self.x = self.origin.x + math.cos(self.dt) * (Predator.SPEED / self.ox)
  self.y = self.origin.y + math.sin(self.dt) * (Predator.SPEED / self.oy)
  self._physics_body:moveTo(self.x, self.y)
end

function Predator:draw()
  g.setColor(COLORS.black:rgb())
  g.circle("fill", self.x, self.y, 20)
end

function Predator:on_collide(dt, object_two, mtv_x, mtv_y)
  if object_two:isInstanceOf(Beta) then
    self:damage(1)
  end
end

function Predator:damage(delta)
  self.health = self.health - delta
  if self.health <= 0 then
    self:die()
  end
end

function Predator:die()
  self:destroy()
end

function Predator:destroy()
  Collider:remove(self._physics_body)
  Predator.instances[self.id] = nil
end

return Predator
