local g = love.graphics
local binser = require('lib.binser.binser')
package.path = './?/init.lua;' .. package.path
local SUIT = require('lib.SUIT')

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

local function populateSaveFiles()
  save_files = {}
  for i,filename in ipairs(love.filesystem.getDirectoryItems('levels')) do
    if filename:match('(.*).dat$') ~= nil then
      table.insert(save_files, filename)
    end
  end
end

local function saveData(data)
  love.filesystem.createDirectory('levels')
  if #level_data.objects > 0 then
    love.filesystem.write('levels/' .. save_files[current_save_file], binser.serialize(data))
  end
end

local function loadData(filename)
  level_data = binser.deserialize(love.filesystem.read('levels/' .. filename))[1]
end

function love.load(args)
  current_radius = 25
  current_object_type = 1
  level_data = {
    seed = {text = love.math.random()},
    objects = {}
  }

  new_level_input = {text = ''}
  populateSaveFiles()
  if #save_files > 0 then
    current_save_file = #save_files
    loadData(save_files[current_save_file])
    new_level = false
  else
    new_level = true
  end
end

function love.update(dt)
  SUIT.layout:reset(510, 10)

  for i,file in ipairs(save_files) do
    if SUIT.Button(file, SUIT.layout:row(200, 30)).hit then
      saveData(level_data)
      loadData(file)
      current_save_file = i
    end
  end

  if new_level then
    if SUIT.Input(new_level_input, SUIT.layout:row(200, 30)).submitted then
      saveData(level_data)
      level_data = {
        seed = {text = love.math.random()},
        objects = {}
      }
      new_level = false
      table.insert(save_files, new_level_input.text)
      new_level_input.text = ''
      current_save_file = #save_files
    end
  elseif SUIT.Button("New Level", SUIT.layout:row(200, 30)).hit then
    new_level = true
  end
end

function love.draw()
  g.setColor(255, 255, 255)
  g.rectangle('fill', 0, 0, 500, 500)

  for _,object in ipairs(level_data.objects) do
    local data = object_data[object.type]
    g.setColor(data.color)
    g.circle('fill', object.x, object.y, object.radius)
  end

  local data = object_data[object_types[current_object_type]]
  local x, y = love.mouse.getPosition()
  if x > current_radius and y > current_radius and
    x < 500 - current_radius and y < 500 - current_radius then
    g.setColor(data.color)
    g.circle('fill', x, y, current_radius)
  end

  SUIT.draw()
end

function love.mousepressed(x, y, button, isTouch)
  if x > current_radius and y > current_radius and
    x < 500 - current_radius and y < 500 - current_radius then
    table.insert(level_data.objects, {
      type = object_types[current_object_type],
      x = x,
      y = y,
      radius = current_radius
    })
  end
end

function love.mousereleased(x, y, button, isTouch)
end

function love.wheelmoved(x, y)
end

local keys = {
  pressed = {
    ['-'] = function() current_radius = current_radius - 1 end,
    ['='] = function() current_radius = current_radius + 1 end,
    -- ['up'] = function() current_save_file = current_save_file - 1 end,
    -- ['down'] = function() current_save_file = current_save_file + 1 end,
    ['tab'] = function() current_object_type = (current_object_type % #object_types) + 1 end,
    -- ['s'] = function() saveData(objects) end,
    -- ['l'] = function() loadData(save_files[current_save_file]) end,
    -- ['o'] = function() love.system.openURL("file://"..love.filesystem.getSaveDirectory()) end,
  }
}
function love.keypressed(key, scancode, isrepeat)
  SUIT.keypressed(key, scancode, isrepeat)

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
  SUIT.textinput(text)
end

function love.focus(has_focus)
end

function love.quit()
  saveData(level_data)
end
