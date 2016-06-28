local Planet = Game:addState('Planet')
local generateSphereVertices = require('planet.generate_sphere_vertices')
local tilingNoise = require('planet.tiling_noise')

local SIZE, NUM_VERTS = 500, 40

function Planet:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  local image_data = love.image.newImageData(SIZE, SIZE)
  do
    local random = love.math.random
    -- local x, y = random(0, 100), random(0, 100)
    local x, y = 0, 0
    local FINENESS = 10
    local x1, y1, x2, y2 = x, y, x + FINENESS, y + FINENESS
    image_data:mapPixel(function(x, y)
      local p = tilingNoise(x - 1, y - 1, x1, y1, x2, y2, SIZE, SIZE)
      -- return p * 255, p * 255, p * 255
      return 255, 255, 255, (1 - p) * 255
    end)
  end
  cloud_texture = g.newImage(image_data)
  cloud_texture:setWrap('repeat')

  do
    local random = love.math.random
    -- local x, y = random(0, 100), random(0, 100)
    local x, y = 0, 0
    local FINENESS = 10
    local x1, y1, x2, y2 = x, y, x + FINENESS, y + FINENESS
    image_data:mapPixel(function(x, y)
      local p = tilingNoise(x - 1, y - 1, x1, y1, x1 + FINENESS, y1 + FINENESS, SIZE, SIZE) +
                tilingNoise(x - 1, y - 1, x1, y1, x1 + FINENESS / 2, y1 + FINENESS / 2, SIZE, SIZE)
      p = p / 2
      local r, g, b = hsl2rgb(p, 0.8, 0.5)
      return r, g, b, 255
    end)
  end
  planet_texture = g.newImage(image_data)
  planet_texture:setWrap('repeat')

  sphere_vertices = generateSphereVertices(SIZE / 2, NUM_VERTS, NUM_VERTS, 0, 0)
  mesh = g.newMesh({
    {"VertexPosition", "float", 2}, -- The x,y position of each vertex.
    {"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
    {"VertexColor", "byte", 4},     -- The r,g,b,a color of each vertex.
    {"VertexNormal", "float", 3}
  }, sphere_vertices, 'triangles')
  mesh:setTexture(cloud_texture)

  planet_mesh = g.newMesh(sphere_vertices, 'triangles')
  planet_mesh:setTexture(planet_texture)

  normals_shader = g.newShader('shaders/vertex_normals.glsl')

  self.camera:move(-g.getWidth() / 2, -g.getHeight() / 2)
  -- g.setBackgroundColor(150, 150, 150)
end

function Planet:update(dt)
  g.setWireframe(love.keyboard.isDown('space'))

  local time = love.timer.getTime() / 4
  do
    local aspect_ratio = g.getWidth() / g.getHeight()
    local x, y = math.cos(time * 4) / aspect_ratio, math.sin(time * 4)
    x, y = (x + 1) / 2, (y + 1) / 2
    normals_shader:send('l_pos', {x, y, 0.075})
  end

  -- if normals_shader:getExternVariable('time') then
  --   normals_shader:send('time', time)
  -- end
end

function Planet:draw()
  self.camera:set()
  local mx, my = love.mouse.getPosition()
  -- normals_shader:send('l_color', {1, 0.8, 0.6, 1})
  -- normals_shader:send('l_pos', {mx / g.getWidth(), my / g.getHeight(), 0.075})
  g.setColor(153, 153, 255, 127)
  g.setColor(0, 0, 0, 127)
  -- g.setColor(255, 255, 255)

  g.setShader(normals_shader)
  normals_shader:send('uv_offsets', {love.timer.getTime() / 10, math.sin(love.timer.getTime() / 10)})
  g.draw(planet_mesh)
  -- normals_shader:send('uv_offsets', {love.timer.getTime() / 4, love.timer.getTime() / 4})
  -- g.draw(mesh)
  g.setShader()

  -- g.setColor(255, 255, 255)
  -- g.draw(planet_texture)

  self.camera:unset()

  do
    local aspect_ratio = g.getWidth() / g.getHeight()
    local time = love.timer.getTime()
    local x, y = math.cos(time) / aspect_ratio, math.sin(time)
    x, y = (x + 1) / 2, (y + 1) / 2
    g.setColor(255, 0, 0)
    g.circle('fill', x * g.getWidth(), y * g.getHeight(), 5)
  end
end

function Planet:mousepressed(x, y, button, isTouch)
end

function Planet:mousereleased(x, y, button, isTouch)
end

function Planet:keypressed(key, scancode, isrepeat)
end

function Planet:keyreleased(key, scancode)
end

function Planet:gamepadpressed(joystick, button)
end

function Planet:gamepadreleased(joystick, button)
end

function Planet:focus(has_focus)
end

function Planet:exitedState()
  self.camera = nil
end

return Planet
