love.filesystem.load('requirements.lua')()

function love.load(args)
  local k_args = {}
  for _,arg in ipairs(args) do
    local key, value = arg:match("(.*)=(.*)")
    key, value = key or arg, value or true
    k_args[key] = value
  end
  game = Game:new(k_args)
end

function love.update(dt)
  lovebird.update()
  game:update(dt)
  tween.update(dt)
  loveframes.update(dt)
end

function love.mousepressed(x, y, button)
  game:mousepressed(x, y, button)
  loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  game:mousereleased(x, y, button)
  loveframes.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
  game:keypressed(key, unicode)
  loveframes.keypressed(key, unicode)

  if key == "escape" then
    love.event.push("quit")
  end
end

function love.keyreleased(key, unicode)
  game:keyreleased(key, unicode)
  loveframes.keyreleased(key, unicode)
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
  loveframes.textinput(text)
end

function love.draw()
  game:draw()
  loveframes.draw()
end

function love.focus(has_focus)
  game:focus(has_focus)
end

function love.quit()
  game:quit()
end
