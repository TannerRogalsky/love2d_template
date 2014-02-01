Game = class('Game', Base):include(Stateful)

function Game:initialize()
  Base.initialize(self)

  local Camera = require 'lib/camera'
  self.camera = Camera:new()

  self:gotoState("Loading")
end

function Game:update(dt)
end

function Game:render()
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
