local PlayerCharacter = class('PlayerCharacter', Base):include(Stateful)
local cjump = love.audio.newSource( "/sounds/cjump.ogg", "static" )
cjump:setVolume(0.2)
local sjump = love.audio.newSource( "/sounds/sjump.ogg", "static" )
sjump:setVolume(0.2)

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

  if self.joystick then
    local x = self.joystick:getAxis(1)
    self.body:applyAngularImpulse(-x * -1200 * dt, 0)
    self.body:applyLinearImpulse(-x * -20 * dt, 0)

    for key,action in pairs(self.controls.joystick) do
      if self.joystick:isDown(key) then
        action(self, dt)
      end
    end
  end

  local maxAngularVelocity = 6
  if self.body:getAngularVelocity() > maxAngularVelocity then
    self.body:setAngularVelocity(maxAngularVelocity)
  elseif self.body:getAngularVelocity() < -maxAngularVelocity then
    self.body:setAngularVelocity(-maxAngularVelocity)
  end

  if math.abs(self.body:getAngularVelocity()) < 0.3 then
    self.current_anim = self.idle_anim
  else
    self.current_anim = self.active_anim
  end

  if self.current_anim then self.current_anim:update(dt) end
end

function PlayerCharacter:up(dt)
  if self.can_jump then
    if self.player_name == "circle" then
      love.audio.stop(cjump)
      love.audio.play(cjump)
    else
      love.audio.stop(sjump)
      love.audio.play(sjump)
    end
    self.body:applyLinearImpulse(0, -30)
    self.can_jump = false
  end
end

function PlayerCharacter:left(dt)
  self.body:applyAngularImpulse(-1200 * dt, 0)
  self.body:applyLinearImpulse(-20 * dt, 0)
end

function PlayerCharacter:right(dt)
  self.body:applyAngularImpulse(1200 * dt, 0)
  self.body:applyLinearImpulse(20 * dt, 0)
end

function PlayerCharacter:begin_contact(other, contact, nx, ny)
  if ny > 0.5 then
    self.can_jump = true
  end
end

function PlayerCharacter:end_contact(other, contact)
end

return PlayerCharacter
