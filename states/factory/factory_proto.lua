local Proto = Factory:addState('Proto')

function Proto:enteredState()
  self.connections = nil
end

function Proto:drawResources() end

function Proto:connected(other)
  self.mesh = meshes[1]

  self:gotoState('Producing')
end

return Proto
