local Main = Game:addState('Main')
local buildMap = require('pure.build_map')
local instantiateInteratables = require('pure.instantiate_interactables')
local createPlayerMoveTween = require('pure.create_player_move_tween')

local function numActiveFans(fans)
  local num_active_fans = 0
  for i,fan in ipairs(fans) do
    if fan.active then num_active_fans = num_active_fans + 1 end
  end
  return num_active_fans
end

function Main:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  map_data = require('levels.template')
  local map = buildMap(map_data)
  tileset, layers, interactables, grid, paths = map.tileset, map.layers, map.interactives, map.grid, map.paths
  player, fans = instantiateInteratables(interactables)

  sprites = require('images.sprites')

  -- g.setBackgroundColor(150, 150, 150)
  -- self.camera:move(-g.getWidth() / 2, -g.getHeight() / 2)
  -- self.camera:scale(1, 1)
end

function Main:update(dt)
  for i,fan in ipairs(fans) do
    fan:update(dt)
  end

  if player_move_tween then
    if player_move_tween:update(dt) then player_move_tween = nil end
  end

  if not player_move_tween then
    player_move_tween = createPlayerMoveTween(grid, paths, fans, player)
  end
  self.camera:setPosition(math.floor(player.x - g.getWidth() / 2 + 25), math.floor(player.y - g.getHeight() / 2 + 25))
end

function Main:draw()
  self.camera:set()

  g.setColor(255, 255, 255)
  g.draw(layers[1], 0, 0)

  player:draw()
  for i,fan in ipairs(fans) do
    fan:draw()
  end

  g.setColor(255, 255, 255)
  g.draw(layers[2], 0, 0)

  self.camera:unset()

  g.setBlendMode('add')
  g.setColor((1 - numActiveFans(fans) / #fans) * 100, 0, 0)
  g.rectangle('fill', 0, 0, g.getWidth(), g.getHeight())
  g.setBlendMode('alpha')

  -- g.setColor(0, 255, 0)
  -- g.print(love.timer.getFPS(), 0, 0)
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
end

function Main:keypressed(key, scancode, isrepeat)
  if not player_move_tween then
    player_move_tween = createPlayerMoveTween(grid, paths, fans, player)
  end

  if key == 'space' then
    local x, y = grid:to_grid(player.x, player.y)
    local tgx, tgy = x + math.cos(player.orientation), y + math.sin(player.orientation)
    local tx, ty = grid:to_pixel(tgx, tgy)
    local touched_fan
    for i,fan in ipairs(fans) do
      if fan.x == tx and fan.y == ty then
        touched_fan = fan
        break
      end
    end

    if touched_fan then
      touched_fan:toggle_active()
    end
  end
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
