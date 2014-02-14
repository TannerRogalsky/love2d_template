Bound = class('Bound', Base)

function Bound:initialize(x, y, w, h, section)
  Base.initialize(self)

  self.section = section

  self.body = love.physics.newBody(World, x + w / 2, y + h / 2, "static")
  self.shape = love.physics.newRectangleShape(w, h)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setSensor(true)
end

function Bound:render()
  g.setColor(COLORS.green:rgb())
  g.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
end

function Bound:begin_contact(other, contact)
  if instanceOf(Ball, other) and other.destroying ~= true then
    local new_section = self.section
    local nx, ny = new_section.x, new_section.y
    cron.after(0.01, function()
      local to_remove = {}
      for x, y, section in game.map.sections:each() do
        if x < nx - 1 or x > nx + 1 or y < ny - 1 or y > ny + 1 then
          table.insert(to_remove, {x, y})
        end
      end
      for _, coords in ipairs(to_remove) do
        game.map:remove_section(unpack(coords))
      end
      for x = nx - 1, nx + 1 do
        for y = ny - 1, ny + 1 do
          if not game.map.sections:contains(x, y) then
            local section = game.generator:generate(game.width, game.height)
            game.map:add_section(x, y, section)
          end
        end
      end
      game.map:bitmask_sections()
    end)
  end
end

function Bound:destroy()
  self.body:destroy()
end
