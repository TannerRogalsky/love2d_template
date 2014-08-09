local MOVE_FACTOR = 15

function move_to_alpha(boid)
  local beta = boid.parent
  local alpha = beta.alpha
  return (alpha.position - boid.position) / MOVE_FACTOR
end

return move_to_alpha
