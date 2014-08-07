local Boid = class('Boid', Base)
Boid.static.instances = {}

local rules = {}
local lfs = love.filesystem
local directory = "boid_rules"
for index,filename in ipairs(lfs.getDirectoryItems(directory)) do
  local file = directory .. "/" .. filename
  if lfs.isFile(file) and file:match("%.lua$") then
    local rule = require(file:gsub("%.lua", ""))
    assert(is_func(rule), file .. " doesn't return a rule function")
    table.insert(rules, rule)
  end
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
  self.velocity = Vector(
    math.clamp(-max_speed, self.velocity.x, max_speed),
    math.clamp(-max_speed, self.velocity.y, max_speed)
  )

  self.position = self.position + (self.velocity * dt)
end

function Boid:destroy()
  Boid.instances[self.id] = null
end

return Boid
