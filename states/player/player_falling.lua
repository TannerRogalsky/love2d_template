local Falling = Player:addState('Falling')

function Falling:enteredState()
end

function Falling:keypressed(key, unicode)
end

function Falling:keyreleased(key, unicode)
end

function Falling:on_collide(dt, other, mtv_x, mtv_y)
  local collision = {
    is_down = mtv_y < 0,
    is_up = mtv_y > 0,
    is_left = mtv_x > 0,
    is_right = mtv_x < 0
  }
  self.body:move(mtv_x, math.max(0, mtv_y))
  if collision.is_down then
    self:gotoState()
  end
end

function Falling:exitedState()
end

return Falling
