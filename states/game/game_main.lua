local Main = Game:addState('Main')
local instantiateInteratables = require('pure.instantiate_interactables')
local createPlayerMoveTween = require('pure.create_player_move_tween')
local pointInRect = require('pure.point_in_rect')

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

  local map = self.preloaded_levels[self.sorted_names[self.level_index]]
  tileset, layers, interactables, grid, paths = map.tileset, map.layers, map.interactives, map.grid, map.paths
  player, fans, flames = instantiateInteratables(interactables)
end

function Main:update(dt)
  for i,fan in ipairs(fans) do
    fan:update(dt)
  end

  for i,flame in ipairs(flames) do
    flame:update(dt)

    if flame.scale > 0 and player.x == flame.x and player.y == flame.y then
      print('he ded')
    end
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
  g.setColor(255, 255, 255)
  g.draw(self.preloaded_images['bg.png'], 0, 0, 0, g.getHeight() / self.preloaded_images['bg.png']:getHeight())

  self.camera:set()

  g.draw(layers[1], 0, 0)

  for i,flame in ipairs(flames) do
    flame:draw()
  end
  player:draw()
  for i,fan in ipairs(fans) do
    fan:draw()
  end

  g.setColor(255, 255, 255)
  g.draw(layers[3], 0, 0)

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

      local x1, y1, x2, y2 = touched_fan:getInfluence()
      if touched_fan.active then
        for i,flame in ipairs(flames) do
          if pointInRect(flame.x, flame.y, x1, y1, x2, y2) then
            flame.fans[touched_fan.id] = touched_fan
          end
        end
      else
        for i,flame in ipairs(flames) do
          if pointInRect(flame.x, flame.y, x1, y1, x2, y2) then
            flame.fans[touched_fan.id] = nil
          end
        end
      end
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
