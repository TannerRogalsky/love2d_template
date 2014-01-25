Obstruction = class('Obstruction', Base):include(Stateful)
Obstruction.static.OVERDRAW_X = 1.2
Obstruction.static.OVERDRAW_Y = 1.2

function Obstruction:initialize(x, y, w, h)
  Base.initialize(self)

  self.image = game.preloaded_images["flesh_tube.png"]
  self.width, self.height = w, h

  self.body = love.physics.newBody(World, x, y, "static")
  self.shape = love.physics.newRectangleShape(w, h)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
end

function Obstruction:update(dt)
end

function Obstruction:render()
  g.setColor(COLORS.white:rgb())
  local x, y = self.body:getWorldCenter()
  local iw, ih = self.image:getWidth(), self.image:getHeight()
  local sx, sy = self.width / iw, self.height / ih
  sx, sy = sx * Obstruction.OVERDRAW_X, sy * Obstruction.OVERDRAW_Y
  g.draw(self.image, x, y, 0, sx, sy, self.width / sx / 2, self.height / sy / 2)
end
