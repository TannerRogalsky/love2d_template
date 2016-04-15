local Game = class('Game', Base):include(Stateful)

function Game:initialize(args)
  Base.initialize(self)

  LovePixlr.bind(64, 64, "nearest")
  do
    local old_points = g.points
    g.points = function(...)
      g.push()
      g.translate(0.5, 0.5)
      old_points(...)
      g.pop()
    end
  end

  for k,v in pairs(args) do
    self[k] = v
  end

  self:gotoState("Loading")
end

function Game:update(dt)
end

function Game:draw()
end

function Game:mousepressed(x, y, button, isTouch)
end

function Game:mousereleased(x, y, button, isTouch)
end

function Game:wheelmoved(x, y)
end

function Game:keypressed(key, scancode, isrepeat)
end

function Game:keyreleased(key, scancode)
end

function Game:joystickpressed(joystick, button)
end

function Game:joystickreleased(joystick, button)
end

function Game:gamepadaxis(joystick, axis, value)
end

function Game:gamepadpressed(joystick, button)
end

function Game:gamepadreleased(joystick, button)
end

function Game:joystickadded(joystick)
end

function Game:joystickremoved(joystick)
end

function Game:joystickaxis(joystick, axis, value)
end

function Game:joystickhat(joystick, hat, direction)
end

function Game:textinput(text)
end

function Game:focus(has_focus)
end

function Game:quit()
end

return Game
