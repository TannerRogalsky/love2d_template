local Producing = Factory:addState('Producing')

function Producing:enteredState()
  self.connections = {}
  self.reverse_connections = {}
end

return Producing
