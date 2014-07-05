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
  if self.velocity.y >= 0 then
    self:gotoState()
  end
end

function Jumping:exitedState()
end

return Jumping
