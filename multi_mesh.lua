local MultiMesh = class('MultiMesh', Base)

local function copyVertex(index, mesh, ox, oy, r)
  local x, y = mesh:getVertex(index)
  local c, s = math.cos(r), math.sin(r)
  return {ox + (c*x - s*y), oy + (s*x + c*y)}
end

local function copyVertices(mesh, verts, x, y, r)
  local origin = copyVertex(1, mesh, x, y, r)

  for i=2,mesh:getVertexCount() - 1 do
    table.insert(verts, origin)
    table.insert(verts, copyVertex(i, mesh, x, y, r))
    table.insert(verts, copyVertex(i + 1, mesh, x, y, r))
  end

  return verts
end

local function getClosestSideToAngle(requested_rotation, mesh)
  local vertex_count = mesh:getVertexCount()
  local j, closest = vertex_count, math.pi * 2
  local x, y = 0, 0
  local closest_index = 0

  for i=1,vertex_count do
    local ix, iy = mesh:getVertex(i)
    local jx, jy = mesh:getVertex(j)
    local mx, my = (ix + jx) / 2, (iy + jy) / 2

    local angle = math.atan2(my, mx)
    -- print(angle - requested_rotation, requested_rotation - angle, closest)
    if math.abs(angle - requested_rotation) < closest then
      closest = angle
      x, y = mx, my
      closest_index = j
    end

    j = i
  end

  return closest, x, y, closest_index
end

local function newMeshData(mesh, x, y, r)
  return {
    mesh = mesh,
    x = x,
    y = y,
    r = r
  }
end

local function adjustAngle(angle)
  angle = angle - math.pi / 2
  if angle < 0 then angle = angle + math.pi * 2 end
  return angle
end

function MultiMesh:initialize(intial_mesh)
  Base.initialize(self)

  self.verts = {}
  copyVertices(intial_mesh, self.verts, 0, 0, 0)
  self.mesh = g.newMesh(self.verts, 'triangles')

  self.meshes = {newMeshData(intial_mesh, 0, 0, 0)}
end

function MultiMesh:addMesh(mesh, requested_rotation)
  -- print("ROTATIONS")
  -- print(requested_rotation, math.deg(requested_rotation))
  -- requested_rotation = adjustAngle(requested_rotation)
  -- print(requested_rotation, math.deg(requested_rotation))
  local previous = self.meshes[#self.meshes]

  local pr, px, py, pi = getClosestSideToAngle(requested_rotation, previous.mesh)
  local cr, cx, cy, ci = getClosestSideToAngle(requested_rotation + math.pi, mesh)
  -- print("OTHER STUFF")
  -- print(cx, cy, ci)
  -- print(px, py, pi)
  -- print(cx - px, cy - py)
  -- print(cr, math.deg(cr))

  copyVertices(mesh, self.verts, cx - px, cy - py, cr)
  local new_mesh = g.newMesh(self.verts, 'triangles')
  self.mesh = new_mesh

  table.insert(self.meshes, newMeshData(mesh, x, y, r))
  return #self.meshes
end

function MultiMesh:removeMesh(index)

end

return MultiMesh
