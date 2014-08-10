local Resource = class('Resource', Base)
Resource.static.instances = {}
Resource.static.RADIUS = 2

function Resource:initialize(position, section)
  Base.initialize(self)

  self.image = game.preloaded_images["resource.png"]
  self.position = position:clone()
  self.radius = Resource.RADIUS
  self.section = section

  self._physics_body = Collider:addCircle(self.position.x, self.position.y, self.radius)
  self._physics_body.parent = self

  Resource.instances[self.id] = self
end

function Resource:draw()
  g.setColor(COLORS.white:rgb())
  g.draw(self.image, self.position.x, self.position.y, 0, 1, 1, self.radius + 3, self.radius + 3)
end

function Resource:on_collide(dt, object_two, mtv_x, mtv_y)
  if object_two:isInstanceOf(Beta) then
    self:destroy()
  end
end

function Resource:destroy()
  self.section.resources[self.id] = nil
  Collider:remove(self._physics_body)
  Resource.instances[self.id] = nil
end

return Resource
