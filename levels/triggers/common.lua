local triggers = {}

local coin1 = love.audio.newSource( "/sounds/block1.ogg", "static" )
coin1:setVolume(0.2)

local coin2 = love.audio.newSource( "/sounds/block2.ogg", "static" )
coin2:setVolume(0.2)

local curcoin = 0

function triggers.bounce_animation(trigger, dt)
  local offset = trigger.offset or math.random() * (math.pi / 2)
  trigger.offset = offset
  local layer = trigger.tile_layer or "Background"
  local frequency = trigger.frequency or 3
  local amplitude = trigger.amplitude or 21 / 4
  local x, y = trigger.tile_x * 21, trigger.tile_y * 21
  y = y + math.sin((love.timer.getTime() + offset)  * frequency) * amplitude
  local sprite_id = level.tile_layers[layer].sprite_lookup:get(trigger.tile_x, trigger.tile_y)
  local quad = level.tile_layers[layer].quad_lookup:get(trigger.tile_x, trigger.tile_y)
  level.tile_layers[layer].sprite_batch:set(sprite_id, quad, x, y)
end

-- removes the coin from the level
function triggers.coin_enter(coin, object)
  local layer = coin.tile_layer or "Foreground"
  if coin.player and coin.player ~= object.player_name then
    return
  end

  if curcoin == 0 then
    love.audio.stop(coin1)
    love.audio.stop(coin2)
    love.audio.play(coin1)
    curcoin = curcoin + 1
  else
    love.audio.stop(coin1)
    love.audio.stop(coin2)
    love.audio.play(coin2)
    curcoin = 0
  end

  level.triggers[coin] = nil
  coin.body:destroy()
  local sprite_id = level.tile_layers[layer].sprite_lookup:get(coin.tile_x,coin.tile_y)
  level.tile_layers[layer].sprite_batch:set(sprite_id, 0, 0, 0, 0, 0)
end

return triggers
