local Over = Game:addState('Over')

function Over:enteredState(text)
  self.text = text
  g.setFont(self.preloaded_fonts["04b03_46"])
end

function Over:draw()
  g.setColor(COLORS.white:rgb())
  g.printf(self.text, 0, g.getHeight() / 3, g.getWidth(), "center")
  g.printf("High five to restart!", 0, g.getHeight() / 2, g.getWidth(), "center")
end

function Over:keypressed(key, unicode)
  self:gotoState("Main")
end

function Over:exitedState()
  self.text = nil
end

return Over
