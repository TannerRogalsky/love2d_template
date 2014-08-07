-- Rule #3: Boids try to match velocity with near boids.
function match_velocity(boid)
  local VELOCITY_FACTOR = 8
  local average_velocity = average_velocity(boid, Boid.instances)
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

return match_velocity
