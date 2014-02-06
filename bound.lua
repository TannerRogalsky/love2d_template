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
  -- print("begin", self.section.x, self.section.y)
  if instanceOf(Ball, other) then
    other.current_section = self.section
  end
end

function Bound:end_contact(other, contact)
  -- print("end", self.section.x, self.section.y)
  if instanceOf(Ball, other) then
    local new_section = other.current_section
    local old_section = self.section
    local dx, dy = new_section.x - old_section.x, new_section.y - old_section.y
    local rx, ry = old_section.x - dx, old_section.y - dy
    local nx, ny = new_section.x + dx, new_section.y + dy
    print(dx, dy, rx, ry, nx, ny)
    cron.after(0.1, function()
      game.map:remove_section(rx, ry)
      local section = game.generator:generate(game.width, game.height)
      game.map:add_section(nx, ny, section)
    end)
  end
end

function Bound:destroy()
  self.body:destroy()
end