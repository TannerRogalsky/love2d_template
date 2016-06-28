local pi = math.pi

local function insertVertices(vertices, vert, ...)
  if vert then
    table.insert(vertices, vert)
    insertVertices(vertices, ...)
  end
end

local function createSphereVertex(radius, theta, phi, ox, oy)
  local dx, dy = math.cos(phi) * math.cos(theta), math.sin(theta)
  local x, y = radius * dx, radius * dy
  local r = math.min(1, math.sqrt(dx * dx + dy * dy))
  local f = (1 - math.sqrt(1 - r)) / r
  local u = dx * f + ox
  local v = dy * f + oy

  return {x, y, u, v, 255, 255, 255, 255, dx, dy, 0}
end

local function generateSphereVertices(radius, slices, stacks, ox, oy)
  local vertices = {}

  for t=1,stacks do
    local s = t - stacks / 2
    local theta1 = (s - 1) / stacks * pi
    local theta2 = s / stacks * pi

    for p=1,slices do
      local phi1 = (p - 1) / slices * pi
      local phi2 = p / slices * pi

      local v1 = createSphereVertex(radius, theta1, phi1, ox, oy)
      local v2 = createSphereVertex(radius, theta1, phi2, ox, oy)
      local v3 = createSphereVertex(radius, theta2, phi2, ox, oy)
      local v4 = createSphereVertex(radius, theta2, phi1, ox, oy)

      if( t == 1 ) then -- top cap
        insertVertices(vertices, v1, v3, v4)
      elseif( t == stacks ) then --end cap
        insertVertices(vertices, v3, v1, v2)
      else
        insertVertices(vertices, v1, v2, v4)
        insertVertices(vertices, v2, v3, v4)
      end
    end
  end

  return vertices
end

return generateSphereVertices
