local Beta = class('Beta', Base)
-- Beta.static.instances = {}

local RADIUS = 5

function Beta:initialize(position, alpha, image)
  Base.initialize(self)

  self.radius = RADIUS
  self.position = position:clone()
  self.image = image
  self.last_x, self.last_y = position.x, position.y
  self.angle = 0

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
  self.angle = math.atan2(self.last_y - y, self.last_x - x) - math.pi / 2
  self.last_x, self.last_y = x, y
  self.position = Vector(x, y)
  self._physics_body:moveTo(x, y)
end

function Beta:draw()
  g.setColor(COLORS.white:rgb())
  g.draw(self.image, self.position.x, self.position.y, self.angle, 1, 1, self.radius, self.radius)
  -- g.circle("fill", self.position.x, self.position.y, 5, 10)
end

function Beta:on_collide(dt, object_two, mtv_x, mtv_y)
  if object_two:isInstanceOf(Beta) and self.alpha ~= object_two.alpha then
    -- collided with opposing beta
    self:destroy()
  elseif object_two:isInstanceOf(Alpha) and self.alpha ~= object_two then
    -- collided with opposing alpha
    self:destroy()
  elseif object_two:isInstanceOf(Predator) then
    self:destroy()
  elseif object_two:isInstanceOf(Resource) then
    self.alpha.player:spawn_beta(self.position)
  end
end

function Beta:destroy()
  local player = self.alpha.player
  player.betas[self.id] = nil
  Collider:remove(self._physics_body)
  self.boid:destroy()
end

return Beta
