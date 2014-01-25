Level = class('Level', Base)

function Level:initialize(data)
  Base.initialize(self)

  local width, height = data.width, data.height
  self.offset = {x = (g.getWidth() - width) / 2, y = (g.getHeight() - height) / 2}

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
  self.bounds = {}
  local function new_bound(x1, y1, x2, y2)
    local object = {}
    object.body = love.physics.newBody(World, 0, 0, "static")
    object.shape = love.physics.newEdgeShape(x1, y1, x2, y2)
    object.fixture = love.physics.newFixture(object.body, object.shape)

    table.insert(self.bounds, object)

    return object
  end
  new_bound(0, 0, width, 0)
  new_bound(0, 0, 0, height)
  new_bound(width, 0, width, height)
  new_bound(0, height, width, height)

  -- goals & player tweaks
  local id, player = next(Player.instances)
  GoalObject:new(player, width - 50, height / 3, 50, height / 3)
  player.spawn_point = {x = width / 4, y = height / 2}

  id, player = next(Player.instances, id)
  GoalObject:new(player, 0, height / 3, 50, height / 3)
  player.spawn_point = {x = width / 4 * 3, y = height / 2}
end

function Level:update(dt)
end

function Level:render()
  g.setColor(COLORS.green:rgb())
  for _,bound in ipairs(self.bounds) do
    g.line(bound.body:getWorldPoints(bound.shape:getPoints()))
  end

  for _,goal_object in pairs(GoalObject.instances) do
    goal_object:render()
  end

  g.setColor(COLORS.blue:rgb())
  for _,obstruction in pairs(self.obstructions) do
    obstruction:render()
  end

  for _,trap in pairs(self.traps) do
    trap:render()
  end
end
