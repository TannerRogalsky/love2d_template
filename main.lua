love.filesystem.load('requirements.lua')()

function love.load(args)
  local k_args = {}
  for _,arg in ipairs(args) do
    local key, value = arg:match("(.*)=(.*)")
    key, value = key or arg, value or true
    k_args[key] = value
  end

  LovePixlr.bind(1280, 720)

  game = Game:new(k_args)
end

function love.update(dt)
  game:update(dt)
end

function love.mousepressed(x, y, button, isTouch)
  game:mousepressed(x, y, button, isTouch)
end

function love.mousereleased(x, y, button, isTouch)
  game:mousereleased(x, y, button, isTouch)
end

function love.wheelmoved(x, y)
  game:wheelmoved(x, y)
end

function love.keypressed(key, scancode, isrepeat)
  game:keypressed(key, scancode, isrepeat)

  if key == "escape" then
    love.event.push("quit")
  end
end

function love.keyreleased(key, scancode)
  game:keyreleased(key, scancode)
end

function love.joystickpressed(joystick, button)
  game:joystickpressed(joystick, button)
end

function love.joystickreleased(joystick, button)
  game:joystickreleased(joystick, button)
end

function love.gamepadaxis(joystick, axis, value)
  game:gamepadaxis(joystick, axis, value)
end

function love.gamepadpressed(joystick, button)
  game:gamepadpressed(joystick, button)
end

function love.gamepadreleased(joystick, button)
  game:gamepadreleased(joystick, button)
end

function love.joystickadded(joystick)
  game:joystickadded(joystick)
end

function love.joystickremoved(joystick)
  game:joystickremoved(joystick)
end

function love.joystickaxis(joystick, axis, value)
  game:joystickaxis(joystick, axis, value)
end

function love.joystickhat(joystick, hat, direction)
  game:joystickhat(joystick, hat, direction)
end


function love.textinput(text)
  game:textinput(text)
end

function love.draw()
  game:draw()
end

function love.focus(has_focus)
  game:focus(has_focus)
end

function love.quit()
  game:quit()
end
