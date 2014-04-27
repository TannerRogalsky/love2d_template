local triggers = {}

function triggers.bounce_animation(trigger, dt)
  local offset = trigger.offset or math.random() * (math.pi / 2)
  trigger.offset = offset
  local layer = trigger.tile_layer or "Background"
  local frequency = trigger.frequency or 3
  local amplitude = trigger.amplitude or 21 / 4
  local x, y = trigger.body:getWorldCenter()
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
  level.triggers[coin] = nil
  coin.body:destroy()
  local sprite_id = level.tile_layers[tile_layer].sprite_lookup:get(coin.tile_x,coin.tile_y)
  level.tile_layers[tile_layer].sprite_batch:set(sprite_id, 0, 0, 0, 0, 0)
end

return triggers
