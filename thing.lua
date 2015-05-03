local Thing = class('Thing', Base):include(Stateful)
Thing.static.instances = {}

local prefered_colors = {
  {148, 146, 76},
  {73,  84,  65},
  {4, 174, 204},
  {148, 74,  28},
  {60,  136, 68},
  {252, 254, 252},
  {95,  57,  31},
  {108, 250, 220},
  {144, 144, 152},
  {50,  45,  35},
  {28,  62,  68},
  {220, 198, 124},
  {28,  70,  36},
  {164, 218, 196},
  {4, 92,  156},
}

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
    table.insert(self.start_colors, {pixel.r,pixel.g,pixel.b})
  end

  Thing.instances[self.id] = self

  self.move_cron = cron.every(1 + love.math.random(), function()
    local gridx = math.ceil(self.x / 32)
    local gridy = math.ceil(self.y / 32)

    self.start_colors = {}
    for x, y, pixel in self.pixels:each(self.x, self.y, 2, 2) do
      table.insert(self.start_colors, {pixel.r,pixel.g,pixel.b})
    end

    if love.math.random() > 0.98 then
      local random_color = prefered_colors[love.math.random(1, #prefered_colors)]
      self.start_colors[love.math.random(1, #self.start_colors)] = random_color
    end

    self.x = self.x + love.math.random(1, 3) - 2
    self.y = self.y + love.math.random(1, 3) - 2

    self.x = math.clamp((gridx - 1) * 32 + 1, self.x, gridx * 32 - 2)
    self.y = math.clamp((gridy - 1) * 32 + 1, self.y, gridy * 32 - 2)

    local index = 1
    local dimensions = math.sqrt(#self.start_colors)
    for x, y, pixel in self.pixels:each(self.x, self.y, dimensions, dimensions) do
      local new_color = self.start_colors[index]
      local red, green, blue = unpack(new_color)
      pixel.r = red
      pixel.g = green
      pixel.b = blue
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