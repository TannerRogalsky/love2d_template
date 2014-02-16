local slowroutine = {}
local entries = {}
local count = 0

function slowroutine.update(dt)
  -- print(count)
  for _, entry in pairs(entries) do
    local co = entry.coroutine
    local run_time = 0
    local time = love.timer.getTime()
    while run_time <= entry.max_time_step do
      if coroutine.status(co) == "dead" then
        entries[entry] = nil
        count = count - 1
        break
      end
      assert(coroutine.resume(co, dt))
      run_time = run_time + (love.timer.getTime() - time)
    end
  end
end

function slowroutine.new(max_time_step, func)
  assert(type(max_time_step) == "number" and max_time_step >= 0)
  assert(type(func) == "function")

  local entry = {
    coroutine = coroutine.create(func),
    max_time_step = max_time_step * 1000000
  }
  entries[entry] = entry
  count = count + 1
end

return slowroutine
