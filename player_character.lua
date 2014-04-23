local PlayerCharacter = class('PlayerCharacter', Base):include(Stateful)
PlayerCharacter.static.instances = {}

function PlayerCharacter:initialize(x, y, w, h)
  Base.initialize(self)

  self.can_jump = false

  PlayerCharacter.instances[self.id] = self
end

function PlayerCharacter:update(dt)
  for key,action in pairs(self.controls) do
    if love.keyboard.isDown(key) then
      action(self, dt)
    end
  end

  local maxAngularVelocity = 6
  if self.body:getAngularVelocity() > maxAngularVelocity then
    self.body:setAngularVelocity(maxAngularVelocity)
  elseif self.body:getAngularVelocity() < -maxAngularVelocity then
    self.body:setAngularVelocity(-maxAngularVelocity)
  end
end

function PlayerCharacter:up(dt)
  if self.can_jump then
    self.body:applyLinearImpulse(0, -15)
  end
end

function PlayerCharacter:left(dt)
  self.body:applyAngularImpulse(-1200 * dt, 0)
end

function PlayerCharacter:right(dt)
  self.body:applyAngularImpulse(1200 * dt, 0)
end

function PlayerCharacter:begin_contact(other, contact, nx, ny)
  print(self, nx, ny, self.can_jump)
  if ny > 0.5 then
    self.can_jump = true
  end
end

function PlayerCharacter:end_contact(other, contact)
  self.can_jump = false
end

return PlayerCharacter
