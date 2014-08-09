--  Rule #1: Boids try to fly towards the centre of mass of neighbouring boids.
local MOVE_FACTOR = 10

function move_toward_center_of_mass(boid)
  local center_of_mass = center_of_mass(boid, Boid.instances)
  return (center_of_mass - boid.position) / MOVE_FACTOR
end

function center_of_mass(boid, neighbors)
  local center_of_mass = boid.parent.alpha.position
  local count = 1
  for _,neighbor in pairs(neighbors) do
    if neighbor ~= boid then
      count = count + 1
      center_of_mass = center_of_mass + neighbor.position
    end
  end
  return center_of_mass / count
end

return move_toward_center_of_mass
