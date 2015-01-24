local Player = class('Player', Base):include(Stateful)
Player.static.instances = {}
Player.static.instance_count = 0

function Player:initialize(actions)
  Base.initialize(self)

  self.actions = actions
  table.sort(self.actions, function(a, b)
    return a.start_time < b.start_time
  end)

  Player.instances[self.id] = self
  Player.instance_count = Player.instance_count + 1
end

function Player:get_action(beat)
  local previous = self.actions[0]
  for i,action in ipairs(self.actions) do
    if action.start_time > beat then
      return previous
    end
    previous = action
  end
end

function Player:next_action(beat)

end

function Player:destroy()
  Player.instances[self.id] = nil
  Player.instance_count = Player.instance_count - 1
end

return Player
