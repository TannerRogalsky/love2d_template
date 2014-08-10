local Over = Game:addState('Over')

function Over:enteredState(winner)
  self.color = winner.color
end

function Over:draw()
  g.setColor(self.color:rgb())
  g.print("Winner", 100, 100)
end

function Over:keypressed()
  self:gotoState("Main")
end

function Over:exitedState()
  self.color = nil
end

return Over
