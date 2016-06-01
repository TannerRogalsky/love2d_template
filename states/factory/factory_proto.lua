local Proto = Factory:addState('Proto')

function Proto:enteredState()
  self.connections = nil
  self.reverse_connections = nil
end

function Proto:drawResources() end

function Proto:connected(other)
  self.mesh = meshes[1]

  self:gotoState('Producing')
  self.reverse_connections[other.id] = other
end

return Proto
