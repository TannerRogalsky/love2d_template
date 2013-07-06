local Camera = class("Camera", Base)

function Camera:initialize()
  Base.initialize(self)
  self.x = 0
  self.y = 0
  self.scaleX = 1
  self.scaleY = 1
  self.rotation = 0

  self.bounds = {
    negative_x = -math.huge,
    negative_y = -math.huge,
    positive_x = math.huge,
    positive_y = math.huge,
    negative_sx = -math.huge,
    negative_sy = -math.huge,
    positive_sx = math.huge,
    positive_sy = math.huge
  }
end

function Camera:set()
  g.push()
  g.rotate(-self.rotation)
  g.scale(1 / self.scaleX, 1 / self.scaleY)
  g.translate(-self.x, -self.y)
end

function Camera:unset()
  g.pop()
end

function Camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
  self.x = math.clamp(self.bounds.negative_x, self.x, self.bounds.positive_x)
  self.y = math.clamp(self.bounds.negative_y, self.y, self.bounds.positive_y)
end

function Camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function Camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
  self.scaleX = math.clamp(self.bounds.negative_sx, self.scaleX, self.bounds.positive_sx)
  self.scaleY = math.clamp(self.bounds.negative_sy, self.scaleY, self.bounds.positive_sy)
end

function Camera:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
  self.x = math.clamp(self.bounds.negative_x, self.x, self.bounds.positive_x)
  self.y = math.clamp(self.bounds.negative_y, self.y, self.bounds.positive_y)
end

function Camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
  self.scaleX = math.clamp(self.bounds.negative_sx, self.scaleX, self.bounds.positive_sx)
  self.scaleY = math.clamp(self.bounds.negative_sy, self.scaleY, self.bounds.positive_sy)
end

function Camera:mousePosition(x, y)
  x = x or love.mouse.getX()
  y = y or love.mouse.getY()
  return x * self.scaleX + self.x, y * self.scaleY + self.y
end

return Camera
