local triggers = {}

function triggers.test_enter(trigger_object, object, contact, nx, ny, ...)
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
  level.triggers[trigger_object] = nil
  local sprite_id = level.tile_layers["Foreground"].sprite_lookup:get(trigger_object.tile_x,trigger_object.tile_y)
  level.tile_layers["Foreground"].sprite_batch:set(sprite_id, 0, 0, 0, 0, 0)
end

return triggers
