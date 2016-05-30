local function drawResources(mesh, x, y, connections, size, cycle)
  local vertex_count = mesh:getVertexCount()
  local t = (2 * math.pi) / vertex_count
  local vertex_offset = math.pi / vertex_count + math.pi / 2

  for i=1,vertex_count do
    local connection = connections[i]
    local cx = x + size * math.cos(i * t - vertex_offset)
    local cy = y + size * math.sin(i * t - vertex_offset)

    local curve
    if connection then
      curve = love.math.newBezierCurve(x, y, cx, cy, connection.x, connection.y)
      g.line(curve:render())
    else
      curve = love.math.newBezierCurve(x, y, cx, cy)
    end

    local x, y = curve:evaluate(cycle)
    g.draw(mesh, x, y, math.atan2(x - x, y - y), 0.2)
  end
end

return drawResources
