local Sphere = Game:addState('Sphere')
local intervalIterator = require('factories.interval_iterator')
local generateSphereVertices = require('planet.generate_sphere_vertices')
local tilingNoise = require('planet.tiling_noise')
local WIDTH, HEIGHT, NUM_VERTS = 100, 100, 40

function Sphere:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  local image_data = love.image.newImageData(WIDTH, HEIGHT)
  do
    local random = love.math.random
    -- local x, y = random(0, 100), random(0, 100)
    local x, y = 0, 0
    local x1, y1, x2, y2 = x, y, x + WIDTH / 20, y + HEIGHT / 20
    image_data:mapPixel(function(x, y)
      local p = tilingNoise(x - 1, y - 1, x1, y1, x2, y2, WIDTH, HEIGHT)
      return p * 255, p * 255, p * 255
    end)
  end
  texture = g.newImage(image_data)
  texture:setWrap('repeat')

  sphere_vertices = generateSphereVertices(WIDTH / 2, NUM_VERTS, NUM_VERTS, 0, 0)
  sphere_mesh = g.newMesh(sphere_vertices, 'triangles')
  sphere_mesh:setTexture(texture)
  -- game.preloaded_images['earth.jpg']:setWrap('repeat')
  -- sphere_mesh:setTexture(game.preloaded_images['earth.jpg'])

  normal_sphere_shader = g.newShader('shaders/normal_sphere.glsl')
  normal_sphere_shader:send('texture_size', {WIDTH, HEIGHT})
  normal_sphere = g.newCanvas(WIDTH, HEIGHT)
  g.setCanvas(normal_sphere)
    g.setShader(normal_sphere_shader)
    g.rectangle('fill', 0, 0, WIDTH, HEIGHT)
    g.setShader()
  g.setCanvas()

  normal_map_shader = g.newShader('shaders/normal_map.glsl')

  sphere_shader = g.newShader('shaders/sphere.glsl')

  do
    local img = game.preloaded_images['earth.jpg']
    img:setWrap("repeat", "repeat")
    local eia = img:getWidth() / img:getHeight()
    local vertices = {
        {0,0,     0,0,                255,255,255}, --topleft
        {WIDTH,0,   0 + 1/eia,0,        255,255,255}, --topright
        {WIDTH,HEIGHT, 0 + 1/eia,1,        255,255,255}, --bottomright
        {0,HEIGHT,   0,1,                255,255,255} --bottomleft
    }
    earth = love.graphics.newMesh(vertices)
    earth:setTexture(img)
  end

  self.camera:move(-g.getWidth() / 2, -g.getHeight() / 2)
  g.setBackgroundColor(150, 150, 150)
end

local time = 0
function Sphere:update(dt)
  g.setWireframe(love.keyboard.isDown('space'))

  if not love.keyboard.isDown('p') then
    time = time + dt / 3
    sphere_shader:send('time', {time, time / 2})

    sphere_mesh:setVertices(generateSphereVertices(WIDTH / 2, NUM_VERTS, NUM_VERTS, time, time / 2))
    -- reference_mesh:setVertices(generateFanVertices(50, WIDTH / 2 / math.cos(math.pi / 50), time, 0))
  end
end

