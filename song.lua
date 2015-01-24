local Song = class('Song', Base):include(Stateful)

function Song:initialize(data)
  Base.initialize(self)

  self.bpm = data.bpm
  self.source = love.audio.newSource(data.file)
  self.players = {}
  -- for i=1,data.players do
  --   self.players[i] = Player:new(i)
  -- end

  self.actions = {}
  self.time = 0
  self.current_beat = 0
end

function Song:update(dt)
  self.time = self.time + dt
  self.current_beat = math.floor(self.time * self.bpm / 60)
end

return Song
