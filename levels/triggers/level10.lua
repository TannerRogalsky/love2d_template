local triggers = {}

local common_triggers = require("levels/triggers/common")
for k,v in pairs(common_triggers) do
  triggers[k] = v
end


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

return triggers
