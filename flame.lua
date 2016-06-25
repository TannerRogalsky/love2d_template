local Flame = class('Flame', Base):include(Stateful)

function Flame:initialize(x, y, strength)
  Base.initialize(self)

  self.x, self.y = x, y
  self.strength = strength
  self.animation = anim8.newAnimation({
    game.sprites.quads.flame00,
    game.sprites.quads.flame01,
    game.sprites.quads.flame02,
    game.sprites.quads.flame03,
    game.sprites.quads.flame04,
    game.sprites.quads.flame05,
    game.sprites.quads.flame06,
    game.sprites.quads.flame07,
    game.sprites.quads.flame08,
    game.sprites.quads.flame09,
  }, 0.1)

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
