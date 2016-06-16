local MultiMeshTest = Game:addState('MultiMesh')
local buildMeshTree = require('factories.build_mesh_tree')
local generateVertices = require('factories.generate_vertices')

local SUIT = require('lib.SUIT')

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

local meshes = {}
local mesh_indices = {1}
local tau = math.pi * 2
local color_cycle = 5

local debug = {checked = true, text = 'Debug'}

local function printDebug(x, y, debug_info, ...)
  if debug_info then
    g.print(debug_info, x, y)
    printDebug(x, y + 12, ...)
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

  randomizer = cron.every(1, function()
    local r = love.math.random
    local layers = r(4, 7)
    mesh_indices = {}
    for i=1,layers do
      mesh_indices[i] = r(#meshes)
    end

    -- if love.keyboard.isDown('h') then
    --   local screenshot = g.newScreenshot()
    --   screenshot:encode('png', os.time() .. '.png')
    -- end
  end)
end

function MultiMeshTest:update(dt)
  -- randomizer:update(dt)
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

function MultiMeshTest:draw()
  self.camera:set()

  local layers = {}
  for i,mesh_index in ipairs(mesh_indices) do
    layers[i] = meshes[mesh_index]
  end
  local tree = buildMeshTree(SIZE, layers)
  for layer_index,layer in ipairs(tree) do
    for shape_index,shape in ipairs(layer) do
      g.setColor(hsl2rgb(layer_index / color_cycle, 1, 0.5))
      g.draw(shape.mesh, shape.x, shape.y, shape.rotation, shape.scale)

      if debug.checked then
        g.setColor(0, 0, 0)
        g.circle('line', shape.x, shape.y, SIZE * shape.scale * math.cos(math.pi / shape.mesh:getVertexCount()))
        g.print(shape_index, shape.x - 6, shape.y - 6)
      end
    end
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
