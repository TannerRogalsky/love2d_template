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
  g.setColor(0, 0, 255)
  g.rectangle('fill', self.x, self.y, 50, 50)
  do
    local s = 50 / 2
    g.setColor(0, 0, 0)
    local x1, y1 = self.x + s, self.y + s
    local x2, y2 = x1 + math.cos(self.orientation) * s, y1 + math.sin(self.orientation) * s
    g.line(x1, y1, x2, y2)
  end
end

return Player
