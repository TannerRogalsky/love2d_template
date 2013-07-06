--------------------------------------------------------------------------------
-- internal constants ----------------------------------------------------------
--------------------------------------------------------------------------------

local PRIORITY = {}

--------------------------------------------------------------------------------
-- basic functionality ---------------------------------------------------------
--------------------------------------------------------------------------------
local OrderedSet = require 'lib/ordered_set'
local PriorityQueue = class("PriorityQueue", OrderedSet)

function PriorityQueue:initialize()
  OrderedSet.initialize(self)
end

-- internal functions
local function getpriorities(self)
  if not self[PRIORITY] then
    self[PRIORITY] = {}
  end
  return self[PRIORITY]
end
local function removepriority(self, element)
  if element then
    local priorities = getpriorities(self)
    local priority = priorities[element]
    priorities[element] = nil
    return element, priority
  end
end

-- specific functions
function PriorityQueue:priority(element)
  return getpriorities(self)[element]
end

function PriorityQueue:enqueue(priority, element)
  if not self:contains(element) then
    local previous
    if priority then
      local priorities = getpriorities(self)
      for elem, prev in self:sequence() do
        local prio = priorities[elem]
        if prio and prio > priority then
          previous = prev
          break
        end
      end
      priorities[element] = priority
    end
    return self:insert(element, previous)
  end
end

function PriorityQueue:dequeue()
  return removepriority(self, self:dequeue())
end

function PriorityQueue:remove(element, previous)
  return removepriority(self, self:remove(element, previous))
end

return PriorityQueue
