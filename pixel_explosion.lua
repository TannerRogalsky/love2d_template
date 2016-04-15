local PixelExplosion = class('PixelExplosion', Base)

local function updateBatch(batch, pixels)
  batch:clear()

  for _,pixel in pairs(pixels) do
    batch:setColor(unpack(pixel.color))
    batch:add(math.floor(pixel.x), math.floor(pixel.y))
  end
end

function PixelExplosion:initialize(x, y, num)
  Base.initialize(self)

  local data = love.image.newImageData(1, 1)
  data:setPixel(0, 0, 255, 255, 255, 255)
  local image = love.graphics.newImage(data)

  self.num = num
  self.batch = love.graphics.newSpriteBatch(image, self.num, 'stream')

  self.pixels = {}
  for i=1,self.num do
    table.insert(self.pixels, {
      x = x,
      y = y,
      dx = (math.random() - 0.5) * 10,
      dy = (math.random() - 0.5) * 10,
      color = {255, 255, 255, 255},
      color_delta = {0, 0, 0, math.random() * 50 + 50}
    })
  end
  updateBatch(self.batch, self.pixels)
end

function PixelExplosion:update(dt)
  for i,pixel in pairs(self.pixels) do
    pixel.dy = pixel.dy + 1 * dt -- gravity

    pixel.x = pixel.x + pixel.dx * dt
    pixel.y = pixel.y + pixel.dy * dt

    for i,v in ipairs(pixel.color) do
      pixel.color[i] = math.max(0, v - pixel.color_delta[i] * dt)
    end

    if pixel.color.a == 0 then
      self.pixels[i] = nil
      self.num = self.num - 1
    end
  end

  updateBatch(self.batch, self.pixels)
end

function PixelExplosion:draw(x, y)
  g.draw(self.batch, x, y)
end

return PixelExplosion
