local Section = class('Section', Base)
Section.static.instances = {}

function Section:initialize(player, x, y, w, h)
  Base.initialize(self)

  self.player = player
  if self.player then
    self.player.section = self
    self.player.alpha._physics_body:moveTo(x + w / 2, y + h / 2)
  end

  self.x, self.y, self.w, self.h = x, y, w, h
  self.boids = {}
  self.alphas = {}
  self.resources = {}

  Section.instances[self.id] = self
end

function Section:draw()
  if self.player then
    g.setColor(self.player.color:rgb())
  else
    g.setColor(COLORS.purple:rgb())
  end
  g.rectangle("fill", self.x, self.y, self.w, self.h)
  g.setColor(COLORS.black:rgb())
  g.rectangle("line", self.x, self.y, self.w, self.h)
end

function Section:update(dt)
  local shapes = Collider:shapesInRange(self.x, self.y, self.x + self.w, self.y + self.h)
  self.boids = {}
  self.alphas = {}
  for _,shape in pairs(shapes) do
    local boid = shape.boid
    if boid then
      boid.section = self
      self.boids[boid.id] = boid
    elseif shape.parent:isInstanceOf(Alpha) then
      self.alphas[shape.parent.id] = shape.parent
    end
  end
end

function Section:spawn_new_resources(probability)
  local r = love.math.random
  local size_x, size_y = 20, 20
  local sx, sy = self.w / size_x - 1, self.h / size_y - 1
  for x=0,sx do
    for y=0,sy do
      if r() <= probability then
        local ox, oy = r(size_x), r(size_y)
        Resource:new(Vector(self.x + ox + x * size_x, self.y + oy + y * size_y))
      end
    end
  end
end

function Section:shapesInRange()
  return Collider:shapesInRange(self.x, self.y, self.x + self.w, self.y + self.h)
end

function Section:destroy()
  Section.instances[self.id] = nil
end

return Section
