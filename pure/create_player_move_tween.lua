local pointInRect = require('pure.point_in_rect')

local function fanAtPoint(px, py, fans)
  for i,fan in ipairs(fans) do
    if pointInRect(px, py, fan.x, fan.y, fan.x + 50, fan.y + 50) then
      return fan
    end
  end
  return nil
end

local function createPlayerMoveTween(grid, paths, fans, player)
  local px, py = player.x, player.y

  do
    local fan_of_influence = nil
    for i,fan in ipairs(fans) do
      if fan.active then
        local fx1, fy1, fx2, fy2 = fan:getInfluence()

        if pointInRect(px, py, fx1, fy1, fx2, fy2) then
          if fan_of_influence then
            local dist1 = (px - fan.x) * (py - fan.y)
            local dist2 = (px - fan_of_influence.x) * (py - fan_of_influence.y)
            if dist1 < dist2 then
              fan_of_influence = fan
            end
          else
            fan_of_influence = fan
          end
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

      local fan = fanAtPoint(nx, ny, fans)
      if fan and fan.moveable then
        local fgx, fgy = cgx + dx * 2, cgy + dy * 2
        local fx, fy = grid:to_pixel(fgx, fgy)
        if paths[fgx] and paths[fgx][fgy] and fanAtPoint(fx, fy, fans) == nil then
          return tween.new(Player.TILE_MOVE_TIME, player, {x = nx, y = ny}),
                 tween.new(Player.TILE_MOVE_TIME, fan, {x = fx, y = fy})
        end
      else
        return tween.new(Player.TILE_MOVE_TIME, player, {x = nx, y = ny})
      end
    else -- there's no path, don't tween
      player.orientation = math.atan2(dy, dx)
      return nil
    end
  else
    return nil
  end
end

return createPlayerMoveTween
