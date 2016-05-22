local Factory = class('Factory', Base)

function Factory:initialize(mesh_type, x, y)
  Base.initialize(self)

  self.mesh_type = mesh_type
  self.x = x
  self.y = y

  self.connections = {}
end

return Factory
