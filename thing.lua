local Thing = class('Thing', Base):include(Stateful)
Thing.static.instances = {}

function Thing:initialize(x, y, pixels)
  Base.initialize(self)

  self.x = x
  self.y = y

  self.r = 28
  self.g = 62
  self.b = 68

  self.pixels = pixels

  self.start_colors = {}
  for x, y, pixel in self.pixels:each(self.x, self.y, 2, 2) do
    table.insert(self.start_colors, {
      r = pixel.r,
      g = pixel.g,
      b = pixel.b
    })
  end

  Thing.instances[self.id] = self

  self.move_cron = cron.every(1 + love.math.random(), function()
    local gridx = math.ceil(self.x / 32)
    local gridy = math.ceil(self.y / 32)

    self.x = self.x + love.math.random(1, 3) - 2
    self.y = self.y + love.math.random(1, 3) - 2

    self.x = math.clamp((gridx - 1) * 32 + 1, self.x, gridx * 32 - 2)
    self.y = math.clamp((gridy - 1) * 32 + 1, self.y, gridy * 32 - 2)

    local index = 1
    local dimensions = math.sqrt(#self.start_colors)
    for x, y, pixel in self.pixels:each(self.x, self.y, dimensions, dimensions) do
      local new_color = self.start_colors[index]
      pixel.r = new_color.r
      pixel.g = new_color.g
      pixel.b = new_color.b
      index = index + 1
    end
  end)
end

function Thing:update(dt)
  self.move_cron:update(dt)
end

function Thing:destroy()
  Thing.instances[self.id] = nil
end

return Thing