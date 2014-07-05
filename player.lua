local Player = class('Player', Base):include(Stateful)
Player.static.instances = {}

function Player:initialize()
  Base.initialize(self)

  self.run_speed = 250
  self.gravity = 20
  self.jump_speed = -10
  self.teleport_distance = -300

  self.body = Collider:addRectangle(100, 100, 50, 100)
  self.body.parent = self
  self.velocity = Vector(0, 0)

  Player.instances[self.id] = self
end

function Player:destroy()
  Player.instances[self.id] = nil
  Collider:remove(self.body)
end

function Player:update(dt)
  local dx = self.run_speed
  local dy = self.gravity

  self.velocity = Vector(dx * dt, self.velocity.y + dy * dt)
  self.body:move(self.velocity:unpack())
end

function Player:draw()
  local x1,y1, x2,y2 = self.body:bbox()
  g.setColor(COLORS.red:rgb())
  g.rectangle('fill', x1, y1, x2-x1, y2-y1)
end

function Player:on_collide(dt, other, mtv_x, mtv_y)
  self.body:move(0, mtv_y)
  self.velocity = Vector(self.velocity.x, math.min(0, self.velocity.y))
end

function Player:keypressed(key, unicode)
  if key == " " then
    self:gotoState("Jumping")
  end
end

function Player:keyreleased(key, unicode)
end

return Player
