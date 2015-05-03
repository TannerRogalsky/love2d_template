local Game = class('Game', Base):include(Stateful)

function Game:initialize(args)
  Base.initialize(self)

  for k,v in pairs(args) do
    self[k] = v
  end

  LovePixlr.bind(32, 32, "nearest")
  love.graphics.point = function(x, y)
    love.graphics.rectangle("fill", x, y, 1, 1)
  end

  -- sharecart_data = self:load_sharecart_data()
  -- self:save_sharecart_data(sharecart_data)

  self:gotoState("Loading")
end

local sharecart_keys = {
  "MapX",
  "MapY",
  "Misc0",
  "Misc1",
  "Misc2",
  "Misc3",
  "PlayerName",
  "Switch0",
  "Switch1",
  "Switch2",
  "Switch3",
  "Switch4",
  "Switch5",
  "Switch6",
  "Switch7",
}

function Game:load_sharecart_data()
  local data = {}
  local file = io.open("../dat/o_o.ini")
  if not file then return end

  for line in file:lines() do
    local key, value = line:match("(%w+)=(.*)")
    if key and value then
      if value:upper() == "TRUE" then
        data[key] = true
      elseif value:upper() == "FALSE" then
        data[key] = false
      else
        data[key] = tonumber(value) or value
      end
    end
  end
  file:close()
  return data
end

function Game:save_sharecart_data(data)
  local file = io.open("../dat/o_o.ini", "w+")
  local output = "[Main]"
  for _, key in ipairs(sharecart_keys) do
    local value = data[key]
    output = output .. string.format("\n%s=%s", key, value)
  end
  file:write(output)
  file:close()
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
