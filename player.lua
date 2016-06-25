local Player = class('Player', Base):include(Stateful)
Player.static.TILE_MOVE_TIME = 1/6

function Player:initialize(x, y)
  Base.initialize(self)

  self.x, self.y = x, y
  self.orientation = 0
end

function Player:update(dt)
end

function Player:draw()
  g.setColor(255, 255, 255)
  self.animation:draw(game.sprites.texture, self.x + 25, self.y + 25, self.orientation + math.pi / 2, 1, 1, 25, 25)
end

return Player
