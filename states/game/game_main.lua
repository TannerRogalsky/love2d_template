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

local function checkFlameInfluence(fan, flames)
  local x1, y1, x2, y2 = fan:getInfluence()
  local influenced = {}
  for i,flame in ipairs(flames) do
    if pointInRect(flame.x, flame.y, x1, y1, x2, y2) then
      table.insert(influenced, flame)
    end
  end
  return influenced
end

function Main:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  local map = self.preloaded_levels[self.sorted_names[self.level_index]]
  tileset, layers, interactables, grid, paths = map.tileset, map.layers, map.interactives, map.grid, map.paths
  player, fans, flames, lavas = instantiateInteratables(interactables)

  walking_animation = anim8.newAnimation({
    game.sprites.quads.man_walking1,
    game.sprites.quads.man_walking2,
    game.sprites.quads.man_walking3,
    game.sprites.quads.man_walking4,
    game.sprites.quads.man_walking5,
    game.sprites.quads.man_walking6,
    game.sprites.quads.man_walking7,
    game.sprites.quads.man_walking8,
    game.sprites.quads.man_walking9,
    game.sprites.quads.man_walking10,
  }, 0.1)
  player.animation = walking_animation

  pushing_animation = anim8.newAnimation({
    game.sprites.quads.man_pushing001,
    game.sprites.quads.man_pushing002,
    game.sprites.quads.man_pushing003,
    game.sprites.quads.man_pushing004,
    game.sprites.quads.man_pushing005,
    game.sprites.quads.man_pushing006,
    game.sprites.quads.man_pushing007,
    game.sprites.quads.man_pushing008,
    game.sprites.quads.man_pushing009,
    game.sprites.quads.man_pushing010,
  }, 0.1)

  winning_animation = anim8.newAnimation({
    game.sprites.quads.winning_dance_1_1,
    game.sprites.quads.winning_dance_1_2,
    game.sprites.quads.winning_dance_1_3,
    game.sprites.quads.winning_dance_1_4,
    game.sprites.quads.winning_dance_1_5,
    game.sprites.quads.winning_dance_1_6,
    game.sprites.quads.winning_dance_1_7,
    game.sprites.quads.winning_dance_1_8,
    game.sprites.quads.winning_dance_1_9,
    game.sprites.quads.winning_dance_1_10,
    game.sprites.quads.winning_dance_1_11,
    game.sprites.quads.winning_dance_1_12,
  }, 0.2)
end

function Main:update(dt)
  if player_move_tween then
    player.animation:update(dt)
    if player_move_tween:update(dt) then player_move_tween = nil end

    if fan_move_tween and fan_move_tween:update(dt) then
      if fan_move_tween.subject.active then
        local influenced_flames = checkFlameInfluence(fan_move_tween.subject, flames)
        for i,flame in ipairs(influenced_flames) do
          flame.fans[fan_move_tween.subject.id] = fan_move_tween.subject
        end
      end
      fan_move_tween = nil
    end
  elseif self.over then
    player.animation:update(dt)
  end

  for i,fan in ipairs(fans) do
    fan:update(dt)
  end

  for i,flame in ipairs(flames) do
    flame:update(dt)

    if flame.scale > 0 and player.x == flame.x and player.y == flame.y then
      self.over = 'lose'
    end
  end

  for i,lava in ipairs(lavas) do
    lava:update(dt)
    if player.x == lava.x and player.y == lava.y then
      self.over = 'lose'
    end
  end

  if numActiveFans(fans) == #fans then
    self.over = 'win'
    player.animation = winning_animation
  end

  if not player_move_tween then
    player_move_tween, fan_move_tween = createPlayerMoveTween(grid, paths, fans, player)
    if player_move_tween then
      player.animation = walking_animation
    elseif not self.over then
      player.animation:gotoFrame(1)
    end
    if fan_move_tween then
      player.animation = pushing_animation
      local influenced_flames = checkFlameInfluence(fan_move_tween.subject, flames)
      for i,flame in ipairs(influenced_flames) do
        flame.fans[fan_move_tween.subject.id] = nil
      end
    end
  end
