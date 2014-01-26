local Menu = Game:addState('Menu')

function Menu:enteredState()
end

function Menu:render()
end

function Menu:keypressed(key, unicode)
  if key == "r" then
    self:randomize_title()
  elseif key == "2" or key == "4" then
    self:gotoState("Main", "level" .. key)
  else
    self:gotoState("Main")
  end
end

function Menu:exitedState()
end

return Menu
