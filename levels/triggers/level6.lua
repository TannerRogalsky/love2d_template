local triggers = {}

function triggers.test_enter(object_one, object_two, contact, nx, ny, ...)
  print("enter")
  print(object_one, object_two, contact, nx, ny, ...)
  object_two.body:applyLinearImpulse(0, -60)
  object_two.can_jump = false
end

function triggers.test_exit(object_one, object_two, contact, nx, ny, ...)
  print("exit")
  print(object_one, object_two, contact, nx, ny, ...)
end

return triggers
