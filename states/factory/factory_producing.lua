local Producing = Factory:addState('Producing')

function Producing:enteredState()
  self.connections = {}
end

return Producing
