--[[
Copyright (c) 2011 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

local floor = math.floor
local min, max = math.min, math.max
local sqrt, abs = math.sqrt, math.abs

local _PACKAGE = (...):match("^(.+)%.[^%.]+")

local EllipticalSpatialhash = class('EllipticalSpatialhash')
function EllipticalSpatialhash:initialize(segments, cell_width, cell_height)
  self.cell_width = cell_width
  self.cell_height = cell_height
  self.segments = segments
  self.interval = math.pi * 2 / self.segments
  self.cells = {}
end

function EllipticalSpatialhash:cellCoords(x,y)
  local half_pi = math.pi / 2
  local rotation_offset = half_pi
  if self.segments % 2 == 0 then
    rotation_offset = half_pi - t  / 2
  end

  local phi = math.atan2(y, x)
  if phi < 0 then phi = phi + math.pi * 2 end

  return floor(phi / self.interval), floor(abs(y) / self.cell_height)
end

function EllipticalSpatialhash:cell(i,k)
  local row = rawget(self.cells, i)
  if not row then
    row = {}
    rawset(self.cells, i, row)
  end

  local cell = rawget(row, k)
  if not cell then
    cell = setmetatable({}, {__mode = "kv"})
    rawset(row, k, cell)
  end

  return cell
end

function EllipticalSpatialhash:cellAt(x,y)
  return self:cell(self:cellCoords(x,y))
end

 -- get all shapes
function EllipticalSpatialhash:shapes()
  local set = {}
  for i,row in pairs(self.cells) do
    for k,cell in pairs(row) do
      for obj in pairs(cell) do
        rawset(set, obj, obj)
      end
    end
  end
  return set
end

-- get all shapes that are in the same cells as the bbox x1,y1 '--. x2,y2
function EllipticalSpatialhash:inSameCells(x1,y1, x2,y2)
  local set = {}
  x1, y1 = self:cellCoords(x1, y1)
  x2, y2 = self:cellCoords(x2, y2)
  for i = x1,x2 do
    for k = y1,y2 do
      for obj in pairs(self:cell(i,k)) do
        rawset(set, obj, obj)
      end
    end
  end
  return set
end

function EllipticalSpatialhash:register(obj, x1, y1, x2, y2)
  x1, y1 = self:cellCoords(x1, y1)
  x2, y2 = self:cellCoords(x2, y2)
  for i = x1,x2 do
    for k = y1,y2 do
      rawset(self:cell(i,k), obj, obj)
    end
  end
end

function EllipticalSpatialhash:remove(obj, x1, y1, x2,y2)
  -- no bbox given. => must check all cells
  if not (x1 and y1 and x2 and y2) then
    for _,row in pairs(self.cells) do
      for _,cell in pairs(row) do
        rawset(cell, obj, nil)
      end
    end
    return
  end

  -- else: remove only from bbox
  x1,y1 = self:cellCoords(x1,y1)
  x2,y2 = self:cellCoords(x2,y2)
  for i = x1,x2 do
    for k = y1,y2 do
      rawset(self:cell(i,k), obj, nil)
    end
  end
end

-- update an objects position
function EllipticalSpatialhash:update(obj, old_x1,old_y1, old_x2,old_y2, new_x1,new_y1, new_x2,new_y2)
  old_x1, old_y1 = self:cellCoords(old_x1, old_y1)
  old_x2, old_y2 = self:cellCoords(old_x2, old_y2)

  new_x1, new_y1 = self:cellCoords(new_x1, new_y1)
  new_x2, new_y2 = self:cellCoords(new_x2, new_y2)

  if old_x1 == new_x1 and old_y1 == new_y1 and
     old_x2 == new_x2 and old_y2 == new_y2 then
    return
  end

  for i = old_x1,old_x2 do
    for k = old_y1,old_y2 do
      rawset(self:cell(i,k), obj, nil)
    end
  end
  for i = new_x1,new_x2 do
    for k = new_y1,new_y2 do
      rawset(self:cell(i,k), obj, obj)
    end
  end
end

function EllipticalSpatialhash:draw(how, show_empty, print_key)
  if show_empty == nil then show_empty = true end
  for k1,v in pairs(self.cells) do
    for k2,cell in pairs(v) do
      local is_empty = (next(cell) == nil)
      if show_empty or not is_empty then
        local x = k1 * self.cell_width
        local y = k2 * self.cell_height
        love.graphics.ellipse(how or 'line', x,y, self.cell_width, self.cell_height)

        if print_key then
          love.graphics.print(("%d:%d"):format(k1,k2), x+3,y+3)
        end
      end
    end
  end
end

return EllipticalSpatialhash
