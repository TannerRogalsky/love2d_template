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

    return object
  end
  for _,bound_data in ipairs(data.bounds) do
    table.insert(self.bounds, new_bound(unpack(bound_data.geometry)))
  end

  -- goals & spawn points
  for id,player in pairs(Player.instances) do
    local position = data.player_positions[player.direction]
    GoalObject:new(player, unpack(position.goal))
    player.spawn_point = position.spawn_point
    player.score_text_position = position.score_text_position
  end

  -- the ball(s)
  BallObject:new(width / 2, height / 2)
  cron.every(10, function()
    BallObject:new(width / 2, height / 2)
  end)
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

  for _,obstruction in pairs(self.obstructions) do
    obstruction:render()
  end

  for _,trap in pairs(self.traps) do
    trap:render()
  end
end
