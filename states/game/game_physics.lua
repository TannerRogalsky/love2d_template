local Physics = Game:addState('Physics')
local generateVertices = require('factories.generate_vertices')
local buildMeshTree = require('factories.build_mesh_tree')
local buildChainShape = require('factories.build_chain_shape')

local meshes = {}
local tree = {}
local SIZE = 40
local BALL_RADIUS = 5
local balls = {}

local function getVertex(shape, index)
  local vx, vy = shape.mesh:getVertex(index)
  local c, s = math.cos(shape.rotation), math.sin(shape.rotation)
  local scale = shape.scale

  local x = math.round(shape.x + (c * vx - s * vy) * scale)
  local y = math.round(shape.y + (s * vx + c * vy) * scale)

  return x, y
end

local function generateLayers()
  local r = love.math.random
  local layers = {}
  for i=1,r(3, 7) do
    layers[i] = meshes[r(#meshes)]
  end
  return layers
end

local function generateWorld()
  if world then world:destroy() end
  tree = buildMeshTree(SIZE, generateLayers())
  world = love.physics.newWorld()
  body = love.physics.newBody(world)
  shape, vertices = buildChainShape(tree)
  love.physics.newFixture(body, shape)

  balls = {}
  for i=2,#tree,2 do
    for shape_index,shape in ipairs(tree[i]) do
      ball = love.physics.newBody(world, shape.x, shape.y, 'dynamic')
      local circle = love.physics.newCircleShape(BALL_RADIUS)
      ball_fixture = love.physics.newFixture(ball, circle)
      ball_fixture:setRestitution(1)
      local tm = 1500
      local m = love.math.random(tm)
      ball:setLinearVelocity(love.math.random() * m, love.math.random() * (tm - m))
      table.insert(balls, ball)
    end
  end
end

function Physics:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  for i=3,12 do
    table.insert(meshes, g.newMesh(generateVertices(i, SIZE)))
  end

  generateWorld()
  local tree2 = {}
  for layer_index,layer in ipairs(tree) do
    for shape_index,shape in ipairs(layer) do
      local s = {}
      for i=1,shape.mesh:getVertexCount() do
        local x, y = getVertex(shape, i)
        table.insert(s, {x, y})
      end
      table.insert(tree2, s)
    end
  end

  self.camera:move(-g.getWidth() / 2, -g.getHeight() / 2)
  g.setBackgroundColor(150, 150, 150)
  g.setLineJoin('none')

  g.setNewFont()

  regenerator = cron.every(1, generateWorld)
end

function Physics:update(dt)
  g.setWireframe(love.keyboard.isDown('space'))
  world:update(dt)
  if regenerator then regenerator:update(dt) end
end

function Physics:draw()
  self.camera:set()

  local part_scale = 1
  for layer_index,layer in ipairs(tree) do
    for shape_index,shape in ipairs(layer) do
      local mesh = shape.mesh
      g.setColor(hsl2rgb(layer_index / #tree, 1, 0.7))
      -- g.setColor(255, 255, 255)
      g.draw(mesh, shape.x * part_scale, shape.y * part_scale, shape.rotation, shape.scale)
      -- g.setColor(0, 0, 255)
      -- g.print(shape_index, shape.x, shape.y)
    end
  end

  -- for layer_index,layer in ipairs(tree) do
  -- -- for i=1,2 do
  -- --   local layer = tree[i]
  --   for shape_index,shape in ipairs(layer) do
  --   -- for j=1,3 do
  --     -- local shape = layer[j]
  --     local mesh = shape.mesh
  --     g.push()
  --     g.translate(shape.x * 1, shape.y * 1)
  --     g.rotate(shape.rotation)
  --     g.scale(shape.scale)
  --     local j = mesh:getVertexCount()
  --     for i=1,mesh:getVertexCount() do
  --       local x1, y1 = mesh:getVertex(i)
  --       local x2, y2 = mesh:getVertex(j)
  --       local p1, p2 = getVertex(shape, i)
  --       -- g.setColor(0, 0, 255)
  --       -- g.print(i .. ': ' .. p1 .. ',' .. p2, x1, y1)
  --       -- g.setColor(255, 0, 0)
  --       -- g.print(i, (x1 + x2) / 2, (y1 + y2) / 2)
  --       j = i
  --     end
  --     g.pop()
  --   end
  -- end

  g.setColor(0, 0, 0)
  for i=1,shape:getVertexCount()-1 do
    local edge = shape:getChildEdge(i)
    local x1, y1, x2, y2 = edge:getPoints()
    g.line(x1, y1, x2, y2)
    -- g.print(i, (x1 + x2) / 2, (y1 + y2) / 2)
  end

  for i,ball in ipairs(balls) do
    local bx, by = ball:getPosition()
    g.circle('fill', bx, by, BALL_RADIUS)
  end

  -- g.setColor(0, 255, 0)
  -- for i=1,#vertices, 2 do
  --   local x = vertices[i]
  --   local y = vertices[i + 1]
  --   g.print((i + 1) / 2, x, y)
  -- end

  self.camera:unset()
end

function Physics:mousepressed(x, y, button, isTouch)
end

function Physics:mousereleased(x, y, button, isTouch)
end

function Physics:keypressed(key, scancode, isrepeat)
end

function Physics:keyreleased(key, scancode)
  if key == 'r' then
    generateWorld()
  elseif key == 'p' then
    if regenerator then
      regenerator = nil
    else
      regenerator = cron.every(1, generateWorld)
    end
  end
end

function Physics:gamepadpressed(joystick, button)
end

function Physics:gamepadreleased(joystick, button)
end

function Physics:focus(has_focus)
end

function Physics:exitedState()
  self.camera = nil
end

return Physics
