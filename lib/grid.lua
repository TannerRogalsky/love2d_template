local Grid = class('Grid')

function Grid:initialize(width, height)
  assert(type(width) == "number" and width > 0)
  assert(type(height) == "number" and height > 0)

  for i = 1, width do
    self[i] = {}
  end

  self.width = width
  self.height = height

  self.orientation = 0
end

-- TODO I don't actually trust this iterator, double check it all
function Grid:each(x, y, width, height)
  x = x or 1
  y = y or 1
  width = width or self.width
  height = height or self.height
  width, height = width - 1, height - 1

  -- don't try to iterate outside of the grid bounds
  local x_diff, y_diff = 0, 0
  if x < 1 then
    x_diff = 1 - x
    x = 1
  end
  if y < 1 then
    y_diff = 1 - y
    y = 1
  end
  -- if you bump up x or y, bump down the width or height the same amount
  width, height = width - x_diff, height - y_diff
  if x + width > self.width then width = self.width - x end
  if y + height > self.height then height = self.height - y end

  local function iterator(state)
    while state.childIndex <= x + width do
      state.grandChildIndex = state.grandChildIndex + 1
      if state.grandChildIndex > y + height then
        state.childIndex = state.childIndex + 1
        state.grandChildIndex = y - 1
      else
        return state.childIndex, state.grandChildIndex, self:get(state.childIndex, state.grandChildIndex)
      end
    end
  end

  return iterator, {childIndex = x, grandChildIndex = y - 1}
end

function Grid:rotate(angle)
  return self:rotate_to(self.orientation + angle)
end

function Grid:rotate_to(angle)
  self.orientation = angle
  return self.orientation
end

function Grid:out_of_bounds(x, y)
  return x < 1 or y < 1 or x > self.width or y > self.height
end

function Grid:get(x, y, orientation)
  if self:out_of_bounds(x, y) then
    -- out of bounds
    return nil
  end

  orientation = orientation or self.orientation
  local angle_quad = orientation / 90 % 4

  if angle_quad == 0 then
    return self[x][y]
  elseif angle_quad == 1 then
    return self[y][#self - x + 1]
  elseif angle_quad == 2 then
    return self[#self - x + 1][#self - y + 1]
  elseif angle_quad == 3 then
    return self[#self - y + 1][x]
  end
end
Grid.g = Grid.get

function Grid:set(x, y, value, orientation)
  if self:out_of_bounds(x, y) then
    -- out of bounds
    return
  end

  orientation = orientation or self.orientation
  local angle_quad = orientation / 90 % 4

  if angle_quad == 0 then
    self[x][y] = value
  elseif angle_quad == 1 then
    self[y][#self - x + 1] = value
  elseif angle_quad == 2 then
    self[#self - x + 1][#self - y + 1] = value
  elseif angle_quad == 3 then
    self[#self - y + 1][x] = value
  end
end
Grid.s = Grid.set

function Grid:__tostring()
  local strings, result = {}, "    "

  for i,row in ipairs(self) do
    for j,cell in ipairs(row) do
      if strings[j] == nil then strings[j] = {} end
      strings[j][i] = self:get(i, j)
    end
  end

  for i = 1, self.width do
    result = result .. i .. ", "
  end
  result = result .. "\n"

  for i = 1, self.width do
    if i >= 10 then
      result = result .. i .. ": " .. table.concat(strings[i], ", ") .. "\n"
    else
      result = result .. i .. ":  " .. table.concat(strings[i], ", ") .. "\n"
    end
  end

  return result
end

return Grid
