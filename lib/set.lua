local Set = {}
function Set.new()
  local reverse = {}
  local set = {}

  return setmetatable(set, {
    __index = {
      insert = function(set, value)
        if not reverse[value] then
          table.insert(set, value)
          reverse[value] = #set
        end
      end,
      remove = function(set, value)
        local index = reverse[value]
        if index then
          reverse[value] = nil
          -- pop the top element off the set
          local top = table.remove(set)
          if top ~= value then
            -- if it's not the element that we actually want to remove,
            -- put it back into the set at the index of the element that we
            -- do want to remove, replacing it
            reverse[top] = index
            set[index] = top
          end
        end
      end,
      contains = function(set, value)
        return reverse[value] ~= nil
      end,
      size = function(set)
        return #set
      end
    }
  })
end
return Set
