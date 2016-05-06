local Obstacle = class('Obstacle', Base):include(Stateful)

Obstacle.static.instances = {}

local function generateNoiseTexture(w, h)
  local offset = love.math.random(1024)

  local imageData = g.newCanvas(w, h):newImageData()

  imageData:mapPixel(function(x, y)
    local pv = love.math.noise(x, y, offset)
    if pv > 0.5 then
      return 255, 0, 0, 255
    else
      return 0, 0, 255, 255
    end
  end)

  return g.newImage(imageData)
end

function Obstacle:initialize(world, x, y, radius)
  Base.initialize(self)

  self.radius = radius
  self.body = love.physics.newBody(world, x, y, 'dynamic')
  -- self.body:setLinearDamping(0.5)
  -- self.body:setAngularDamping(0.5)

  self.shape = love.physics.newCircleShape(0, 0, self.radius)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)

  Obstacle.instances[self.id] = self
end

function Obstacle:getRadius()
  return self.fixture:getShape():getRadius()
end

function Obstacle:destroy()
  Obstacle.instances[self.id] = nil
  self.body:destroy()
end

return Obstacle
