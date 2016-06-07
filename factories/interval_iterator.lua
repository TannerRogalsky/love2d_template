local function iterator(state)
  state.index = state.index + 1
  if state.index <= state.total then
    return state.index, state.interval * (state.index % state.total) - state.rotation_offset
  end
end

local function interval_iterator(vertex_count)
  local interval = math.pi * 2 / vertex_count
  local rotation_offset = math.pi / 2
  if vertex_count % 2 == 0 then
    rotation_offset = rotation_offset - interval  / 2
  end

  return iterator, {
    index = 0,
    total = vertex_count,
    interval = interval,
    rotation_offset = rotation_offset
  }
end

return interval_iterator
