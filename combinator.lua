local Combinator = class('Combinator', Factory)
local buildMeshTree = require('factories.build_mesh_tree')

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
    for i=1,1 do
      cycle = cycle * -1
      local ox = self.x + size * math.sin(cycle * tau)
      local oy = self.y + size * math.sin(cycle * tau) * math.cos(cycle * tau)
      local scale = 0.2

      local layers = {}
      for i,v in ipairs(self.resources) do
        layers[i] = v.mesh
      end

      g.push()
      g.translate(ox, oy)
      g.scale(scale)
      local tree = buildMeshTree(SIZE, layers, 3)
      for layer_index,layer in ipairs(tree) do
        setFactoryColor(self.resources[layer_index])
        for shape_index,shape in ipairs(layer) do
          g.draw(shape.mesh, shape.x, shape.y, shape.rotation, shape.scale)
        end
      end
      g.pop()
    end
  end
end

function Combinator:connected(other)
  table.insert(self.resources, other)
end

function Combinator:disconnected(other)
  for i,resource in ipairs(self.resources) do
    if resource == other then
      table.remove(self.resources, i)
      break
    end
  end
end

return Combinator
