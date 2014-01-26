Level = class('Level', Base)

function Level:initialize(data)
  Base.initialize(self)

  local width, height = data.width, data.height
  self.offset = {x = (g.getWidth() - width) / 2, y = (g.getHeight() - height) / 2}

  self.background_image = game.preloaded_images["background2.png"]
  local iw, ih = self.background_image:getWidth(), self.background_image:getHeight()
  self.background_quad = g.newQuad(-self.offset.x, -self.offset.y, g.getWidth(), g.getHeight(), iw, ih)
  self.background_image:setWrap("repeat", "repeat")

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

  for _,player_data in ipairs(data.players) do
    Player:new(unpack(player_data))
  end

  -- goals & spawn points
  for id,player in pairs(Player.instances) do
    local position = data.player_positions[player.direction]
    local goal = GoalObject:new(player, unpack(position.goal))
    goal.draw_hints = position.goal_draw_hints
    player.spawn_point = position.spawn_point
    player.score_text_position = position.score_text_position
  end

  -- the ball(s)
  BallObject:new(width / 2, height / 2)
  cron.every(10, function()
    BallObject:new(width / 2, height / 2)
  end)
  if data.powerups then
    cron.every(data.powerup_spawn_time, function()
      local geometry = table.sample(data.powerups).geometry
      PowerUp:new(unpack(geometry))
    end)
  end
end

function Level:update(dt)
  for _,goal_object in pairs(GoalObject.instances) do
    goal_object:update(dt)
  end
end

function Level:render()
  g.setColor(COLORS.white:rgb())
  g.draw(self.background_image, self.background_quad, -self.offset.x, -self.offset.y)

  g.setColor(COLORS.green:rgb())
  for _,bound in ipairs(self.bounds) do
    g.line(bound.body:getWorldPoints(bound.shape:getPoints()))
  end

  for _,trap in pairs(self.traps) do
    trap:render()
  end

  for _,powerup in pairs(PowerUp.instances) do
    powerup:render()
  end

  for _,ball_object in pairs(BallObject.instances) do
    ball_object:render()
  end

  for _,goal_object in pairs(GoalObject.instances) do
    goal_object:render()
  end

  for _,obstruction in pairs(self.obstructions) do
    obstruction:render()
  end
end
