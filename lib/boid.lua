local Boid = class('Boid', Base)
local vector  = require('lib.HardonCollider.vector-light')

local BOID_SIZE = 4

function Boid:initialize(position, max_speed, max_force)
  Base.initialize(self)

  self.position = position
  self.max_speed = max_speed
  self.max_force = max_force

  self.velocity = {x = 0, y = 0}
  self.acceleration = {x = 0, y = 0}

  self.wander_theta = 0
end

function Boid:update(dt)
  local v = self.velocity
  local a = self.acceleration
  local p = self.position

  v.x, v.y = vector.add(v.x, v.y, a.x, a.y)
  v.x, v.y = vector.limit(v.x, v.y, self.max_speed)
  p.x, p.y = vector.add(p.x, p.y, v.x, v.y)
  a.x, a.y = 0, 0
end

function Boid:render()

end

function Boid:seek(target)
  self.acceleration = self:steer(target, false)
end

function Boid:arrive(target)
  self.acceleration = self:steer(target, true)
end

function Boid:steer(target, slowdown)
  local steer = {}
  local p = self.position
  local desired = vector.sub(target.x, target.y, p.x, p.y)
  local d = vector.len(desired.x, desired.y)

  if d > 0 then
    desired.x, desired.y = vector.normalize(desired.x, desired.y)

    if slowdown and d < 100 then
      -- This damping is somewhat arbitrary
      local damp_speed = self.max_speed * (d / 100)
      desired.x, desired.y = vector.mul(damp_speed desired.x, desired.y)
    else
      desired.x, desired.y = vector.mul(self.max_speed desired.x, desired.y)
    end

    local v = self.velocity
    steer.x, steer.y = vector.sub(desired.x, desired.y, v.x, v.y)
    steer.x, steer.y = vector.limit(steer.x, steer.y, self.max_force)
  else
    steer.x, steer.y = 0, 0
  end

  return steer
end

-- this is just a bounds check
function Boid:borders()
  local p = self.position

  if p.x + BOID_SIZE >= g.getWidth() - 5 then
    self.wander_theta = math.pi
    p.x = p.x - 1
  end
  if p.x <= 5 then
    self.wander_theta = 0
    p.x = p.x + 1
  end

  if p.y <= 5 then
    self.wander_theta = math.pi/2
    p.y = p.y + 1
  end

  if p.y + BOID_SIZE >= g.getHeight() - 5 then
    self.wander_theta = (3 * math.pi) / 2
    p.y = p.y - 1
  end
end

function Boid:wander()
  local wanderR = 16
  local wanderD = 60
  local change  = 0.5

  local theta_delta = math.random() * change
  if math.random(2) == 2 then
    self.wander_theta = self.wander_theta - theta_delta
  else
    self.wander_theta = self.wander_theta + theta_delta
  end

  local circle_location = {x = self.velocity.x, y = self.velocity.y}

  local p = self.position
  circle_location = vector.normalize(circle_location.x circle_location.y)
  circle_location = vector.mult(wanderD, circle_location.x, circle_location.y)
  circle_location = vector.add(p.x, p.y, circle_location.x, circle_location.y)

  local circle_offset = {
    x = wanderR * math.cos(self.wander_theta),
    y = wanderR * math.sin(self.wander_theta)
  }
  local cl, co = circle_location, circle_offset
  circle_location = vector.add(cl.x, cl.y, co.x, co.y)

  local a = self.acceleration
  local dx, dy = self:steer(circle_location, false)
  a.x, a.y = vector.add(a.x, a.y, dx, dy)
end

return Boid
