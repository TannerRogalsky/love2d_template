--------------------------------------------------------------------------------
-- key constants ---------------------------------------------------------------
--------------------------------------------------------------------------------

local FIRST = newproxy()
local LAST = newproxy()

--------------------------------------------------------------------------------
-- basic functionality ---------------------------------------------------------
--------------------------------------------------------------------------------
local OrderedSet = class("OrderedSet")

function OrderedSet:initialize()
end

-- internal functions
local function iterator(self, previous)
  return self[previous], previous
end

-- specific functions
function OrderedSet:sequence()
  return iterator, self, FIRST
end

function OrderedSet:contains(element)
  return element ~= nil and (self[element] ~= nil or element == self[LAST])
end

function OrderedSet:first()
  return self[FIRST]
end

function OrderedSet:last()
  return self[LAST]
end

function OrderedSet:empty()
  return self[FIRST] == nil
end

function OrderedSet:insert(element, previous)
  if element ~= nil and not self:contains(element) then
    if previous == nil then
      previous = self[LAST]
      if previous == nil then
        previous = FIRST
      end
    elseif not self:contains(previous) and previous ~= FIRST then
      return
    end
    if self[previous] == nil
      then self[LAST] = element
      else self[element] = self[previous]
    end
    self[previous] = element
    return element
  end
end

function OrderedSet:previous(element, start)
  if self:contains(element) then
    local previous = (start == nil and FIRST or start)
    repeat
      if self[previous] == element then
        return previous
      end
      previous = self[previous]
    until previous == nil
  end
end

function OrderedSet:remove(element, start)
  local prev = previous(self, element, start)
  if prev ~= nil then
    self[prev] = self[element]
    if self[LAST] == element
      then self[LAST] = prev
      else self[element] = nil
    end
    return element, prev
  end
end

function OrderedSet:replace(old, new, start)
  local prev = self:previous(old, start)
  if prev ~= nil and new ~= nil and not self:contains(new) then
    self[prev] = new
    self[new] = self[old]
    if old == self[LAST]
      then self[LAST] = new
      else self[old] = nil
    end
    return old, prev
  end
end

function OrderedSet:pushfront(element)
  if element ~= nil and not self:contains(element) then
    if self[FIRST] ~= nil
      then self[element] = self[FIRST]
      else self[LAST] = element
    end
    self[FIRST] = element
    return element
  end
end

function OrderedSet:popfront()
  local element = self[FIRST]
  self[FIRST] = self[element]
  if self[FIRST] ~= nil
    then self[element] = nil
    else self[LAST] = nil
  end
  return element
end

function OrderedSet:pushback(element)
  if element ~= nil and not self:contains(element) then
    if self[LAST] ~= nil
      then self[ self[LAST] ] = element
      else self[FIRST] = element
    end
    self[LAST] = element
    return element
  end
end

--------------------------------------------------------------------------------
-- function aliases ------------------------------------------------------------
--------------------------------------------------------------------------------

-- set operations
OrderedSet.add = OrderedSet.pushback

-- stack operations
OrderedSet.push = OrderedSet.pushfront
OrderedSet.pop = OrderedSet.popfront
OrderedSet.top = OrderedSet.first

-- queue operations
OrderedSet.enqueue = OrderedSet.pushback
OrderedSet.dequeue = OrderedSet.popfront
OrderedSet.head = OrderedSet.first
OrderedSet.tail = OrderedSet.last

OrderedSet.firstkey = OrderedSet.FIRST

return OrderedSet
