local LoseField = class('LoseField', Base):include(Stateful)
LoseField.static.instances = {}

function LoseField:initialize(x, y, w, h)
  Base.initialize(self)

  self.body = Collider:addRectangle(x, y, w, h)
  Collider:setPassive(self.body)
  self.body.parent = self

  LoseField.instances[self.id] = self
end

function LoseField:destroy()
  LoseField.instances[self.id] = nil
  Collider:remove(self.body)
end

function LoseField:draw()
  local x1,y1, x2,y2 = self.body:bbox()
  g.setColor(COLORS.blue:rgb())
  g.rectangle('line', x1, y1, x2-x1, y2-y1)
end

function LoseField:on_collide(dt, other, mtv_x, mtv_y)
  game:gotoState("Over", "You lose.")
end

return LoseField
