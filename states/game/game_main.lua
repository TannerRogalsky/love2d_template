local Main = Game:addState('Main')

function Main:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  g.setFont(self.preloaded_fonts["04b03_16"])
end

function Main:update(dt)
end

function Main:draw()
  self.camera:set()

  self.camera:unset()
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
end

function Main:keypressed(key, scancode, isrepeat)
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
