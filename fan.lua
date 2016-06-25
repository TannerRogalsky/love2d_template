local Fan = class('Fan', Base):include(Stateful)

local SPEED = 50
local function newWindEffect(phi, size, distance)
  local image_data = love.image.newImageData(1, 1)
  image_data:setPixel(0, 0, 255, 255, 255)
  local image = g.newImage(image_data)

  local dx, dy = math.cos(phi), math.sin(phi)
  local theta = (phi + math.pi / 2) % math.pi
  local max_lifetime = ((distance ) * 50) / SPEED / 2

  local p = g.newParticleSystem(image, max_lifetime * 100)
  p:setParticleLifetime(max_lifetime, max_lifetime) -- Particles live at least 2s and at most 5s.
  p:setEmissionRate(75)
  p:setSizeVariation(1)
  -- p:setLinearAcceleration(dx * SPEED, dy * SPEED, dx * SPEED, dy * SPEED) -- Random movement in all directions.
  p:setSpeed(SPEED, SPEED)
  p:setDirection(phi)
  p:setColors(100, 100, 255, 255, 100, 100, 255, 0) -- Fade to transparency.
  p:setAreaSpread('uniform', math.cos(theta) * size, math.sin(theta) * size)

  return p
end

function Fan:initialize(x, y, orientation, strength, moveable)
  Base.initialize(self)

  self.x, self.y, self.orientation = x, y, orientation
  self.strength = strength
  self.moveable = moveable
  self.psystem = newWindEffect(self.orientation, 50 / 2 / 3, self.strength)
  self.active = true
  self:toggle_active()
end

function Fan:update(dt)
  self.psystem:update(dt)
end

function Fan:draw()
  g.setColor(255, 0, 0)
  g.rectangle('fill', self.x, self.y, 50, 50)
  g.setColor(255, 255, 255)
  do
    local scale = 3
    local x, y = self.x + math.cos(self.orientation) * 25, self.y + math.sin(self.orientation) * 25
    g.draw(self.psystem, x, y, 0, scale, scale, -25 / scale, -25 / scale)
  end
end

function Fan:getInfluence()
  local phi = self.orientation
  local dx, dy = math.cos(phi), math.sin(phi)
  local fx1, fy1 = self.x + dx * 50, self.y + dy * 50
  local fx2, fy2 = self.x + self.strength * dx * 50, self.y + self.strength * dy * 50
  if fx1 > fx2 then fx1, fx2 = fx2, fx1 end
  if fy1 > fy2 then fy1, fy2 = fy2, fy1 end
  fx2, fy2 = fx2 + 50, fy2 + 50
  return fx1, fy1, fx2, fy2
end

function Fan:toggle_active()
  self.active = not self.active
  self.psystem:reset()

  if self.active then
    self.psystem:setEmissionRate(75)
  else
    self.psystem:setEmissionRate(0)
  end
end

return Fan
