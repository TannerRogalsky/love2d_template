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
end

function triggers.coin_draw(trigger_object, object)
  g.setColor(COLORS.yellow:rgb())
  local x, y = trigger_object.body:getWorldCenter()
  g.print("COIN", x, y)
end

return triggers
