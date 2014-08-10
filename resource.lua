local Resource = class('Resource', Base)
Resource.static.instances = {}

function Resource:initialize(position)
  Base.initialize(self)

  self.image = game.preloaded_images["resource.png"]
  self.position = position:clone()
end
