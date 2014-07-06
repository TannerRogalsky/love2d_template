local Jumping = Player:addState('Jumping')

function Jumping:enteredState()
  self.velocity = Vector(self.velocity.x, self.jump_speed)
end

function Jumping:keypressed(key, unicode)
end

function Jumping:keyreleased(key, unicode)
  if key == " " then
    self:gotoState("Teleporting")
  end
end

function Jumping:on_collide(dt, other, mtv_x, mtv_y)
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

function Jumping:exitedState()
end

return Jumping
