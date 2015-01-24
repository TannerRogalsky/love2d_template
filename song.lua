local Song = class('Song', Base):include(Stateful)

function Song:initialize(data)
  Base.initialize(self)

  self.bpm = data.bpm
  self.length = data.length
  self.source = love.audio.newSource(data.file)
  -- self.source:play()

  self.players = {}
  self.actions = {}

  self.actions_by_player = {}
  for _,action in ipairs(data.actions) do
    if self.actions_by_player[action.player] == nil then
      self.actions_by_player[action.player] = {}
    end

    table.insert(self.actions_by_player[action.player], action)
  end

  for i=1,data.players do
    local actions = self.actions_by_player[i]
    table.sort(actions, function(a, b)
      return a.start_time < b.start_time
    end)
    local state_sequence = self:build_state_sequence(actions)

    self.players[i] = Player:new(self.actions_by_player[i], state_sequence)
    print(self.players[i]:buttons_sequence_to_string())
    self.actions[i] = {}
  end

  self.time = -data.starting_offset
  self.current_beat = 0
end

function Song:update(dt)
  self.time = self.time + dt
  local beat = math.floor(self.time * self.bpm / 60)
  if beat ~= self.current_beat then
    self.current_beat = beat
    self:tick_beat()
  end
end

function Song:build_state_sequence(actions)
  local state_sequence = {}
  local current_action_index = 1
  local current_action = actions[current_action_index]
  for beat = current_action.start_time, self.length do
    state_sequence[beat] = {}
    local loop_time = (current_action.hold_time or 1) + (current_action.rest_time or 0)
    local start_time_offset = beat - current_action.start_time
    local iteration = math.floor(starting_offset / loop_time)
    state_sequence[beat].button = current_action.gamepadbutton or Button.None

    local next_action = actions[current_action_index + 1]
    if next_action and beat >= next_action.start_time then
      current_action_index = current_action_index + 1
      current_action = actions[current_action_index]
    end
  end

  return state_sequence
end


function Song:tick_beat()
  print(self.current_beat, self.players[1]:get_state(self.current_beat).button)
end

return Song
