local Menu = Game:addState('Menu')
local SUIT = require('lib.SUIT')

function Menu:enteredState()
  self.previews = {}

  local world = love.physics.newWorld()

  for name,level in pairs(self.preloaded_levels) do
    love.math.setRandomSeed(tonumber(level.seed.text))

    local canvas = g.newCanvas(500, 500)
    g.setCanvas(canvas)

    for _,object in ipairs(level.objects) do
      if object.type == 'start' then
        Ball:new(world, object.x, object.y, object.radius):draw()
      elseif object.type == 'obstacle' then
        local obstacle = Obstacle:new(world, object.x, object.y, object.radius)
        obstacle:draw()
        obstacle:destroy()
      elseif object.type == 'end' then
        Goal:new(world, object.x, object.y, object.radius):draw()
      end
    end

    g.setCanvas()
    self.previews[name] = canvas
  end

  world:destroy()
end

local hovered = false

function Menu:draw()
  if hovered then
    g.setColor(255, 255, 255)
    local preview = self.previews[hovered]
    local x = g.getWidth() / 2 - preview:getWidth() / 2
    local y = g.getHeight() / 2 - preview:getHeight() / 2
    g.draw(preview, x, y)
  end

  SUIT.draw()
end

function Menu:update(dt)
  SUIT.layout:reset(g.getWidth() / 2 - 100, 50)

  hovered = false
  for name,level in pairs(self.preloaded_levels) do
    local button = SUIT.Button(name, SUIT.layout:row(200, 30))
    if button.hit then
      self:gotoState("Main", level)
    end

    if button.hovered then
      hovered = name
    end
  end
end

function Menu:exitedState()
end

return Menu
