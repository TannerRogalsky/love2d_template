local physics_callback_names = {"begin_contact", "end_contact", "presolve", "postsolve"}
local physics_callbacks = {}
for _,callback_name in ipairs(physics_callback_names) do
  local function callback(fixture_a, fixture_b, contact, ...)
    local object_one, object_two = fixture_a:getUserData(), fixture_b:getUserData()
    local nx, ny = contact:getNormal()
    if object_one and is_func(object_one[callback_name]) then
      object_one[callback_name](object_one, object_two, contact, nx, ny, ...)
    end
    if object_two and is_func(object_two[callback_name]) then
      object_two[callback_name](object_two, object_one, contact, -nx, -ny, ...)
    end
  end
  table.insert(physics_callbacks, callback)
end
return physics_callbacks
