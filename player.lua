local Player = class('Player', Base):include(Stateful)

function Player:initialize(actions, state_sequence, position)
  Base.initialize(self)

  self.successes = {}
  self.failures = {}

  self.position = position
  self.actions = actions
  self.state_sequence = state_sequence
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

function Player.buttons_sequence_to_string(state_sequence)
  local buttons = {}
  for i,state in ipairs(state_sequence) do
    buttons[i] = state.button
  end
  return table.concat(buttons, '')
end

function Player:destroy()
end

return Player
