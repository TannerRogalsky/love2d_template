--[[
LOOP License
-----------

LOOP is licensed under the terms of the MIT license reproduced below.
This means that LOOP is free software and can be used for both academic
and commercial purposes at absolutely no cost.

===============================================================================

Copyright (C) 2004-2008 Tecgraf, PUC-Rio.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

===============================================================================

(end of LICENSE)
]]

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
