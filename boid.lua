local Boid = class('Boid', Base)
Boid.static.instances = {}

local Vector  = require('lib.vector')

function Boid:initialize(position)
  assert(Vector.isvector(position))

  Base.initialize(self)

  self.position = position:clone()
  self.velocity = Vector(0, 0)

  Boid.instances[self.id] = self
end

function Boid:update(dt)
  self.velocity = self.velocity + move_toward_center_of_mass(self, Boid.instances)
  self.velocity = self.velocity + avoid_the_boid(self, Boid.instances)
  self.velocity = self.velocity + match_velocity(self, Boid.instances)

  self.position = self.position + (self.velocity * dt)
end

function Boid:destroy()
  Boid.instances[self.id] = null
end

--  Rule #1: Boids try to fly towards the centre of mass of neighbouring boids.
function move_toward_center_of_mass(boid, neighbors)
  local MOVE_FACTOR = 10
  local center_of_mass = center_of_mass(boid, neighbors)
  return (center_of_mass - boid.position) / MOVE_FACTOR
end

function center_of_mass(boid, neighbors)
  local center_of_mass = Vector(0, 0)
  local count = 0
  for _,neighbor in pairs(neighbors) do
    if neighbor ~= boid then
      count = count + 1
      center_of_mass = center_of_mass + neighbor.position
    end
  end
  return center_of_mass / count
end

-- Rule #2: Boids try to keep a small distance away from other objects (including other boids).
function avoid_the_boid(boid, neighbors)
  local DISTANCE_FACTOR = 10
  local c = Vector(0, 0)
  for _,neighbor in pairs(neighbors) do
    if math.abs(boid.position:dist(neighbor.position)) < DISTANCE_FACTOR then
      c = c - (neighbor.position - boid.position)
    end
  end
  return c
end

-- Rule #3: Boids try to match velocity with near boids.
function match_velocity(boid, neighbors)
  local VELOCITY_FACTOR = 8
  local average_velocity = average_velocity(boid, neighbors)
  return (average_velocity - boid.velocity) / VELOCITY_FACTOR
end

function average_velocity(boid, neighbors)
  local average_velocity = Vector(0, 0)
  local count = 0
  for _,neighbor in pairs(neighbors) do
    if neighbor ~= boid then
      count = count + 1
      average_velocity = average_velocity + neighbor.velocity
    end
  end
  return average_velocity / count
end

return Boid
