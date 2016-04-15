local Main = Game:addState('Main')

local function updateExplosions(explosions, dt)
  for k,v in pairs(explosions) do
    v:update(dt)

    if v.num == 0 then
      explosions[k] = nil
    end
  end
end

function Main:enteredState()
  g.setFont(self.preloaded_fonts["04b03_8"])

  local Camera = require("lib/camera")
  self.camera = Camera:new()

  self.pixel_shader = g.newShader('shaders/pixel.glsl')
  local vertices = {
    {-10, -10, 0, 0},
    {-10, 10, 0.5, 1},
    {10, 10, 1, 1},
    {10, -10, 1, 0},
  }

  self.mesh = g.newMesh(vertices)
  self.mesh:setTexture(self.preloaded_images['pixels.png'])
  self.mesh_pos = {
    x = 32,
    y = 32
  }

  self.sr_mesh = SR.newMesh(vertices)
  self.sr_mesh:setTexture(self.preloaded_images['pixels.png'])

  self.explosions = {}

  -- g.setLineStyle('rough')
  -- g.setLineJoin('none')
  g.setPointSize(g.getHeight() / 64)

  g.setBackgroundColor(255, 0, 255)
end

function Main:update(dt)
  updateExplosions(self.explosions, dt)
end

function Main:draw()
  self.camera:set()

  g.setColor(255, 0, 0)
  local points = {}
  for x=0,64,2 do
    for y=0,64,2 do
      table.insert(points, x)
      table.insert(points, y)
    end
  end
  -- g.points(points)
  g.setColor(255, 255, 255)
  g.rectangle('line', self.mesh_pos.x - 10, self.mesh_pos.y - 10 - 20, 20, 20)
  g.rectangle('line', self.mesh_pos.x - 10, self.mesh_pos.y - 10, 20, 20)
  g.rectangle('line', self.mesh_pos.x - 10, self.mesh_pos.y - 10 + 20, 20, 20)
  g.rectangle('line', self.mesh_pos.x - 10 - 20, self.mesh_pos.y - 10 + 20, 20, 20)
  g.rectangle('line', self.mesh_pos.x - 10 + 20, self.mesh_pos.y - 10 + 20, 20, 20)

  g.draw(self.preloaded_images['pixels.png'], self.mesh_pos.x, self.mesh_pos.y - 20, 0, 1, 1, 10, 10)
  g.draw(self.mesh, self.mesh_pos.x, self.mesh_pos.y)
  SR.draw(self.sr_mesh, self.mesh_pos.x, self.mesh_pos.y + 20)

  g.draw(self.mesh, self.mesh_pos.x - 20, self.mesh_pos.y + 20)
  g.draw(self.mesh, self.mesh_pos.x + 20, self.mesh_pos.y + 20)

  -- g.draw(self.preloaded_images['tiles.jpg'], 25, 25, 0, 0.1)
  -- SR.draw(self.preloaded_images['tiles.jpg'], 0, 0, 0, 0.1)

  SR.triangle('line', 10, 10, 15, 15, 2, 25)

  SR.triangle('line', 50, 2, 52, 10, 45, 4)
  SR.triangle('fill', 50, 2, 52, 10, 45, 4)

  -- SR.triangle('line', 20, 5, 30, 6, 25, 2)
  -- SR.triangle('line', 20, 9, 30, 8, 25, 12)

  -- g.setColor(255, 255, 255)
  -- SR.line(2, 40, 2, 48)
  -- SR.line(4, 45, 10, 45)
  -- g.points(3, 50)

  -- for k,v in pairs(self.explosions) do
  --   v:draw(0, 0)
  -- end

  -- g.print('test', 0, 0)

  self.camera:unset()
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
  local x, y = love.mouse.getPosition()
  table.insert(self.explosions, PixelExplosion:new(x, y, 10))
end

function Main:keypressed(key, scancode, isrepeat)
  if key == 'left' then self.mesh_pos.x = self.mesh_pos.x - 1 end
  if key == 'right' then self.mesh_pos.x = self.mesh_pos.x + 1 end
end

function Main:keyreleased(key, scancode)
end

function Main:gamepadpressed(joystick, button)
end

function Main:gamepadreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
  self.camera = nil
end

return Main
