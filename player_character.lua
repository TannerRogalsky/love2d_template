local PlayerCharacter = class('PlayerCharacter', Base):include(Stateful)
PlayerCharacter.static.instances = {}

function PlayerCharacter:initialize(x, y, w, h)
  Base.initialize(self)

  PlayerCharacter.instances[self.id] = self
end

return PlayerCharacter
