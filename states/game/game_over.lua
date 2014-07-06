local Over = Game:addState('Over')

function Over:enteredState(text)
  self.text = text
end

function Over:draw()
  g.setColor(COLORS.white:rgb())
  g.print(self.text, 100, 100)
end

function Over:exitedState()
  self.text = nil
end

return Over
