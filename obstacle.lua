local Obstacle = class('Obstacle', Base):include(Stateful)

Obstacle.static.instances = {}

local function generateNoiseTexture(w, h, color)
  local offset = love.math.random(1024)

  local imageData = g.newCanvas(w, h):newImageData()

  imageData:mapPixel(function(x, y)
    local pv = love.math.noise(x + offset, y + offset)
    if pv > 0.5 then
      return color[1] * pv, color[2] * pv, color[3] * pv, 255
    else
      return color[1], color[2], color[3], 255
    end
  end)

  return g.newImage(imageData)
end

local function generateVertices(sides, radius, ox, oy)
  assert(type(sides) == 'number' and sides >= 3)

  local t = (2 * math.pi) / sides

  local vertices = {
    {0, 0, 0.5 - ox / radius, 0.5 - oy / radius}
  }
  for i=0,sides do
    local x, y = radius * math.cos(i * t), radius * math.sin(i * t)
    local time = 0

    local vertex = {
      x,
      y,
      (x + radius) / radius / 2 - ox / radius,
      (y + radius) / radius / 2 - oy / radius
    }
    table.insert(vertices, vertex)
  end

  return vertices
end

local SIDES = 30

function Obstacle:initialize(world, x, y, radius)
  Base.initialize(self)

  self.body = love.physics.newBody(world, x, y, 'dynamic')
  self.body:setLinearDamping(0.5)
  self.body:setAngularDamping(0.5)

  self.fixture = love.physics.newFixture(self.body, love.physics.newCircleShape(0, 0, radius))
  self.fixture:setUserData(self)
  self.fixture:setRestitution(1)

  local rand = love.math.random
  self.color = {rand(255), rand(255), rand(255)}

  self.mesh = g.newMesh(generateVertices(SIDES, radius, 0, 0), 'fan')
  local texture = generateNoiseTexture(radius, radius, self.color)
  texture:setWrap('repeat')
  self.mesh:setTexture(texture)

  Obstacle.instances[self.id] = self
end

function Obstacle:getRadius()
  return self.fixture:getShape():getRadius()
end

function Obstacle:draw()

  local body = self.body
  local x, y = body:getPosition()

  local radius = self:getRadius()
  local shade = game.preloaded_images['planet_shade.png']
  local shade_half_width = shade:getWidth() / 2
  local shade_ratio = radius / shade_half_width

  local atmosphere = game.preloaded_images['atmosphere.png']
  local atmosphere_half_width = atmosphere:getWidth() / 2
  local atmosphere_ratio = radius / atmosphere_half_width

  g.setColor(255, 255, 255)
  g.draw(self.mesh, x, y, body:getAngle())

  g.setColor(255, 255, 255, 150)
  g.draw(shade, x, y, 0, shade_ratio, shade_ratio, shade_half_width, shade_half_width)

  g.setColor(self.color[1], self.color[2], self.color[3], 150) -- royal blue
  -- g.setColor(100, 149, 237, 150) -- cornflower blue
  g.draw(atmosphere, x, y, 0, atmosphere_ratio * 2, atmosphere_ratio * 2, atmosphere_half_width, atmosphere_half_width)
end

function Obstacle:destroy()
  Obstacle.instances[self.id] = nil
  self.body:destroy()
end

return Obstacle
