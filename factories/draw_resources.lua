local intervalIterator = require('factories.interval_iterator')

local function drawResources(mesh, sx, sy, connections, size, cycle)
  local vertex_count = mesh:getVertexCount()
  local rotation_offset = math.pi / vertex_count

  for i, phi in intervalIterator(vertex_count) do
    local connection = connections[i]
    local cx = sx + size * math.cos(phi - rotation_offset)
    local cy = sy + size * math.sin(phi - rotation_offset)

    local curve
    if connection then
      curve = love.math.newBezierCurve(sx, sy, cx, cy, connection.x, connection.y)
      g.line(curve:render())
    else
      curve = love.math.newBezierCurve(sx, sy, cx, cy)
    end

    local x, y = curve:evaluate(cycle)
    g.draw(mesh, x, y, math.atan2(sx - x, sy - y), 0.2)
  end
end

return drawResources
