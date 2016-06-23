local Grid = class('Grid', Base)

function Grid:initialize(w, h, tw, th)
  Base.initialize(self)

  self.w, self.h, self.tw, self.th = w, h, tw, th
end

function Grid:to_grid(x, y)
  return math.floor(x / self.tw), math.floor(y / self.th)
end

function Grid:to_pixel(x, y)
  return math.floor(x * self.tw), math.floor(y * self.th)
end

return Grid
