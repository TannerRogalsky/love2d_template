local triggers = {}

local bgm = love.audio.newSource("/sounds/music1.ogg", "stream")
love.audio.play(bgm)
bgm:setVolume(0.4)
bgm:setLooping("true")

local coin1 = love.audio.newSource( "/sounds/block1.ogg", "static" )
coin1:setVolume(0.2)

local coin2 = love.audio.newSource( "/sounds/block2.ogg", "static" )
coin2:setVolume(0.2)

local curcoin = 0

local jumppad = love.audio.newSource( "/sounds/jumppad.ogg", "static" )
jumppad:setVolume(0.3)



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

  level.triggers[trigger_object] = nil
  trigger_object.body:destroy()
  local sprite_id = level.tile_layers["Foreground"].sprite_lookup:get(trigger_object.tile_x,trigger_object.tile_y)
  level.tile_layers["Foreground"].sprite_batch:set(sprite_id, 0, 0, 0, 0, 0)
end

return triggers
