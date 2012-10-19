local Camera = class("Camera", Base)

function Camera:initialize()
  Base.initialize(self)
  self.x = 0
  self.y = 0
  self.scaleX = 1
  self.scaleY = 1
  self.rotation = 0
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
end

function Camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function Camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function Camera:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

function Camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

function Camera:mousePosition()
  return love.mouse.getX() * self.scaleX + self.x, love.mouse.getY() * self.scaleY + self.y
end

return Camera
