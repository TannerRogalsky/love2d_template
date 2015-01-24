local Player = class('Player', Base):include(Stateful)
Player.static.instances = {}
Player.static.instance_count = 0

function Player:initialize()
  Base.initialize(self)
  Player.instances[self.id] = self
  Player.instance_count = Player.instance_count + 1
end

function Player:update(dt)

end

function Player:destroy()
  Player.instances[self.id] = nil
  Player.instance_count = Player.instance_count - 1
end

return Player
