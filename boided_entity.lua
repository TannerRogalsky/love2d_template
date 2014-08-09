local BoidedEntity = class('BoidedEntity', Base)
BoidedEntity.static.instances = {}

function BoidedEntity:initialize(position, radius)
  assert(Vector.isvector(position))
  Base.initialize(self)

  self.position = position:clone()
  self.boid = Boid:new(position)

  self._physics_body = Collider:addCircle(position.x, position.y, radius)
  self._physics_body.parent = self
  self._physics_body.boid = self.boid

  BoidedEntity.instances[self.id] = self
end

function BoidedEntity:update(dt)
  self.boid:update(dt)
  local x, y = self.boid.position.x, self.boid.position.y
  self.position = Vector(x, y)
  self._physics_body:moveTo(x, y)
end

function BoidedEntity:draw()
  g.circle("fill", self.position.x, self.position.y, 5, 10)
end

function BoidedEntity:destroy()
  Collider:remove(self._physics_body)
  self.boid:destroy()
  BoidedEntity.instances[self.id] = nil
end

return BoidedEntity
