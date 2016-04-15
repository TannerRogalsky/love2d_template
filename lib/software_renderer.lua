local g = love.graphics

local function cross(x0, y0, x1, y1)
  return (x0*y1) - (y0*x1)
end

local function sortVertices(x0, y0, x1, y1, x2, y2)
  if y0 > y1 then x0, x1, y0, y1 = x1, x0, y1, y0 end
  if y0 > y2 then x0, x2, y0, y2 = x2, x0, y2, y0 end
  if y1 > y2 then x1, x2, y1, y2 = x2, x1, y2, y1 end
  return x0, y0, x1, y1, x2, y2
end

local function getPointsInLine(x0, y0, x1, y1)
  local dx = math.abs(x1 - x0)
  local sx = x0 < x1 and 1 or -1
  local dy = math.abs(y1 - y0)
  local sy = y0 < y1 and 1 or -1
  local err = (dx > dy and dx or -dy) / 2

  local points = {}
  while true do
    table.insert(points, x0)
    table.insert(points, y0)
    if (x0 == x1 and y0 == y1) then
      break;
    end

    local e2 = err
    if e2 > -dx then
      err = err - dy
      x0 = x0 + sx
    end
    if e2 < dy then
      err = err + dx
      y0 = y0 + sy
    end
  end

  return points
end

local function popMinMax(min, max, points)
  for i=1,#points,2 do
    local x, y = points[i], points[i + 1]

    min[y] = min[y] or x
    min[y] = math.min(min[y], x)

    max[y] = max[y] or x
    max[y] = math.max(max[y], x)
  end
end

local function getPointsInTriangle(x0, y0, x1, y1, x2, y2)
  x0, y0, x1, y1, x2, y2 = sortVertices(x0, y0, x1, y1, x2, y2)

  local a = getPointsInLine(x0, y0, x1, y1)
  local b = getPointsInLine(x1, y1, x2, y2)
  local c = getPointsInLine(x2, y2, x0, y0)

  local minX, maxX = {}, {}
  popMinMax(minX, maxX, a)
  popMinMax(minX, maxX, b)
  popMinMax(minX, maxX, c)

  local points = {}
  for y=y0,y2 do
    for x=minX[y],maxX[y] do
      table.insert(points, {x, y})
    end
  end

  return points
end

local function drawImage(image, x, y, r, sx, sy)
  r = r or 0
  sx = sx or 1
  sy = sy or sx

  local data = image:getData()
  local w, h = image:getWidth() - 1, image:getHeight() - 1
  local pw, ph = math.floor(w * sx), math.floor(h * sy)
  local points = {}
  for px=0,pw do
    for py=0,ph do
      local r, g, b, a = data:getPixel(math.floor(px / pw * w), math.floor(py / ph * h))
      table.insert(points, {x + px, y + py, r, g, b, a})
    end
  end
  g.points(points)
end

-- SR START
local sr = {}

function sr.triangle(mode, x0, y0, x1, y1, x2, y2)
  if (y0 == y1 and y0 == y2) then return end -- I dont care about degenerate triangles
  if mode == 'line' then
    g.points(getPointsInLine(x0, y0, x1, y1))
    g.points(getPointsInLine(x1, y1, x2, y2))
    g.points(getPointsInLine(x2, y2, x0, y0))
  else
    g.points(getPointsInTriangle(x0, y0, x1, y1, x2, y2))
  end
end

function sr.line(x0, y0, x1, y1)
  g.points(getPointsInLine(x0, y0, x1, y1))
end

function sr.draw(drawable, ...)
  if drawable.typeOf and drawable:typeOf('Image') then
    drawImage(drawable, ...)
  elseif type(drawable.draw) == 'function' then
    drawable:draw(...)
  end
end

-- MESH
local mesh_mt = {}
function mesh_mt:draw(x, y)
  local points = {}

  local w, h = 1, 1
  local texture = self.texture
  if texture then
    w, h = texture:getWidth() - 1, texture:getHeight() - 1
  end

  if self.mode == 'fan' then
    for i=3,#self.vertices do
      local v = self.vertices
      local a, b, c = v[1], v[i - 1], v[i]

      local ax, ay, au, av = a[1], a[2], a[3] or 0, a[4] or 0
      local bx, by, bu, bv = b[1], b[2], b[3] or 0, b[4] or 0
      local cx, cy, cu, cv = c[1], c[2], c[3] or 0, c[4] or 0

      local area = cross(ax-bx, ay-by, ax-cx, ay-cy)

      local triPoints = getPointsInTriangle(ax, ay, bx, by, cx, cy)

      local gx = x

      for _,point in ipairs(triPoints) do
        local px, py = point[1], point[2]

        local fax, fay = ax - px, ay - py
        local fbx, fby = bx - px, by - py
        local fcx, fcy = cx - px, cy - py

        local area1 = cross(fbx, fby, fcx, fcy) / area
        local area2 = cross(fcx, fcy, fax, fay) / area
        local area3 = cross(fax, fay, fbx, fby) / area

        local uvx = au * area1 + bu * area2 + cu * area3
        local uvy = av * area1 + bv * area2 + cv * area3

        local tx, ty = math.ceil(w * uvx), math.ceil(h * uvy)
        local r, g, b, a = 255, 255, 255, 255
        if texture then
          r, g, b, a = texture:getPixel(tx, ty)
        end

        table.insert(points, {px + x, py + y, r, g, b, a})
      end

      -- print(ax, bx, cx, w, x, gx)
    end
  end
  g.points(points)
end

function mesh_mt:setTexture(texture)
  self.texture = texture:getData()
end

function sr.newMesh(vertices, mode)
  return setmetatable({
    vertices = vertices,
    mode = mode or 'fan'
  }, {__index = mesh_mt})
end

return sr
