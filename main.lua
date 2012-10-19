love.filesystem.load('requirements.lua')()

function love.load()
  game = Game:new()
end

function love.update(dt)
  game:update(dt)
end

function love.mousepressed(x, y, button)
  game:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  game:mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
  game:keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
  game:keyreleased(key, unicode)
end

function love.joystickpressed(joystick, button)
  game:joystickpressed(joystick, button)
end

function love.joystickreleased(joystick, button)
  game:joystickreleased(joystick, button)
end

function love.draw()
  game:render()
end

function love.focus(has_focus)
  game:focus(has_focus)
end

function love.quit()
  game:quit()
end
