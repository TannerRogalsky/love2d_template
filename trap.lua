Trap = class('Trap', Base):include(Stateful)
Trap.static.SIZE_INCREASE = 1.5

function Trap:initialize(x, y, w, h)
  Base.initialize(self)

  self.image = game.preloaded_images["trap.png"]
  self.width, self.height = w * Trap.SIZE_INCREASE, h * Trap.SIZE_INCREASE

  self.body = love.physics.newBody(World, x, y, "kinematic")
  self.shape = love.physics.newCircleShape(w / 2)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setSensor(true)
end

function Trap:update(dt)
end

function Trap:render()
  local x, y = self.body:getWorldCenter()
  local iw, ih = self.image:getWidth(), self.image:getHeight()
  local sx, sy = self.width / iw, self.height / ih
  g.setColor(COLORS.white:rgb())
  g.draw(self.image, x, y, 0, sx, sy, self.width / sx / 2, self.height / sy / 2)
end

function Trap:begin_contact(other, contact)
  if instanceOf(ControlledObject, other) then
    other:destroy()
  end
end
