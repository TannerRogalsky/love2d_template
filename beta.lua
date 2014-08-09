local Beta = class('Beta', BoidedEntity)
-- Beta.static.instances = {}

local RADIUS = 5

function Beta:initialize(position, alpha)
  BoidedEntity.initialize(self, position, RADIUS)
  self.alpha = alpha
end

return Beta
