local WinField = class('WinField', Base):include(Stateful)
WinField.static.instances = {}

function WinField:initialize(x, y, w, h)
  Base.initialize(self)

  self.body = Collider:addRectangle(x, y, w, h)
  Collider:setPassive(self.body)
  self.body.parent = self

  WinField.instances[self.id] = self
end

function WinField:destroy()
  WinField.instances[self.id] = nil
  Collider:remove(self.body)
end

function WinField:draw()
  local x1,y1, x2,y2 = self.body:bbox()
  g.setColor(COLORS.blue:rgb())
  g.rectangle('line', x1, y1, x2-x1, y2-y1)
end

function WinField:on_collide(dt, other, mtv_x, mtv_y)
  game:gotoState("Over", "You win!")
end

return WinField
