local DictGrid = class('DictGrid')

function DictGrid:initialize()
  self._internal_data = {}
end

function DictGrid:each()
  local function iterator()
    for x,column in pairs(self._internal_data) do
      for y,cell in pairs(column) do
        coroutine.yield(x, y, cell)
      end
    end
  end

  return coroutine.wrap(iterator)
end

function DictGrid:get(x, y)
  if is_table(self._internal_data[x]) then
    return self._internal_data[x][y]
  else
    return nil
  end
end

function DictGrid:set(x, y, value)
  if self._internal_data[x] == nil then self._internal_data[x] = {} end
  self._internal_data[x][y] = value
end

function DictGrid:contains(x, y)
  if self._internal_data[x] == nil then return false end
  return self._internal_data[x][y] ~= nil
end

return DictGrid
