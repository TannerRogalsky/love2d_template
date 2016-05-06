local Ball = class('Ball', Base):include(Stateful)

local function generateVertices(sides, radius, ox, oy)
  assert(type(sides) == 'number' and sides >= 3)

  local t = (2 * math.pi) / sides

  local vertices = {
    {0, 0, 0.25 - ox / radius, 0.5 - oy / radius}
  }
  for i=0,sides do
    local x, y = radius * math.cos(i * t), radius * math.sin(i * t)
    local time = 0

    local vertex = {
      x,
      y,
      (x + radius) / radius / 4 - ox / radius,
      (y + radius) / radius / 2 - oy / radius
    }
    table.insert(vertices, vertex)
  end

  return vertices
end

local SIDES = 30

function Ball:initialize(world, x, y, radius)
  Base.initialize(self)

  self.body = love.physics.newBody(world, x, y, 'dynamic')
  self.body:setLinearDamping(1)
  self.body:setAngularDamping(0.5)

  self.fixture = love.physics.newFixture(self.body, love.physics.newCircleShape(0, 0, radius))
  self.fixture:setUserData(self)
  self.fixture:setRestitution(1)

  self.mesh = g.newMesh(generateVertices(SIDES, radius, 0, 0), 'fan')
  game.preloaded_images['earth.png']:setWrap('mirroredrepeat')
  self.mesh:setTexture(game.preloaded_images['earth.png'])
  -- for i=1,self.mesh:getVertexCount() do
  --   local x, y, u, v, r, g, b, a = self.mesh:getVertex(i)
  --   print(x, y)
  --   print(u, v)
  --   print(' ')
  -- end

  self.position = {x = x, y = y}
  self.dx, self.dy = 0, 0
end

function Ball:getRadius()
  return self.fixture:getShape():getRadius()
end

function Ball:update(dt)
  local px, py = self.body:getPosition()
  if self.position.x ~= px or self.position.y ~= py then
    local dx, dy = px - self.position.x, py - self.position.y
    local angle = self.body:getAngle()
    local c, s = math.cos(angle), math.sin(angle)
    dx, dy = c * dx - s * dy, s * dx + c * dy

    local radius = self:getRadius()

    local uv_shift_ratio = 0.00175
    self.dx, self.dy = self.dx + dx * radius * uv_shift_ratio, self.dy + dy * radius * (uv_shift_ratio * 2)
    -- self.dx, self.dy = self.dx + dx, self.dy + dy
    self.mesh:setVertices(generateVertices(SIDES, radius, self.dx, self.dy))

    self.position.x = px
    self.position.y = py
  end
  -- local radius = self:getRadius()
  -- self.dx = self.dx + dt * radius * 0.02
  -- self.dy = self.dy + dt * radius * 0.01
  -- self.mesh:setVertices(generateVertices(SIDES, radius, self.dx, self.dy))
end

function Ball:draw()
  local body = self.body
  local x, y = body:getPosition()
  local angle = body:getAngle()

  local radius = self:getRadius()
  local shade = game.preloaded_images['planet_shade.png']
  local shade_half_width = shade:getWidth() / 2
  local shade_ratio = radius / shade_half_width

  local atmosphere = game.preloaded_images['atmosphere.png']
  local atmosphere_half_width = atmosphere:getWidth() / 2
  local atmosphere_ratio = radius / atmosphere_half_width

  g.setColor(255, 255, 255)
  g.draw(self.mesh, x, y, angle)

  g.setColor(255, 255, 255, 150)
  g.draw(shade, x, y, 0, shade_ratio, shade_ratio, shade_half_width, shade_half_width)

  g.setColor(65, 105, 225, 150) -- royal blue
  -- g.setColor(100, 149, 237, 150) -- cornflower blue
  g.draw(atmosphere, x, y, 0, atmosphere_ratio * 2, atmosphere_ratio * 2, atmosphere_half_width, atmosphere_half_width)

  g.setColor(0, 0, 0, 255)
  g.line(x, y, x + math.cos(angle) * radius, y + math.sin(angle) * radius)
end

function Ball:presolve(object_two, contact, nx, ny)
  if object_two and (object_two:isInstanceOf(Obstacle) or object_two:isInstanceOf(Goal)) then
    local selfRadius = self:getRadius()
    local otherRadius = object_two:getRadius()

    if otherRadius < selfRadius then
      local len = math.sqrt(nx*nx + ny*ny)
      local newSelfRadius = selfRadius + len * 0.8
      self.fixture:getShape():setRadius(newSelfRadius)
      self.mesh:setVertices(generateVertices(SIDES, newSelfRadius, self.dx, self.dy))

      local newOtherRadius = otherRadius - len
      if newOtherRadius <= 0 then
        object_two:destroy()
      else
        object_two.fixture:getShape():setRadius(newOtherRadius)
        object_two.mesh:setVertices(generateVertices(SIDES, newOtherRadius, 0, 0))
      end

      contact:setEnabled(false)
    end
  end
end

return Ball
