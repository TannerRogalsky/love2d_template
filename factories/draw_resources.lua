local function drawResources(mesh, dist, ox, oy)
  g.setBlendMode('subtract')
  g.setColor(100, 100, 100)
  local vertex_count = mesh:getVertexCount()
  local t = (2 * math.pi) / vertex_count
  local vertex_offset = math.pi / vertex_count + math.pi / 2

  for i=1,vertex_count do
    local x, y = dist * math.cos(i * t - vertex_offset), dist * math.sin(i * t - vertex_offset)

    g.draw(mesh, x + ox, y + oy, math.atan2(x, -y), 0.2)
  end
  g.setBlendMode('alpha')
end

return drawResources
