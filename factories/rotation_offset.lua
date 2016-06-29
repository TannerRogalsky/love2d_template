local function rotationOffset(vertex_count)
  local interval = math.pi * 2 / vertex_count
  local rotation_offset = math.pi / 2 + interval
  if vertex_count % 2 == 0 then
    rotation_offset = rotation_offset - interval / 2
  end
  return rotation_offset
end

return rotationOffset
