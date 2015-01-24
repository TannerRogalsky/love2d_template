local Song = class('Song', Base):include(Stateful)

function Song:initialize(data)
  Base.initialize(self)

  self.bpm = data.bpm
  self.source = love.audio.newSource(data.file)
  self.source:play()

  self.players = {}
  self.actions = {}
  for i=1,data.players do
    self.players[i] = Player:new(i)
    self.actions[i] = {}
  end

  for i,action in ipairs(data.actions) do
    print(i,action)
  end

  self.time = -data.starting_offset
  self.current_beat = 0
end

function Song:update(dt)
  self.time = self.time + dt
  local beat = math.floor(self.time * self.bpm / 60)
  if beat ~= self.current_beat then
    self:tick_beat()
    self.current_beat = beat
  end
end

function Song:tick_beat()
  -- print("oonce")
end

return Song
