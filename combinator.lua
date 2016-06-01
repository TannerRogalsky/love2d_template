local Combinator = class('Combinator', Factory)

local function generateVertices(width, height)
  local sides = 50
  local verts = {}
  local t = (2 * math.pi) / sides

  for i=0,sides - 1 do
    local x = width * math.sin(i * t)
    local y = height * math.sin(i * t) * math.cos(i * t)

    table.insert(verts, {x, y})
  end

  return verts
end

local function copyVertex(index, mesh, ox, oy, r)
  local x, y = mesh:getVertex(index)
  local c, s = math.cos(r), math.sin(r)
  return {ox + (c*x - s*y), oy + (s*x + c*y)}
end

local function copyVertices(mesh, verts, x, y, r)
  local origin = copyVertex(1, mesh, x, y, r)

  for i=2,mesh:getVertexCount() - 1 do
    table.insert(verts, origin)
    table.insert(verts, copyVertex(i, mesh, x, y, r))
    table.insert(verts, copyVertex(i + 1, mesh, x, y, r))
  end

  return verts
end

local function getSideLength(mesh)
  local x1, y1 = mesh:getVertex(1)
  local x2, y2 = mesh:getVertex(2)
  local dx, dy = x1 - x2, y1 - y2

  return math.sqrt(dx * dx + dy * dy)
end

local function setFactoryColor(factory)
  if factory.color then
    g.setColor(hsl2rgb(factory.color, 1, 0.5))
  else
    g.setColor(100, 100, 100)
  end
end

local SIZE = 40
local mesh = g.newMesh(generateVertices(SIZE, SIZE))

function Combinator:initialize(x, y)
  Factory.initialize(self, mesh, x, y)

  self.resources = {}
end

function Combinator:drawResources(size, cycle)
  if #self.resources > 0 then
    local tau = math.pi * 2
    for i=1,2 do
      cycle = cycle * -1
      local ox = self.x + size * math.sin(cycle * tau)
      local oy = self.y + size * math.sin(cycle * tau) * math.cos(cycle * tau)
      local scale = 0.2

      do
        local resource = self.resources[1].mesh
        setFactoryColor(self.resources[1])
        g.draw(resource, ox, oy, 0, scale)
      end

      do
        if self.resources[2] then
          setFactoryColor(self.resources[2])
          local resource = self.resources[2].mesh
          local prev = self.resources[1].mesh
          local prev_vertex_count = prev:getVertexCount()
          local curr_vertex_count = resource:getVertexCount()
          local t = math.pi * 2 / prev_vertex_count

          local inner_outer_ratio = (getSideLength(prev) / getSideLength(resource))

          for i=0,prev_vertex_count-1 do
            local x = (SIZE * math.cos(math.pi / prev_vertex_count) * scale + SIZE * math.cos(math.pi / curr_vertex_count) * scale * inner_outer_ratio) * math.cos(i * t + math.pi / 2)
            local y = (SIZE * math.cos(math.pi / prev_vertex_count) * scale + SIZE * math.cos(math.pi / curr_vertex_count) * scale * inner_outer_ratio) * math.sin(i * t + math.pi / 2)

            g.draw(resource, ox + x, oy + y, t * i + math.pi, inner_outer_ratio * scale)
          end
        end
      end
    end
  end
end

function Combinator:connected(other)
  print(other.mesh:getVertexCount() .. ' vertex shaped connected to combinator.')
  table.insert(self.resources, other)
end

function Combinator:disconnected(other)
  print(other.mesh:getVertexCount() .. ' vertex shaped disconnected to combinator.')
end

return Combinator
