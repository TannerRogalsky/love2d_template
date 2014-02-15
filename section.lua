Section = class('Section', Base)

function Section:initialize(attributes)
  Base.initialize(self)
  for k,v in pairs(attributes or {}) do
    self[k] = v
  end

  self.get = function(self, ...) return self.grid:get(...) end
  self.set = function(self, ...) return self.grid:set(...) end

  self.bounds = {}
end

function Section:render()
  local w, h = game.tile_width, game.tile_height
  local x, y = self.x - 1, self.y - 1
  local px, py = x * game.pixel_width, y * game.pixel_height

  g.setColor(COLORS.white:rgb())
  g.draw(self.canvas, px, py)

  for _,bound in pairs(self.bounds) do
    bound:render()
  end

  g.setColor(COLORS.black:rgb())
  g.print(self.x .. ", " .. self.y, px + (self.grid.width * w / 2), py + (self.grid.height * h / 2))
end

function Section:destroy()
  for x, y, tile in self.grid:each() do
    if tile.body then
      tile.body:destroy()
    end
  end

  for _,bound in pairs(self.bounds) do
    bound:destroy()
  end
end
