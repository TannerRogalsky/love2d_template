local function pointInRect(px, py, x1, y1, x2, y2)
  return px >= x1 and px < x2 and py >= y1 and py < y2
end

return pointInRect
