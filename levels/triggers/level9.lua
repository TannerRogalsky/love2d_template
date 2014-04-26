local triggers = {}
local coin = love.audio.newSource( "/sounds/coin.wav", "static" )
coin:setVolume(0.2)
local jumppad = love.audio.newSource( "/sounds/jumppad.wav", "static" )
jumppad:setVolume(0.1)

function triggers.test_enter(trigger_object, object, contact, nx, ny, ...)
	love.audio.stop(jumppad)	
  love.audio.play(jumppad)
  object.body:applyLinearImpulse(0, -60)
  object.can_jump = false
end

function triggers.test_exit(trigger_object, object, contact, nx, ny, ...)
end

function triggers.test_draw(trigger_object)
  g.setColor(COLORS.indigo:rgb())
  g.polygon("fill", trigger_object.body:getWorldPoints(trigger_object.shape:getPoints()))
end

function triggers.coin_enter(trigger_object, object)
	love.audio.stop(coin)	
  love.audio.play(coin)
  level.triggers[trigger_object] = nil
  trigger_object.body:destroy()
  local sprite_id = level.tile_layers["Foreground"].sprite_lookup:get(trigger_object.tile_x,trigger_object.tile_y)
  level.tile_layers["Foreground"].sprite_batch:set(sprite_id, 0, 0, 0, 0, 0)
end

return triggers
