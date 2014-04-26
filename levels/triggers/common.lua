local triggers = {}

function triggers.goal_enter(goal, player)
  if goal.player and goal.player == player.player_name then
    goal.triggered = true
    print(goal.player, goal.triggered)
  end
end

function triggers.goal_exit(goal, player)
  if goal.player and goal.player == player.player_name then
    goal.triggered = false
    print(goal.player, goal.triggered)
  end
end

-- removes the coin from the level
function triggers.coin_enter(coin, object)
  level.triggers[coin] = nil
  coin.body:destroy()
  local sprite_id = level.tile_layers["Foreground"].sprite_lookup:get(coin.tile_x,coin.tile_y)
  level.tile_layers["Foreground"].sprite_batch:set(sprite_id, 0, 0, 0, 0, 0)
end

return triggers
