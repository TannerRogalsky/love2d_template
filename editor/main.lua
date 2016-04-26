local g = love.graphics
local binser = require('lib.binser.binser')

local object_types = {
  'start',
  'obstacle',
  'end'
}

local object_data = {
  start = {
    color = {255, 0, 0},
  },
  obstacle = {
    color = {0, 0, 0},
  },
  ['end'] = {
    color = {0, 255, 0},
  },
}

local function saveData(data)
  love.filesystem.createDirectory('levels')
  if current_save_file == #save_files then
    love.filesystem.write('levels/level' .. current_save_file .. '.dat', binser.serialize(data))
    save_files = love.filesystem.getDirectoryItems('levels')
    table.insert(save_files, 'new')
  else
    love.filesystem.write('levels/' .. save_files[current_save_file], binser.serialize(data))
  end
end

local function loadData(filename)
  objects = binser.deserialize(love.filesystem.read('levels/' .. filename))[1]
end

function love.load(args)
  current_radius = 25
  current_object_type = 1
  objects = {}

  save_files = love.filesystem.getDirectoryItems('levels')
  table.insert(save_files, 'new')
  current_save_file = #save_files
end

function love.update(dt)
end

function love.draw()
  g.setColor(255, 255, 255)
  g.rectangle('fill', 0, 0, 500, 500)

  for _,object in ipairs(objects) do
    local data = object_data[object.type]
    g.setColor(data.color)
    g.circle('fill', object.x, object.y, object.radius)
  end

  local data = object_data[object_types[current_object_type]]
  local x, y = love.mouse.getPosition()
  g.setColor(data.color)
  g.circle('fill', x, y, current_radius)


  for i,save_file in ipairs(save_files) do
    if i == current_save_file then
      g.setColor(0, 255, 255)
    else
      g.setColor(255, 255, 255)
    end
    g.print(save_file, 500, (i - 1) * 20)
  end
end

function love.mousepressed(x, y, button, isTouch)
  table.insert(objects, {
    type = object_types[current_object_type],
    x = x,
    y = y,
    radius = current_radius
  })
end

function love.mousereleased(x, y, button, isTouch)
end

function love.wheelmoved(x, y)
end

local keys = {
  pressed = {
    ['-'] = function() current_radius = current_radius - 1 end,
    ['='] = function() current_radius = current_radius + 1 end,
    ['up'] = function() current_save_file = current_save_file - 1 end,
    ['down'] = function() current_save_file = current_save_file + 1 end,
    ['tab'] = function() current_object_type = (current_object_type % #object_types) + 1 end,
    ['s'] = function() saveData(objects) end,
    ['l'] = function() loadData(save_files[current_save_file]) end,
    ['o'] = function() love.system.openURL("file://"..love.filesystem.getSaveDirectory()) end,
  }
}
function love.keypressed(key, scancode, isrepeat)
  if keys.pressed[key] then
    keys.pressed[key]()
  end

  if key == "escape" then
    love.event.push("quit")
  end
end

function love.keyreleased(key, scancode)
end

function love.joystickpressed(joystick, button)
end

function love.joystickreleased(joystick, button)
end

function love.gamepadaxis(joystick, axis, value)
end

function love.gamepadpressed(joystick, button)
end

function love.gamepadreleased(joystick, button)
end

function love.joystickadded(joystick)
end

function love.joystickremoved(joystick)
end

function love.joystickaxis(joystick, axis, value)
end

function love.joystickhat(joystick, hat, direction)
end


function love.textinput(text)
end

function love.focus(has_focus)
end

function love.quit()
end
