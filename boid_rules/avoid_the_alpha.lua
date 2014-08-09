function avoid_the_alpha(boid)
  local DISTANCE_FACTOR = Alpha.RADIUS * 1.5
  local beta = boid.parent
  local alpha = beta.alpha
  local c = Vector(0, 0)
  if math.abs(boid.position:dist(alpha.position)) < DISTANCE_FACTOR then
    c = c - (alpha.position - boid.position)
  end
  return c
end

return avoid_the_alpha
