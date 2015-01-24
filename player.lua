local Player = class('Player', Base):include(Stateful)
Player.static.instances = {}
Player.static.instance_count = 0

function Player:initialize(actions, state_sequence)
  Base.initialize(self)

  self.actions = actions
  self.state_sequence = state_sequence

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

function Player:get_state(beat)
  return self.state_sequence[beat]
end

function Player:next_action(beat)

end

function Player:buttons_sequence_to_string()
  local buttons = {}
  for i,state in ipairs(self.state_sequence) do
    buttons[i] = state.button
  end
  return table.concat(buttons, '')
end

function Player:destroy()
  Player.instances[self.id] = nil
  Player.instance_count = Player.instance_count - 1
end

return Player
