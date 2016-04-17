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

  self.radius = radius
  self.body = love.physics.newBody(world, x, y, 'dynamic')
  self.body:setLinearDamping(0.5)
  self.body:setAngularDamping(0.5)
  self:setVertexNumber(8)
end

function Ball:setVertexNumber(num)
  for _,fixture in ipairs(self.body:getFixtureList()) do
    fixture:destroy()
  end

  self.sides = num
  local triangles = love.math.triangulate(generateVertices(self.sides, self.radius))

  local meshVertices = {}
  for _,triangle in ipairs(triangles) do
    local fixture = love.physics.newFixture(self.body, love.physics.newPolygonShape(triangle))
    fixture:setRestitution(1)

    for i = 1, #triangle, 2 do
      table.insert(meshVertices, {
        triangle[i], triangle[i + 1]
      })
    end
  end

  self.mesh = love.graphics.newMesh(meshVertices, 'triangles', 'static')
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

  g.draw(self.mesh)
  g.pop()
end

return Ball
