local Song = class('Song', Base):include(Stateful)

function Song:initialize(data)
  Base.initialize(self)

  self.bpm = data.bpm
  self.length = data.length
  self.scroll_speed = data.scroll_speed or 20
  self.source = love.audio.newSource(data.file)
  self.source:setVolume(0.5)
  self.source:play()

  self.players = {}
  self.actions = {}

  self.actions_by_player = {}
  for _,action in ipairs(data.actions) do
    if self.actions_by_player[action.player] == nil then
      self.actions_by_player[action.player] = {}
    end

    table.insert(self.actions_by_player[action.player], action)
  end

  self.sequences = {}
  for index,actions in ipairs(self.actions_by_player) do
    table.sort(actions, function(a, b)
      return a.start_time < b.start_time
    end)
    self.sequences[index] = self:build_state_sequence(actions)
  end

  for i=1,data.players do
    local actions = self.actions_by_player[i]
    local state_sequence = self:build_state_sequence(actions)
    self.players[i] = Player:new(self.actions_by_player[i], state_sequence, i - 1)
    self.players[i].image = game.preloaded_images["bg_p" .. i .. ".png"]
    self.actions[i] = {}
  end

  self.unused_sequence = self:build_state_sequence(self.actions_by_player[3])
  self.unused_sequence_position = 2

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

function Song:player_at_position(position)
  local player = nil
  for i,player in ipairs(self.players) do
    if player.position == position then
      return player
    end
  end
  return player
end

function Song:gamepadpressed(joystick, button)
  local player = self.players[joystick:getID()]
  if player == nil then return false end

  local success = self:is_action_valid(player, joystick, button, self.current_beat)
  if success then
    good_audio[math.random(#good_audio)]:play()
    table.insert(player.successes, self.current_beat)
  else
    table.insert(player.failures, self.current_beat)
  end
end

function Song:is_action_valid(player, joystick, button, beat)
  local leftx = joystick:getGamepadAxis('leftx')
  local lefty = joystick:getGamepadAxis('lefty')
  if leftx > 0.5 then
    leftx = 1
  elseif leftx < -0.5 then
    leftx = -1
  else
    leftx = 0
  end

  if lefty > 0.5 then
    lefty = 1
  elseif lefty < -0.5 then
    lefty = -1
  else
    lefty = 0
  end

  local state = player:get_state(beat)
  -- print(state.button, state.stick.leftx, state.stick.lefty)
  -- print(state.button == button, state.stick.leftx == leftx, state.stick.lefty == lefty)
  return state.button == button and state.stick.leftx == leftx and state.stick.lefty == lefty
end

function Song:build_state_sequence(actions)
  local state_sequence = {}
  local current_action_index = 1
  local current_action = actions[current_action_index]
  for beat = current_action.start_time, self.length do
    local next_action = actions[current_action_index + 1]
    if next_action and beat >= next_action.start_time then
      current_action_index = current_action_index + 1
      current_action = actions[current_action_index]
    end

    state_sequence[beat] = {}
    local loop_time = current_action.hold_time + current_action.rest_time
    local start_time_offset = beat - current_action.start_time
    local iteration = math.floor(start_time_offset / loop_time)
    local iteration_start_beat = current_action.start_time + loop_time * iteration
    local iteration_hold_start = iteration_start_beat
    local iteration_hold_end = iteration_hold_start + current_action.hold_time

    if beat >= iteration_hold_start and beat < iteration_hold_end then
      state_sequence[beat].button = current_action.gamepadbutton or Button.None
    else
      state_sequence[beat].button = Button.None
    end
    -- print(beat, iteration_start_beat, iteration_hold_start, iteration_hold_end,
      -- loop_time, state_sequence[beat].button)
    state_sequence[beat].stick = current_action.gamepadaxis or Stick.None
  end

  return state_sequence
end


function Song:tick_beat()
  -- print(self.current_beat, self.players[1]:get_state(self.current_beat).button)
end

return Song
