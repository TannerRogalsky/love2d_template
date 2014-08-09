-- Rule #2: Boids try to keep a small distance away from other objects (including other boids).
local DISTANCE_FACTOR = 20

function avoid_the_mouse(boid)
  local c = Vector(0, 0)
  local x, y = love.mouse.getPosition()
  local mouse = Vector(x, y)
  if math.abs(boid.position:dist(mouse)) < DISTANCE_FACTOR then
    c = c - (mouse - boid.position)
  end
  return c
end

return avoid_the_mouse
