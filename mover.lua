local Mover = class('Mover', Base):include(Stateful)
Mover.static.instances = {}

function Mover:initialize(things)
  Base.initialize(self)

  self.things = things

  for i,thing in ipairs(things) do
    thing.mover = self
  end

  Mover.instances[self.id] = self

  self.move_cron = cron.every(1 + love.math.random(), function()
    local dx = love.math.random(1, 3) - 2
    local dy = love.math.random(1, 3) - 2

    for i,thing in ipairs(self.things) do
      thing:move(dx, dy)
    end
  end)
end

function Mover:merge(thing)
  table.insert(self.things, thing)

  local index
  for i,other in ipairs(thing.mover.things) do
    if other == thing then
      index = i
      break
    end
  end

  table.remove(thing.mover.things, index)
  -- print(index, #thing.mover.things)
end

function Mover:update(dt)
  self.move_cron:update(dt)
end

function Mover:destroy()
  Mover.instances[self.id] = nil
end

return Mover