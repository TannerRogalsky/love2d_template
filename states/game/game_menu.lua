local Menu = Game:addState('Menu')

function Menu:enteredState()
end

function Menu:draw()
  local levels = self.preloaded_levels
  local i = 0
  for name,level in pairs(levels) do
    g.print(name, i * 100, 0)
    i = i + 1
  end
end

function Menu:mousereleased(x, y, button, isTouch)
  local i = 0
  for name,level in pairs(self.preloaded_levels) do
    if x < i * 100 + 100 then
      self:gotoState("Main", level)
      break
    end
    i = i + 1
  end
end

function Menu:exitedState()
end

return Menu
