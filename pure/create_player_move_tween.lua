local function createPlayerMoveTween(grid, paths, fans, player)
  local px, py = player.x, player.y

  do
    local fan_of_influence = nil
    for i,fan in ipairs(fans) do
      if fan.active then
        local phi = fan.orientation
        local dx, dy = math.cos(phi), math.sin(phi)
        local fx1, fy1 = fan.x + dx * 50, fan.y + dy * 50
        local fx2, fy2 = fan.x + fan.strength * dx * 50, fan.y + fan.strength * dy * 50
        if fx1 > fx2 then fx1, fx2 = fx2, fx1 end
        if fy1 > fy2 then fy1, fy2 = fy2, fy1 end
        fx2, fy2 = fx2 + 50, fy2 + 50

        if px >= fx1 and px < fx2 and py >= fy1 and py < fy2 then
          fan_of_influence = fan
        end
      end
    end

    if fan_of_influence then
      local phi = fan_of_influence.orientation
      local dx, dy = math.cos(phi), math.sin(phi)
      local cgx, cgy = grid:to_grid(px, py)
      local ngx, ngy = cgx + dx, cgy + dy
      if paths[ngx] and paths[ngx][ngy] then -- there's a path where we want to move to
        local nx, ny = grid:to_pixel(ngx, ngy)
        player.orientation = math.atan2(dy, dx)
        return tween.new(Player.TILE_MOVE_TIME, player, {x = nx, y = ny})
      else -- there's no path, don't tween
        player.orientation = math.atan2(dy, dx)
      end
    end
  end

  local dx, dy = 0, 0
  if love.keyboard.isDown('up') then dy = dy - 1
  elseif love.keyboard.isDown('down') then dy = dy + 1
  elseif love.keyboard.isDown('right') then dx = dx + 1
  elseif love.keyboard.isDown('left') then dx = dx - 1 end

  if dx ~= 0 or dy ~= 0 then
    local cgx, cgy = grid:to_grid(px, py)
    local ngx, ngy = cgx + dx, cgy + dy
    if paths[ngx] and paths[ngx][ngy] then -- there's a path where we want to move to
      local nx, ny = grid:to_pixel(ngx, ngy)
      player.orientation = math.atan2(dy, dx)
      return tween.new(Player.TILE_MOVE_TIME, player, {x = nx, y = ny})
    else -- there's no path, don't tween
      player.orientation = math.atan2(dy, dx)
      return nil
    end
  else
    return nil
  end
end

return createPlayerMoveTween
