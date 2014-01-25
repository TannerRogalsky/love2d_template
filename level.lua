Level = class('Level', Base)

function Level:initialize(data)
  Base.initialize(self)

  self.obstructions = {}
  for _,obstructon_data in ipairs(data.obstructions) do
    local obstruction = Obstruction:new(unpack(obstructon_data.geometry))
    self.obstructions[obstruction.id] = obstruction
  end

  self.traps = {}
  for _,trap_data in ipairs(data.traps) do
    local trap = Trap:new(unpack(trap_data.geometry))
    self.traps[trap.id] = trap
  end

  -- set up bounds
  local function new_bound(x1, y1, x2, y2)
    local object = {}
    object.body = love.physics.newBody(World, 0, 0, "static")
    object.shape = love.physics.newEdgeShape(x1, y1, x2, y2)
    object.fixture = love.physics.newFixture(object.body, object.shape)
    return object
  end
  new_bound(0, 0, g.getWidth(), 0)
  new_bound(0, 0, 0, g.getHeight())
  new_bound(g.getWidth(), 0, g.getWidth(), g.getHeight())
  new_bound(0, g.getHeight(), g.getWidth(), g.getHeight())
end

function Level:update(dt)
end

function Level:render()
  g.setColor(COLORS.blue:rgb())
  for _,obstruction in pairs(self.obstructions) do
    obstruction:render()
  end

  for _,trap in pairs(self.traps) do
    trap:render()
  end
end
