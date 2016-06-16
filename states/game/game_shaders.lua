local Shaders = Game:addState('Shaders')
local generateVertices = require('factories.generate_vertices')
local buildMeshTree = require('factories.build_mesh_tree')

local meshes = {}
local tree = {}
local SIZE = 40
local shaders = {}
local current_shader_index = 1

local function generateLayers()
  local r = love.math.random
  local layers = {}
  for i=1,r(3, 7) do
    layers[i] = meshes[r(#meshes)]
  end
  return layers
end

function Shaders:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  for i=3,12 do
    table.insert(meshes, g.newMesh(generateVertices(i, SIZE)))
  end

  tree = buildMeshTree(SIZE, generateLayers())
  local shader_files = {'default', 'test1', 'colors'}
  for i,file in ipairs(shader_files) do
    table.insert(shaders, g.newShader('shaders/' .. file .. '.glsl'))
  end

  self.camera:move(-g.getWidth() / 2, -g.getHeight() / 2)
  g.setBackgroundColor(150, 150, 150)
end

function Shaders:update(dt)
  g.setWireframe(love.keyboard.isDown('space'))
  local shader = shaders[current_shader_index]
  if shader:getExternVariable('time') then
    shader:send('time', love.timer.getTime())
  end
end

function Shaders:draw()
  self.camera:set()

  local shader = shaders[current_shader_index];
  g.setShader(shader)
  for layer_index,layer in ipairs(tree) do
    if shader:getExternVariable('layer_index') then
      shader:sendInt('layer_index', layer_index)
    end
    for shape_index,shape in ipairs(layer) do
      g.setColor(hsl2rgb(layer_index / 6, 1, 0.5))
      g.draw(shape.mesh, shape.x, shape.y, shape.rotation, shape.scale)
    end
  end
  g.setShader()

  self.camera:unset()
end

function Shaders:mousepressed(x, y, button, isTouch)
end

function Shaders:mousereleased(x, y, button, isTouch)
end

function Shaders:keypressed(key, scancode, isrepeat)
end

function Shaders:keyreleased(key, scancode)
  if key == 'r' then
    tree = buildMeshTree(SIZE, generateLayers())
  elseif key == 'tab' then
    current_shader_index = (current_shader_index % #shaders) + 1
  end
end

function Shaders:gamepadpressed(joystick, button)
end

function Shaders:gamepadreleased(joystick, button)
end

function Shaders:focus(has_focus)
end

function Shaders:exitedState()
  self.camera = nil
end

return Shaders
