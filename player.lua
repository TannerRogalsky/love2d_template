local Player = class('Player', Base)
Player.static.instances = {}

function Player:initialize()
  Base.initialize(self)

  self.alpha = Alpha:new(Vector(g.getWidth() / 2, g.getHeight() / 2))

  Player.instances[self.id] = self
end

function Player:update(dt)
  for key,action in pairs(self.controls.keyboard) do
    if love.keyboard.isDown(key) then
      action(self, dt)
    end
  end

  self.alpha:update()
end

function Player:draw()
  self.alpha:draw()
end

function Player:up(dt)
  self.alpha._physics_body:move(0, -Alpha.SPEED * dt)
end

function Player:right(dt)
  self.alpha._physics_body:move(Alpha.SPEED * dt, 0)
end

function Player:down(dt)
  self.alpha._physics_body:move(0, Alpha.SPEED * dt)
end

function Player:left(dt)
  self.alpha._physics_body:move(-Alpha.SPEED * dt, 0)
end

function Player:destroy()
  Player.instances[self.id] = nil
  self.alpha:destroy()
end

return Player
