local Grid = class('Grid')

function Grid:initialize(width, height)
  assert(type(width) == "number" and width > 0)
  assert(type(height) == "number" and height > 0)

  for i = 1, width do
    self[i] = {}
    for j = 1, height do
      self[i][j] = nil
    end
  end

  self.width = width
  self.height = height

  self.orientation = 0
end

function Grid:each(x, y, width, height, callback)
  x = x or 1
  y = y or 1
  width = width or self.width
  height = height or self.height
  assert(type(callback) == "function")

  -- even though it sort of works, don't try to iterate outside of the grid bounds
  if x < 1 then x = 1
  elseif y < 1 then y = 1
  elseif x + width > self.width then width = self.width - x
  elseif y + height > self.height then height = self.height - y
  end

  for i = x, width do
    for j = y, height do
      callback(self[i][j], i, j)
    end
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
