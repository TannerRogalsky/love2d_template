local Platform = class('Platform', Base):include(Stateful)
Platform.static.instances = {}

function Platform:initialize(x, y, w, h)
  Base.initialize(self)

  self.body = Collider:addRectangle(x, y, w, h)
  Collider:setPassive(self.body)
  self.body.parent = self

  Platform.instances[self.id] = self
end

function Platform:destroy()
  Platform.instances[self.id] = nil
  Collider:remove(self.body)
end

function Platform:draw()
  local x1,y1, x2,y2 = self.body:bbox()
  g.setColor(COLORS.green:rgb())
  g.rectangle('line', x1, y1, x2-x1, y2-y1)
end

return Platform
