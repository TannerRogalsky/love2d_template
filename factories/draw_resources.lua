local function drawResources(mesh, sx, sy, connections, size, cycle)
  local vertex_count = mesh:getVertexCount()
  local t = (2 * math.pi) / vertex_count

  local rotation_offset = math.pi / vertex_count + math.pi / 2
  if vertex_count % 2 == 0 then
    rotation_offset = rotation_offset - t / 2
  end

  for i=1,vertex_count do
    local connection = connections[i]
    local cx = sx + size * math.cos(i * t - rotation_offset)
    local cy = sy + size * math.sin(i * t - rotation_offset)

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
