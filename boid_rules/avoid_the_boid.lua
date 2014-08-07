-- Rule #2: Boids try to keep a small distance away from other objects (including other boids).
function avoid_the_boid(boid)
  local DISTANCE_FACTOR = 10
  local c = Vector(0, 0)
  for _,neighbor in pairs(Boid.instances) do
    if math.abs(boid.position:dist(neighbor.position)) < DISTANCE_FACTOR then
      c = c - (neighbor.position - boid.position)
    end
  end
  return c
end

return avoid_the_boid
