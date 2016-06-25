local Lava = class('Lava', Base)

function Lava:initialize(x, y)
  Base.initialize(self)

  self.x, self.y = x, y

  if love.math.random() < 0.5 then
    self.animation = anim8.newAnimation({
      game.sprites.quads.lava9,
      game.sprites.quads.lava10,
      game.sprites.quads.lava11,
      }, 0.6)
  else
    self.animation = anim8.newAnimation({
      game.sprites.quads.lava12,
      game.sprites.quads.lava13,
      game.sprites.quads.lava14,
      }, 0.6)
  end
end

function Lava:update(dt)
  self.animation:update(dt)
end

function Lava:draw()
  g.setColor(255, 255, 255)
  self.animation:draw(game.sprites.texture, self.x, self.y)
end

return Lava
