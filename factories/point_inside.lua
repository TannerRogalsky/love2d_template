local function pointInside(x, y, mesh, ox, oy)
  local vertex_count = mesh:getVertexCount()
  local j, result = vertex_count, false

  for i=1,vertex_count do
    local vx_i, vy_i = mesh:getVertex(i)
    local vx_j, vy_j = mesh:getVertex(j)
    vx_i, vy_i = vx_i + ox, vy_i + oy
    vx_j, vy_j = vx_j + ox, vy_j + oy

    if ((vy_i > y) ~= (vy_j > y) and (x < (vx_j - vx_i) * (y - vy_i) / (vy_j-vy_i) + vx_i)) then
      result = not result
    end

    j = i
  end
  return result
end

return pointInside
