local Lava = class('Lava', Base)

function Lava:initialize(x, y)
  Base.initialize(self)

  self.x, self.y = x, y
end

function Lava:update(dt)
end

function Lava:draw()
  g.setColor(0, 0, 0)
  g.print('LAVA', self.x, self.y)
end

return Lava
