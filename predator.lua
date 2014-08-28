local Predator = class('Predator', Base)
Predator.static.instances = {}
Predator.static.RADIUS = 20
Predator.static.SPEED = 100
Predator.static.HEALTH = 5

function Predator:initialize(section, origin)
  Base.initialize(self)

  self.radius = Predator.RADIUS
  self.health = Predator.HEALTH
  self.dt = love.math.random(100)
  self.section = section
  self.origin = origin:clone()
  self.x, self.y = self.origin.x, self.origin.y
  self.ox, self.oy = 1, 1
  self.image = game.preloaded_images["predator.png"]
  self.last_x, self.last_y = self.x, self.y
  self.angle = 0

  self._physics_body = Collider:addCircle(self.x, self.y, self.radius)
  self._physics_body.parent = self

  Predator.instances[self.id] = self
end

function Predator:update(dt)
  local closest_alpha = self:get_closest_alpha()
  local target_pos
  local pos = Vector(self.x, self.y)
  if closest_alpha then
    -- chase mode
    target_pos = closest_alpha.position
  else
    self.dt = self.dt + dt
    local x = self.origin.x + math.cos(self.dt) * (Predator.SPEED / self.ox)
    local y = self.origin.y + math.sin(self.dt) * (Predator.SPEED / self.oy)
    target_pos = Vector(x, y)
  end

  local self_pos = Vector(self.x, self.y)
  delta = (target_pos - self_pos):normalized() * Predator.SPEED * dt
  self.x, self.y = (self_pos + delta):unpack()
  self._physics_body:moveTo(self.x, self.y)

  local new_angle = math.atan2(self.last_y - self.y, self.last_x - self.x) - math.pi / 2
  -- local angle_delta = math.clamp(-math.pi / 8, new_angle - self.angle, math.pi / 8)
  local angle_delta = new_angle - self.angle
  self.angle = self.angle + angle_delta
  self.last_x, self.last_y = self.x, self.y
end

function Predator:draw()
  g.setColor(COLORS.white:rgb())
  g.draw(self.image, self.x, self.y, self.angle, 1, 1, self.radius + 5, self.radius + 5)
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

function Predator:get_closest_alpha()
  local closest = nil
  local closest_dist = math.huge
  local self_pos = Vector(self.x, self.y)
  for _, alpha in pairs(self.section.alphas) do
    local dist = self_pos:dist(alpha.position)
    if dist < closest_dist then
      closest_dist = dist
      closest = alpha
    end
  end
  return closest
end

function Predator:destroy()
  Collider:remove(self._physics_body)
  Predator.instances[self.id] = nil
end

return Predator
