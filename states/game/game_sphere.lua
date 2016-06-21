local Sphere = Game:addState('Sphere')
local intervalIterator = require('factories.interval_iterator')
local WIDTH, HEIGHT = 100, 100

local function generateVertices(sides, radius)
  assert(type(sides) == 'number' and sides >= 3)

  local vertices = {}
  local tau = math.pi * 2
  for i, phi in intervalIterator(sides) do
    local px, py = math.cos(phi), math.sin(phi)
    local x, y = radius * px, radius * py
    -- local u, v = (x + WIDTH / 2) / WIDTH, (y + HEIGHT / 2) / HEIGHT
    local r = math.sqrt(px * px + py * py)
    local d = math.asin(r) * 2
    local p2x, p2y = px * d, py * d
    local u = math.mod(p2x / tau + 0.5, 1)
    local v = math.mod(p2y / tau + 0.5, 1)
    local vertex = {
      x, y,
      u, v
    }
    table.insert(vertices, vertex)
  end

  return vertices
end

local function generateReferenceVertices(sides, radius, ox, oy)
  assert(type(sides) == 'number' and sides >= 3)

  local vertices = {}
  for i, phi in intervalIterator(sides) do
    local x, y = radius * math.cos(phi), radius * math.sin(phi)
    local u, v = (x + WIDTH / 2) / WIDTH, (y + HEIGHT / 2) / HEIGHT
    u, v = (u + ox) % 1, (v + oy) % 1
    local vertex = {x, y, u, v}
    table.insert(vertices, vertex)
  end

  return vertices
end

local function generateFanVertices(sides, radius, ox, oy)
  assert(type(sides) == 'number' and sides >= 3)

  local t = (2 * math.pi) / sides

  local vertices = {{0, 0, (0.5 + ox) % 1, (0.5 + oy) % 1}}
  -- local vertices = {{0, 0, 0.5 + ox, 0.5 + oy}}
  for i=0,sides do
    local x, y = radius * math.cos(i * t), radius * math.sin(i * t)
    local u, v = (x + WIDTH / 2) / WIDTH, (y + HEIGHT / 2) / HEIGHT
    u, v = (u + ox) % 1, (v + oy) % 1

    local vertex = {x, y, u + ox, v + oy}
    table.insert(vertices, vertex)
  end

  return vertices
end

local function insertVertices(vertices, vert, ...)
  if vert then
    table.insert(vertices, vert)
    insertVertices(vertices, ...)
  end
end

local function createSphereVertex(radius, theta, phi, ox, oy)
  local x, y = radius * math.cos(phi) * math.cos(theta), radius * math.sin(theta)
  local z = radius - math.sqrt(x * x + y * y)
  -- local z = radius * math.sin(phi) * math.cos(phi)
  -- local x1 = radius * math.cos(phi) * math.sin(theta - math.pi / 2)
  -- local y1 = radius * math.sin(phi) * math.sin(theta)
  -- local z1 = radius * math.cos(theta)
  -- print(x1, y1, z1)
  -- local u, v = (x + WIDTH / 2) / WIDTH, (y + HEIGHT / 2) / HEIGHT
  -- local u = ((0.25 + (math.acos(x / radius) / math.pi)) * 2 + ox) % 1
  -- local u = (0.5 + (math.atan(x / radius) / math.pi) + ox) % 1
  -- local u = 0.5 + (math.atan2(z, x) / (math.pi * 2))
  local u = 1 - (math.atan2(z, x) / (math.pi * 2))
  local v = 0.5 + (math.asin(y / radius) / math.pi)
  u, v = (u + ox) % 1, (v + oy) % 1
  -- local v = math.sin(theta) / math.pi + 0.5
  -- print(math.round(x), math.round(y), math.deg(phi), math.deg(theta), u, v)
  -- print(math.round(x), math.round(y), math.round(z), u, v)
  return {x, y, u, v}
end

