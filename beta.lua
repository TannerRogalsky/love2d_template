local Beta = class('Beta', Base)
-- Beta.static.instances = {}

local RADIUS = 5

function Beta:initialize(position, alpha)
  Base.initialize(self)

  self.radius = RADIUS
  self.position = position:clone()

  self.boid = Boid:new(position)
  self.boid.parent = self

  self._physics_body = Collider:addCircle(self.position.x, self.position.y, self.radius)
  self._physics_body.parent = self
  self._physics_body.boid = self.boid

  self.alpha = alpha
end

function Beta:update(dt)
  self.boid:update(dt)
  local x, y = self.boid.position.x, self.boid.position.y
  self.position = Vector(x, y)
  self._physics_body:moveTo(x, y)
end

function Beta:draw()
  g.circle("fill", self.position.x, self.position.y, 5, 10)
end

function Beta:on_collide(dt, object_two, mtv_x, mtv_y)
  if object_two:isInstanceOf(Beta) and self.alpha ~= object_two.alpha then
    self:destroy()
  end
end

function Beta:destroy()
  local player = self.alpha.player
  player.betas[self.id] = nil
  Collider:remove(self._physics_body)
  self.boid:destroy()
end

return Beta
