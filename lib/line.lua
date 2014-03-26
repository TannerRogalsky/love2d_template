local _PACKAGE = (...):match("^(.+)[%./][^%.]+")

local Line = {}
Line.__index = Line
local Vector = require(_PACKAGE .. ".vector")

function Line.new(x1, y1, x2, y2)
  local self = setmetatable({}, Line)

  self.origin = Vector(x1, y1)
  self.destination = Vector(x2, y2)
  self.delta = self.destination - self.origin

  return self
end

function Line.is_line(line)
  return getmetatable(line) == Line
end

function Line.__lt(a,b)
  return a.delta:len() < b.delta:len()
end

function Line:rotated(phi)
  local x1, y1 = self.origin:unpack()
  local x2, y2 = (self.delta:rotated(phi) + self.origin):unpack()
  return Line.new(x1, y1, x2, y2)
end

function Line:parallel(other)
  assert(Line.is_line(other), "Can only check against other Lines.")

  local px, py = self.origin:unpack()
  local dx, dy = self.delta:unpack()

  local o_px, o_py = other.origin:unpack()
  local o_dx, o_dy = other.delta:unpack()

  local mag = self.delta:len()
  local o_mag = other.delta:len()

  return dx / mag == o_dx / o_mag and dy / mag == o_dy / o_mag
end

function Line:intersects(other)
  assert(Line.is_line(other), "Can only check against other Lines.")

  if self:parallel(other) then
    -- Directions are the same.
    return nil
  end

  local px, py = self.origin:unpack()
  local dx, dy = self.delta:unpack()

  local o_px, o_py = other.origin:unpack()
  local o_dx, o_dy = other.delta:unpack()

  -- SOLVE FOR T1 & T2
  -- http://ncase.github.io/sight-and-light/
  local T2 = (dx * (o_py - py) + dy * (px - o_px)) / (o_dx * dy - o_dy * dx)
  local T1 = (o_px + o_dx * T2 - px) / dx

  if T1 <= 0 then return nil end
  if T2 <= 0 or T2 >= 1 then return nil end

  -- Return the intersection ray
  return Line.new(px, py, px + dx * T1, py + dy * T1)
end

function Line:unpack()
  local x1, y1 = self.origin:unpack()
  local x2, y2 = self.destination:unpack()
  return x1, y1, x2, y2
end

return setmetatable(Line, {__call = function(_, ...) return Line.new(...) end})
