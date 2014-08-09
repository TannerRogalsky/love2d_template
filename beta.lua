local Beta = class('Beta', BoidedEntity)
-- Beta.static.instances = {}

local RADIUS = 5

function Beta:initialize(position)
  BoidedEntity.initialize(self, position, RADIUS)

end

return Beta