end

function Main:draw()
  self.camera:setPosition(math.floor(player.x - g.getWidth() / 2 + 25), math.floor(player.y - g.getHeight() / 2 + 25))

  g.setColor(255, 255, 255)
  do
    local bg = self.sprites.quads['bg']
    local _, _, bgw, bgh = bg:getViewport()
    g.draw(self.sprites.texture, bg, 0, 0, 0, g.getHeight() / bgh)
  end

  self.camera:set()

  g.draw(layers[1], 0, 0)

  for i,flame in ipairs(flames) do
    flame:draw()
  end
  for i,lava in ipairs(lavas) do
    lava:draw()
  end
  player:draw()
  for i,fan in ipairs(fans) do
    fan:draw()
  end

  g.setColor(255, 255, 255)
  g.draw(layers[3], 0, 0)

  self.camera:unset()

  do
    local width = g.getWidth() / 6
    local font_height = g.getFont():getHeight()
    local height = font_height * 2
    local y = 10
    local x = g.getWidth() - width - 10
    g.setColor(0, 0, 0)
    g.rectangle('fill', x, y, width, height)
    g.setColor(255, 0, 0)
    g.rectangle('fill', x, y, (1 - numActiveFans(fans) / #fans) * width, height)
    g.setColor(255, 255, 255)
    g.print(#fans - numActiveFans(fans) .. ' fans to turn on!', x + 5, y + font_height / 2)
  end

  if self.over then
    g.setColor(0, 0, 0, 100)
    g.rectangle('fill', 0, 0, g.getWidth(), g.getHeight())
    g.setColor(255, 255, 255)
    if self.over == 'lose' then
      g.print('he ded', 100, 100)
    else
      g.print('he livd', 100, 100)
    end
  end

  -- g.setColor(0, 255, 0)
  -- g.print(love.timer.getFPS(), 0, 0)
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
end

function Main:keypressed(key, scancode, isrepeat)
  if self.over then return end

  if not player_move_tween then
    player_move_tween, fan_move_tween = createPlayerMoveTween(grid, paths, fans, player)
    if player_move_tween then player.animation = walking_animation end
    if fan_move_tween then
      player.animation = pushing_animation
      local influenced_flames = checkFlameInfluence(fan_move_tween.subject, flames)
      for i,flame in ipairs(influenced_flames) do
        flame.fans[fan_move_tween.subject.id] = nil
      end
    end
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
      local influenced_flames = checkFlameInfluence(touched_fan, flames)
      for i,flame in ipairs(influenced_flames) do
        if touched_fan.active then
          flame.fans[touched_fan.id] = touched_fan
        else
          flame.fans[touched_fan.id] = nil
        end
      end
    end
  end
end

function Main:keyreleased(key, scancode)
  if key == 'r' then
    self:gotoState('Main')
  elseif key == 'escape' then
    self:gotoState('Menu')
  end
end

function Main:gamepadpressed(joystick, button)
  if self.over then return end

  if not player_move_tween then
    player_move_tween, fan_move_tween = createPlayerMoveTween(grid, paths, fans, player)
    if player_move_tween then player.animation = walking_animation end
    if fan_move_tween then
      player.animation = pushing_animation
      local influenced_flames = checkFlameInfluence(fan_move_tween.subject, flames)
      for i,flame in ipairs(influenced_flames) do
        flame.fans[fan_move_tween.subject.id] = nil
      end
    end
  end

  if button == 'a' then
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
      local influenced_flames = checkFlameInfluence(touched_fan, flames)
      for i,flame in ipairs(influenced_flames) do
        if touched_fan.active then
          flame.fans[touched_fan.id] = touched_fan
        else
          flame.fans[touched_fan.id] = nil
        end
      end
    end
  end
end

function Main:gamepadreleased(joystick, button)
  if button == 'back' then
    self:gotoState('Menu')
  elseif button == 'start' then
    self:gotoState('Main')
  end
end

function Main:focus(has_focus)
end

function Main:exitedState()
  self.over = false
  self.camera = nil
end

return Main
