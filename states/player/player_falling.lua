local Falling = Player:addState('Falling')

function Falling:enteredState()
  self.velocity = Vector(self.velocity.x, self.jump_speed)
end

function Falling:keypressed(key, unicode)
end

function Falling:keyreleased(key, unicode)
end

function Falling:on_collide(dt, other, mtv_x, mtv_y)
  if self.velocity.y >= 0 then
    self:gotoState()
  end
end

function Falling:exitedState()
end

return Falling
