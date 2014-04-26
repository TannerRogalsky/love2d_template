local triggers = {}


-- removes the coin from the level
function triggers.coin_enter(coin, object)
  level.triggers[coin] = nil
  coin.body:destroy()
  local sprite_id = level.tile_layers["Foreground"].sprite_lookup:get(coin.tile_x,coin.tile_y)
  level.tile_layers["Foreground"].sprite_batch:set(sprite_id, 0, 0, 0, 0, 0)
end

return triggers
