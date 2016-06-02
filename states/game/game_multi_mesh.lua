local MultiMeshTest = Game:addState('MultiMesh')

local SUIT = require('lib.SUIT')

local half_pi = math.pi / 2
local function generateVertices(sides, radius)
  assert(type(sides) == 'number' and sides >= 3)

  local t = (2 * math.pi) / sides

  local rotation_offset = half_pi
  if sides % 2 == 0 then
    rotation_offset = half_pi - t  / 2
  end

  -- radius = radius + radius / sides

  local vertices = {}
  for i=0,sides-1 do
    local x, y = radius * math.cos(i * t - rotation_offset), radius * math.sin(i * t - rotation_offset)

    local vertex = {x, y}
    table.insert(vertices, vertex)
  end

  return vertices
end

local function printMesh(mesh)
  for i=1,mesh:getVertexCount() do
    local x, y = mesh:getVertex(i)
    print(x, y)
  end
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

local SIZE = 80

local layer_count = 1
local meshes = {}
local mesh_indices = {1}
local tau = math.pi * 2
local color_cycle = 5

local function drawLayer(total_layers, layer_index, ox, oy, r, scale)
  local previous_mesh = meshes[mesh_indices[layer_index - 1]]
  local previous_vertex_count = previous_mesh:getVertexCount()
  local previous_side_length = math.sin(math.pi / previous_vertex_count) * 2 * SIZE

  local current_mesh = meshes[mesh_indices[layer_index]]
  local current_vertex_count = current_mesh:getVertexCount()
  local current_side_length = math.sin(math.pi / current_vertex_count) * 2 * SIZE

  local t = tau / previous_vertex_count
  local inner_outer_ratio = previous_side_length / current_side_length * scale

  local combined_angle = (math.pi - t) + (math.pi - tau / current_vertex_count) * 2 - 0.0000001 -- rounding errors
  local face_step = math.ceil(combined_angle / tau)

  local previous_distance = SIZE * math.cos(math.pi / previous_vertex_count) * scale
  local current_distance = SIZE * math.cos(math.pi / current_vertex_count) * inner_outer_ratio
  local d = previous_distance + current_distance

  for i=0,previous_vertex_count-1, face_step do
    local phi = i * t + math.pi / 2 + r
    local x = ox + d * math.cos(phi)
    local y = oy + d * math.sin(phi)

    g.setColor(hsl2rgb(layer_index / color_cycle % 1, 1, 0.5))
    g.draw(current_mesh, x, y, t * i + math.pi + r, inner_outer_ratio)

    if layer_index < total_layers then
      drawLayer(total_layers, layer_index + 1, x, y, phi + math.pi / 2, inner_outer_ratio)
    end
  end
end

function MultiMeshTest:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  for i=3,12 do
    table.insert(meshes, g.newMesh(generateVertices(i, SIZE)))
  end

  self.camera:move(-g.getWidth() / 2, -g.getHeight() / 2)
  g.setBackgroundColor(150, 150, 150)
end

function MultiMeshTest:update(dt)
  g.setWireframe(love.keyboard.isDown('space'))

  if not love.keyboard.isDown('h') then
    SUIT.layout:reset(10, 10, 10, 10)

    for i=1,layer_count do
      local new_index = mesh_indices[i] + vertexControlUI('Layer ' .. i .. ': ' .. mesh_indices[i])
      mesh_indices[i] = math.max(1, math.min(#meshes, new_index))
    end

    SUIT.layout:reset(10, g.getHeight() - 40, 10, 10)

    if SUIT.Button('Remove Layer', SUIT.layout:row(150, 30)).hit then
      layer_count = math.max(1, layer_count - 1)
    end

    if SUIT.Button('Add Layer', SUIT.layout:col(150, 30)).hit then
      layer_count = layer_count + 1
      mesh_indices[layer_count] = 1
    end
  end
end

function MultiMeshTest:draw()
  self.camera:set()

  do
    g.setColor(hsl2rgb(1 / color_cycle, 1, 0.5))
    g.draw(meshes[mesh_indices[1]], 0, 0)
  end

  if layer_count > 1 then
    drawLayer(layer_count, 2, 0, 0, 0, 1)
  end

  self.camera:unset()

  SUIT:draw()
end

function MultiMeshTest:mousepressed(x, y, button, isTouch)
end

function MultiMeshTest:mousereleased(x, y, button, isTouch)
end

function MultiMeshTest:keypressed(key, scancode, isrepeat)
end

function MultiMeshTest:keyreleased(key, scancode)
end

function MultiMeshTest:gamepadpressed(joystick, button)
end

function MultiMeshTest:gamepadreleased(joystick, button)
end

function MultiMeshTest:focus(has_focus)
end

function MultiMeshTest:exitedState()
  self.camera = nil
end

return MultiMeshTest
