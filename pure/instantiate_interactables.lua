local function instantiateInteratables(interactables)
  local player
  local fans = {}
  local flames = {}
  local lavas = {}

  for i,interactable in ipairs(interactables) do
    -- print(inspect(interactable))
    if interactable.player then
      player = Player:new(interactable.x, interactable.y)
    elseif interactable.fan then
      local orientation = interactable.fan * (math.pi / 2)
      table.insert(fans, Fan:new(interactable.x, interactable.y, orientation, interactable.strength, interactable.moveable))
    elseif interactable.flame then
      table.insert(flames, Flame:new(interactable.x, interactable.y, interactable.flame))
    elseif interactable.lava then
      table.insert(lavas, Laval:new(interactable.x, interactable.y, interactable.lava))
    end
  end

  return player, fans, flames, lavas
end

return instantiateInteratables
