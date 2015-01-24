local Song = class('Song', Base):include(Stateful)

function Song:initialize(data)
  Base.initialize(self)

  self.bpm = data.bpm
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
    self.players[i] = Player:new(self.actions_by_player[i])
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

function Song:tick_beat()
  print(self.current_beat, self.players[1]:get_action(self.current_beat))
end

return Song