local function generateSphereVertices(radius, slices, stacks, ox, oy)
  local pi, cos, sin = math.pi, math.cos, math.sin
  local vertices = {}

  for t=1,stacks do
    local s = t - stacks / 2
    local theta1 = (s - 1) / stacks * pi
    local theta2 = s / stacks * pi
    -- print('theta', math.deg(theta1), math.deg(theta2))

    for p=1,slices do
      local phi1 = (p - 1) / slices * pi
      local phi2 = p / slices * pi
      -- print('phi', math.deg(phi1), math.deg(phi2))

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

  -- print(#vertices, #vertices / 3)
  return vertices
end

function Sphere:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  local noise = love.math.noise
  local image_data = love.image.newImageData(WIDTH, HEIGHT)
  do
    local pi, cos, sin = math.pi, math.cos, math.sin
    local random = love.math.random
    -- local x, y = random(0, 100), random(0, 100)
    local x, y = 0, 0
    local x1, y1, x2, y2 = x, y, x + WIDTH / 20, y + HEIGHT / 20
    image_data:mapPixel(function(x, y)
      x, y = x - 1, y - 1
      local s = x / WIDTH
      local t = y / HEIGHT
      local dx = x2 - x1
      local dy = y2 - y1

      local nx = x1+cos(s*2*pi)*dx/(2*pi)
      local ny = y1+cos(t*2*pi)*dy/(2*pi)
      local nz = x1+sin(s*2*pi)*dx/(2*pi)
      local nw = y1+sin(t*2*pi)*dy/(2*pi)

      local p = noise(nx,ny,nz,nw)
      return p * 255, p * 255, p * 255
    end)
  end
  texture = g.newImage(image_data)

  sphere_vertices = generateSphereVertices(WIDTH / 2, 40, 40, 0, 0)
  sphere_mesh = g.newMesh(sphere_vertices, 'triangles')
  -- sphere_mesh:setTexture(texture)
  -- game.preloaded_images['earth.jpg']:setWrap('repeat')
  sphere_mesh:setTexture(game.preloaded_images['earth.jpg'])

  -- local normal_image_data = love.image.newImageData(WIDTH, HEIGHT)
  -- normal_image_data:mapPixel(function(x, y)
  --   local ratio = WIDTH / HEIGHT;
  --   local u, v = x / WIDTH, y / HEIGHT

  --   vec3 n = vec3(uv, sqrt(1. - clamp(dot(uv, uv), 0., 1.)));

  --   vec3 color = 0.5 + 0.5 * n;
  --   color = mix(vec3(0.5), color, smoothstep(1.01, 1., dot(uv, uv)));
  --   fragColor = vec4(color, 1.0);
  -- end)

  normal_sphere_shader = g.newShader('shaders/normal_sphere.glsl')
  normal_sphere_shader:send('texture_size', {WIDTH, HEIGHT})
  normal_sphere = g.newCanvas(WIDTH, HEIGHT)
  g.setCanvas(normal_sphere)
    g.setShader(normal_sphere_shader)
    g.rectangle('fill', 0, 0, WIDTH, HEIGHT)
    g.setShader()
  g.setCanvas()

  warp_shader = g.newShader('shaders/warp.glsl')

  normal_map_shader = g.newShader('shaders/normal_map.glsl')

  local num_verts = 50
  mesh = g.newMesh(generateVertices(num_verts, WIDTH / 2 / math.cos(math.pi / num_verts)))
  mesh:setTexture(texture)

  reference_mesh = g.newMesh(generateFanVertices(num_verts, WIDTH / 2 / math.cos(math.pi / num_verts), 0, 0), 'fan')
  reference_mesh:setTexture(game.preloaded_images['earth.jpg'])

  sphere_shader = g.newShader('shaders/sphere.glsl')
  sphere_shader:send('resolution', 2)

  self.camera:move(-g.getWidth() / 2, -g.getHeight() / 2)
  g.setBackgroundColor(150, 150, 150)
end

local time = 0
function Sphere:update(dt)
  g.setWireframe(love.keyboard.isDown('space'))

  if not love.keyboard.isDown('p') then
    time = time + dt / 3
    sphere_shader:send('time', {time, 0})

    sphere_mesh:setVertices(generateSphereVertices(WIDTH / 2, 40, 40, time, 0))
    reference_mesh:setVertices(generateFanVertices(50, WIDTH / 2 / math.cos(math.pi / 50), time, 0))
  end
end

function Sphere:draw()
  self.camera:set()

  g.setShader(normal_sphere_shader)
  normal_sphere_shader:send('texture_size', {WIDTH, HEIGHT})
  g.rectangle('fill', -g.getWidth() / 2, -g.getHeight() / 2, WIDTH, HEIGHT)
  g.setShader()

  g.draw(texture, 0, 0, 0, 1, 1, WIDTH / 2, HEIGHT / 2)
  g.draw(mesh, WIDTH * 2, 0)
  g.draw(reference_mesh, WIDTH * 2, HEIGHT * 2)
  g.draw(normal_sphere, 0, -HEIGHT * 2, 0, 1, 1, WIDTH / 2, HEIGHT / 2)

  do
    local mx, my = love.mouse.getPosition()

    normal_map_shader:send('normals', normal_sphere)
    normal_map_shader:send('l_color', {1, 0.8, 0.6, 1})
    g.setColor(153, 153, 255, 127)
    normal_map_shader:send('l_pos', {mx / g.getWidth(), my / g.getHeight(), 0.075})
    g.setShader(normal_map_shader)
    g.draw(mesh, WIDTH * 2, -HEIGHT * 2)
    g.draw(sphere_mesh, -WIDTH * 2, HEIGHT * 2)
    g.draw(reference_mesh, 0, HEIGHT * 2)
    g.setShader()
    g.setColor(255, 255, 255)
  end

  g.draw(sphere_mesh, -WIDTH * 2, -HEIGHT * 2)

  do
    local time = love.timer.getTime()

    g.push()
    g.translate(-WIDTH * 2, -HEIGHT * 2)
    local pi, cos, sin = math.pi, math.cos, math.sin
    local slices, stacks = 10, 10
    local radius = WIDTH / 2

    for t=0,stacks do
      local theta = (t - stacks / 2) / stacks * pi

      for p=0,slices do
        local phi = (p) / slices * pi

        -- g.setColor(255, 255, 255)

        do
          g.push()
          g.translate(-WIDTH, 0)
          local x, y = radius * math.cos(phi) * math.cos(theta), radius * math.sin(theta)
          local z = radius - math.sqrt(x * x + y * y)
          x, y = radius * math.cos(phi + time) * math.cos(theta), radius * math.sin(theta)
          -- g.setColor(0, 0, 255)
          g.setColor(hsl2rgb(z / radius, 1, 0.5))
          g.points(x, y)
          g.pop()
        end

        do
          -- local phi = phi + time
          g.push()
          g.translate(0, HEIGHT)
          local x, y = radius * math.cos(phi + math.pi) * math.cos(theta), radius * math.sin(theta)
          local z = radius - math.sqrt(x * x + y * y)
          -- g.setColor(0, 0, 255)
          g.setColor(hsl2rgb(z / radius, 1, 0.5))
          g.points(x, y)
          g.pop()
        end

        do
          local phi = phi + time
          g.push()
          g.translate(0, -HEIGHT)
          g.setColor(255, 0, 0)
          g.points(radius * math.cos(phi) * math.cos(theta - math.pi / 2), radius * math.sin(phi) * math.sin(theta))
          g.pop()
        end
      end
    end
    g.pop()
    g.setColor(255, 255, 255)
  end

  -- do
  --   warp_shader:send('normals', normal_sphere)
  --   g.setShader(warp_shader)

  --   g.draw(texture, -WIDTH * 2, -HEIGHT * 2, 0, 1, 1, WIDTH / 2, HEIGHT / 2)
  --   g.draw(mesh, 0, HEIGHT * 2)

  --   g.setShader()
  -- end

  g.setShader(sphere_shader)
  sphere_shader:send('width', 1)
  g.draw(texture, -WIDTH * 2, 0, 0, 1, 1, WIDTH / 2, HEIGHT / 2)
  sphere_shader:send('width', 4)
  g.draw(game.preloaded_images['earth.jpg'], -WIDTH * 4, 0, 0, 0.25, 0.25, WIDTH * 2, HEIGHT * 2)
  g.setShader()

  self.camera:unset()
end

function Sphere:mousepressed(x, y, button, isTouch)
end

function Sphere:mousereleased(x, y, button, isTouch)
end

function Sphere:keypressed(key, scancode, isrepeat)
  if key == 'r' then
    sphere_mesh:setVertices(generateSphereVertices(WIDTH / 2, 40, 40, 0, 0))
  end
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
