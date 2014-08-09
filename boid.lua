local Boid = class('Boid', Base)
Boid.static.instances = {}

local rules = {}
local active_rules = require("boid_rules.active_rules")
local lfs = love.filesystem
local directory = "boid_rules"
for _, filename in ipairs(active_rules) do
  local file = directory .. "/" .. filename
  print(file)
  local rule = require(file:gsub("%.lua", ""))
  assert(is_func(rule), file .. " doesn't return a rule function")
  table.insert(rules, rule)
end

function Boid:initialize(position)
  assert(Vector.isvector(position))

  Base.initialize(self)

  self.position = position:clone()
  self.velocity = Vector(0, 0)

  Boid.instances[self.id] = self
end

function Boid:update(dt)
  for _,rule in ipairs(rules) do
    self.velocity = self.velocity + rule(self, Boid.instances)
  end

  local max_speed = 50
  local absolute_speed = math.abs(self.velocity:len())
  if absolute_speed > max_speed then
    self.velocity = (self.velocity / absolute_speed) * max_speed
  end

  self.position = self.position + (self.velocity * dt)
end

function Boid:destroy()
  Boid.instances[self.id] = null
end

return Boid
