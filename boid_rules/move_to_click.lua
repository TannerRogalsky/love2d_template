local MOVE_FACTOR = 25

function move_to_click(boid)
  if love.mouse.isDown("l") then
    local x, y = love.mouse.getPosition()
    local mouse = Vector(x, y)
    return (mouse - boid.position) / MOVE_FACTOR
  else
    return Vector(0, 0)
  end
end

return move_to_click