function Sphere:draw()
  self.camera:set()

  g.setShader(normal_sphere_shader)
  normal_sphere_shader:send('texture_size', {WIDTH, HEIGHT})
  g.rectangle('fill', -g.getWidth() / 2, -g.getHeight() / 2, WIDTH, HEIGHT)
  g.setShader()

  g.draw(normal_sphere, WIDTH * 2, -HEIGHT * 2, 0, 1, 1, WIDTH / 2, HEIGHT / 2)

  do
    local mx, my = love.mouse.getPosition()

    normal_map_shader:send('normals', normal_sphere)
    normal_map_shader:send('l_color', {1, 0.8, 0.6, 1})
    g.setColor(153, 153, 255, 127)
    normal_map_shader:send('l_pos', {mx / g.getWidth(), my / g.getHeight(), 0.075})
    g.setShader(normal_map_shader)
    g.draw(sphere_mesh, 0, HEIGHT * 2)
    g.setShader()
    g.setColor(255, 255, 255)
    g.printf("MESH + NORMALS", 0 - WIDTH / 2, HEIGHT + HEIGHT / 8, WIDTH, 'center')
  end

  g.draw(sphere_mesh, 0, -HEIGHT * 2)
  g.printf("MESH", 0 - WIDTH / 2, -HEIGHT * 3 + HEIGHT / 3, WIDTH, 'center')

  g.printf("SHADER", 0 - WIDTH / 2, -HEIGHT + HEIGHT / 3, WIDTH, 'center')
  g.setShader(sphere_shader)
  sphere_shader:send('image_aspect_ratio', 1)
  g.draw(texture, 0, 0, 0, 1, 1, WIDTH / 2, HEIGHT / 2)
  do
    local img = game.preloaded_images['earth.jpg']
    sphere_shader:send('image_aspect_ratio', img:getWidth() / img:getHeight())
    g.draw(earth, -WIDTH * 2, 0, 0, 1, 1, WIDTH / 2, HEIGHT / 2)
  end
  g.setShader()

  -- do
  --   local time = love.timer.getTime()

  --   g.push()
  --   g.translate(-WIDTH * 2, -HEIGHT * 2)
  --   local pi, cos, sin = math.pi, math.cos, math.sin
  --   local slices, stacks = 10, 10
  --   local radius = WIDTH / 2

  --   for t=0,stacks do
  --     local theta = (t - stacks / 2) / stacks * pi

  --     for p=0,slices do
  --       local phi = (p) / slices * pi

  --       -- g.setColor(255, 255, 255)

  --       do
  --         g.push()
  --         g.translate(-WIDTH, 0)
  --         local x, y = radius * math.cos(phi) * math.cos(theta), radius * math.sin(theta)
  --         local z = radius - math.sqrt(x * x + y * y)
  --         x, y = radius * math.cos(phi + time) * math.cos(theta), radius * math.sin(theta)
  --         -- g.setColor(0, 0, 255)
  --         g.setColor(hsl2rgb(z / radius, 1, 0.5))
  --         g.points(x, y)
  --         g.pop()
  --       end

  --       do
  --         -- local phi = phi + time
  --         g.push()
  --         g.translate(0, HEIGHT)
  --         local x, y = radius * math.cos(phi + math.pi) * math.cos(theta), radius * math.sin(theta)
  --         local z = radius - math.sqrt(x * x + y * y)
  --         -- g.setColor(0, 0, 255)
  --         g.setColor(hsl2rgb(z / radius, 1, 0.5))
  --         g.points(x, y)
  --         g.pop()
  --       end

  --       do
  --         local phi = phi + time
  --         g.push()
  --         g.translate(0, -HEIGHT)
  --         local x, y = radius * math.cos(phi) * math.cos(theta - math.pi / 2), radius * math.sin(phi) * math.sin(theta)
  --         g.setColor(hsl2rgb(math.atan2(y, x) / math.pi / 2, 1, 0.5))
  --         g.points(x, y)
  --         g.pop()
  --       end
  --     end
  --   end
  --   g.pop()
  --   g.setColor(255, 255, 255)
  -- end

  -- do
  --   warp_shader:send('normals', normal_sphere)
  --   g.setShader(warp_shader)

  --   g.draw(texture, -WIDTH * 2, -HEIGHT * 2, 0, 1, 1, WIDTH / 2, HEIGHT / 2)
  --   g.draw(mesh, 0, HEIGHT * 2)

  --   g.setShader()
  -- end

  self.camera:unset()
end

function Sphere:mousepressed(x, y, button, isTouch)
end

function Sphere:mousereleased(x, y, button, isTouch)
end

function Sphere:keypressed(key, scancode, isrepeat)
end

function Sphere:keyreleased(key, scancode)
end

function Sphere:gamepadpressed(joystick, button)
end

function Sphere:gamepadreleased(joystick, button)
end

function Sphere:focus(has_focus)
end

function Sphere:exitedState()
  self.camera = nil
end

return Sphere
