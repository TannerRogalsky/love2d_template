local tau, cos, sin = math.pi * 2, math.cos, math.sin
local noise = love.math.noise

local function tilingNoise(x, y, x1, y1, x2, y2, w, h)
  local s = x / w
  local t = y / h
  local dx = x2 - x1
  local dy = y2 - y1

  local nx = x1 + cos(s * tau) * dx / tau
  local ny = y1 + cos(t * tau) * dy / tau
  local nz = x1 + sin(s * tau) * dx / tau
  local nw = y1 + sin(t * tau) * dy / tau

  return noise(nx,ny,nz,nw)
end

return tilingNoise
