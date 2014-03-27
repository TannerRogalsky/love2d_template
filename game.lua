local Game = class('Game', Base):include(Stateful)

function Game:initialize(args)
  Base.initialize(self)

  for k,v in pairs(args) do
    self[k] = v
  end

  local Camera = require 'lib/camera'
  self.camera = Camera:new()

  self.default_font = g.newFont(16)
  g.setFont(self.default_font)

  self:gotoState("Loading")
end

function Game:update(dt)
end

function Game:draw()
end

function Game:mousepressed(x, y, button)
end

function Game:mousereleased(x, y, button)
end

function Game:keypressed(key, unicode)
end

function Game:keyreleased(key, unicode)
end

function Game:joystickpressed(joystick, button)
end

function Game:joystickreleased(joystick, button)
end

function Game:focus(has_focus)
end

function Game:quit()
end

return Game
