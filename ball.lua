local Ball = class('Ball', Base):include(Stateful)

local function generateVertices(sides, radius)
  assert(type(sides) == 'number' and sides >= 3)

  local t = (2 * math.pi) / sides

  local vertices = {}
  for i=1,sides do
    table.insert(vertices, radius * math.cos(i * t))
    table.insert(vertices, radius * math.sin(i * t))
  end

  return vertices
end

local function generatePolygon(sides, radius)
  return love.physics.newPolygonShape(vertices)
end

function Ball:initialize(world, x, y, radius)
  Base.initialize(self)

  self.body = love.physics.newBody(world, x, y, 'dynamic')
  self.body:setLinearDamping(0.5)
  self.body:setAngularDamping(0.5)

  self.fixture = love.physics.newFixture(self.body, love.physics.newCircleShape(0, 0, radius))
  self.fixture:setUserData(self)
  self.fixture:setRestitution(1)
end

function Ball:getRadius()
  return self.fixture:getShape():getRadius()
end

function Ball:update(dt)
end

function Ball:draw()
  local body = self.body

  g.push()
  local x, y = body:getPosition()
  g.translate(x, y)
  g.rotate(body:getAngle())

  -- for _,fixture in ipairs(body:getFixtureList()) do
  --   local shape = fixture:getShape()
  --   local vertices = {shape:getPoints()}
  --   table.insert(vertices, vertices[1])
  --   table.insert(vertices, vertices[2])
  --   g.line(vertices)
  -- end

  g.circle('fill', 0, 0, self:getRadius())
  g.pop()
end

function Ball:presolve(object_two, contact, nx, ny)
  if object_two and (object_two:isInstanceOf(Obstacle) or object_two:isInstanceOf(Goal)) then
    local selfRadius = self:getRadius()
    local otherRadius = object_two:getRadius()

    if object_two.radius < selfRadius then
      local len = math.sqrt(nx*nx + ny*ny)
      self.fixture:getShape():setRadius(selfRadius + len * 0.8)

      local newOtherRadius = otherRadius - len
      if newOtherRadius <= 0 then
        object_two:destroy()
      else
        object_two.fixture:getShape():setRadius(newOtherRadius)
      end

      contact:setEnabled(false)
    end
  end
end

return Ball
