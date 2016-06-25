local function instantiateInteratables(interactables)
  local player
  local fans = {}
  local flames = {}

  for i,interactable in ipairs(interactables) do
    -- print(inspect(interactable))
    if interactable.player then
      player = Player:new(interactable.x, interactable.y)
    elseif interactable.fan then
      local orientation = interactable.fan * (math.pi / 2)
      table.insert(fans, Fan:new(interactable.x, interactable.y, orientation, interactable.strength, interactable.moveable))
    elseif interactable.flame then
      table.insert(flames, Flame:new(interactable.x, interactable.y, interactable.flame))
    end
  end

  return player, fans, flames
end

return instantiateInteratables
