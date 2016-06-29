local Tiling = Game:addState('Tiling')
local buildMeshTree = require('factories.build_mesh_tree')
local generateVertices = require('factories.generate_vertices')
local rotationOffset = require('factories.rotation_offset')
local SUIT = require('lib.SUIT')

local function iAngle(vertex_count)
  return (vertex_count - 2) * math.pi / vertex_count
end

local function eAngle(vertex_count)
  return math.pi * 2 / vertex_count
end

local function vertexControlUI(label)
  SUIT.layout:push(SUIT.layout:row(0, 0))
  SUIT.Label(label, SUIT.layout:row(100, 30))

  local result = 0
  if SUIT.Button('-', {id = label .. '-'}, SUIT.layout:col(100,30)).hit then result = result - 1 end
  if SUIT.Button('+', {id = label .. '+'}, SUIT.layout:col(100,30)).hit then result = result + 1 end
  SUIT.layout:pop()

  return result
end

local SIZE = 40
local meshes = {}
local mesh_indices = {1, 4, 1, 4}

function Tiling:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  for i=3,12 do
    table.insert(meshes, g.newMesh(generateVertices(i, SIZE)))
  end

  self.camera:move(-g.getWidth() / 2, -g.getHeight() / 2)
  g.setBackgroundColor(150, 150, 150)
end

function Tiling:update(dt)
  g.setWireframe(love.keyboard.isDown('space'))

  if not love.keyboard.isDown('h') then
    SUIT.layout:reset(10, 10, 10, 10)

    for i=1,#mesh_indices do
      local new_index = mesh_indices[i] + vertexControlUI('Layer ' .. i .. ': ' .. mesh_indices[i])
      mesh_indices[i] = math.max(1, math.min(#meshes, new_index))
    end

    SUIT.layout:reset(10, g.getHeight() - 40 * 2, 10, 10)

    SUIT.Checkbox(debug, SUIT.layout:row(150, 30))

    if SUIT.Button('Remove Layer', SUIT.layout:row(150, 30)).hit then
      if #mesh_indices > 1 then
        table.remove(mesh_indices)
      end
    end

    if SUIT.Button('Add Layer', SUIT.layout:col(150, 30)).hit then
      table.insert(mesh_indices, 1)
    end
  end
end

function Tiling:draw()
  self.camera:set()

  do
    local mesh = meshes[mesh_indices[1]]
    local px, py = mesh:getVertex(1)
    local phi = 0
    local first_side_length = math.sin(math.pi / mesh:getVertexCount()) * 2 * SIZE
    for i,mesh_index in ipairs(mesh_indices) do
      local mesh = meshes[mesh_index]
      local x, y = mesh:getVertex(1)
      local vertex_count = mesh:getVertexCount()
      local current_side_length = math.sin(math.pi / vertex_count) * 2 * SIZE
      local scale = first_side_length / current_side_length

      g.setColor(hsl2rgb(i / #mesh_indices, 0.75, 0.5))
      local rotation = phi
      if vertex_count % 2 == 0 then
        rotation = rotation - eAngle(vertex_count)
      else
        rotation = rotation - eAngle(vertex_count) / 2
      end
      g.draw(mesh, 0, 0, rotation, scale, scale, x, y)

      phi = phi + iAngle(mesh:getVertexCount())
    end
  end

  -- for i,mesh in ipairs(meshes) do
  --   g.setColor(hsl2rgb(i / #meshes, 0.7, 0.5))
  --   local ox = i * SIZE * 3 - g.getWidth() / 2
  --   local oy = 200
  --   g.draw(mesh, ox, oy)
  --   g.setColor(0, 0, 0)
  --   local x, y = mesh:getVertex(1)
  --   g.circle('fill', x + ox, y + oy, 5)
  -- end

  -- g.setColor(0, 0, 0)
  -- g.circle('fill', 0, 0, 5)

  self.camera:unset()

  SUIT:draw()
end

function Tiling:mousepressed(x, y, button, isTouch)
end

function Tiling:mousereleased(x, y, button, isTouch)
end

function Tiling:keypressed(key, scancode, isrepeat)
end

function Tiling:keyreleased(key, scancode)
end

function Tiling:gamepadpressed(joystick, button)
end

function Tiling:gamepadreleased(joystick, button)
end

function Tiling:focus(has_focus)
end

function Tiling:exitedState()
  self.camera = nil
end

return Tiling
