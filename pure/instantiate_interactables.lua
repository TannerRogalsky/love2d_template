local function instantiateInteratables(interactables)
  local player
  local fans = {}

  for i,interactable in ipairs(interactables) do
    -- print(inspect(interactable))
    if interactable.player then
      player = Player:new(interactable.x, interactable.y)
    elseif interactable.fan then
      local orientation = interactable.fan * (math.pi / 2)
      table.insert(fans, Fan:new(interactable.x, interactable.y, orientation))
    end
  end

  return player, fans
end

return instantiateInteratables
