local triggers = {}

function triggers.test_enter(trigger, object, contact, nx, ny, ...)
  object.body:applyLinearImpulse(0, -60)
  object.can_jump = false
end

function triggers.test_exit(trigger, object, contact, nx, ny, ...)
end

return triggers
