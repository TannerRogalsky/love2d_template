local Flame = class('Flame', Base):include(Stateful)

function Flame:initialize(x, y, strength)
  Base.initialize(self)

  self.x, self.y = x, y
  self.strength = strength
  local r = love.math.random(4)
  local t = 0.1
  if r == 1 then
    self.animation = anim8.newAnimation({
      game.sprites.quads.fire_blink1,
      game.sprites.quads.fire_blink2,
      game.sprites.quads.fire_blink3,
      game.sprites.quads.fire_blink4,
      game.sprites.quads.fire_blink5,
      game.sprites.quads.fire_blink6,
      game.sprites.quads.fire_blink7,
    }, 0.1)
  elseif r == 2 then
    self.animation = anim8.newAnimation({
      game.sprites.quads.fire_normal1,
      game.sprites.quads.fire_normal2,
      game.sprites.quads.fire_normal3,
      game.sprites.quads.fire_normal4,
      game.sprites.quads.fire_normal5,
      game.sprites.quads.fire_normal6,
      game.sprites.quads.fire_normal7,
    }, 0.1)
  elseif r == 3 then
    self.animation = anim8.newAnimation({
      game.sprites.quads.fire_not_happy1,
      game.sprites.quads.fire_not_happy2,
      game.sprites.quads.fire_not_happy3,
      game.sprites.quads.fire_not_happy4,
      game.sprites.quads.fire_not_happy5,
      game.sprites.quads.fire_not_happy6,
      game.sprites.quads.fire_not_happy7,
    }, 0.1)
  elseif r == 4 then
    self.animation = anim8.newAnimation({
      game.sprites.quads.fire_super_happy1,
      game.sprites.quads.fire_super_happy2,
      game.sprites.quads.fire_super_happy3,
      game.sprites.quads.fire_super_happy4,
      game.sprites.quads.fire_super_happy5,
      game.sprites.quads.fire_super_happy6,
      game.sprites.quads.fire_super_happy7,
    }, 0.1)
  end

  self.fans = {}
  self.scale = 1
end

function Flame:update(dt)
  self.animation:update(dt)

  local fan_count = 0
  for id,fan in pairs(self.fans) do
    fan_count = fan_count + 1
  end

  if fan_count >= self.strength then
    self.scale = math.max(0, self.scale - dt / 6)
  end
end

function Flame:draw()
  local s = self.scale
  local ox, oy = (1 - s) * 25, (1 - s) * 25
  self.animation:draw(game.preloaded_images['sprites.png'], self.x + ox, self.y + oy, 0, s, s)
end

return Flame
