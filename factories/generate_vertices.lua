local intervalIterator = require('factories.interval_iterator')

local function generateVertices(sides, radius)
  assert(type(sides) == 'number' and sides >= 3)

  local vertices = {}
  for i, phi in intervalIterator(sides) do
    local x, y = radius * math.cos(phi), radius * math.sin(phi)
    local vertex = {x, y}
    table.insert(vertices, vertex)
  end

  return vertices
end

return generateVertices
