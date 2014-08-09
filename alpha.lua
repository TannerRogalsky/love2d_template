local Alpha = class('Alpha', Base)
Alpha.static.instances = {}
Alpha.static.RADIUS = 10
Alpha.static.SPEED = 100


function Alpha:initialize(position)
  Base.initialize(self)
  self.position = position:clone()
  self.radius = Alpha.RADIUS

  self._physics_body = Collider:addCircle(self.position.x, self.position.y, self.radius)
  self._physics_body.parent = self

  Alpha.instances[self.id] = self
end

function Alpha:update(dt)
  local x, y = self._physics_body:center()
  self.position = Vector(x, y)
end

function Alpha:draw()
  g.circle("fill", self.position.x, self.position.y, self.radius)
end

function Alpha:destroy()
  Collider:remove(self._physics_body)
  Alpha.instances[self.id] = nil
end

return Alpha
