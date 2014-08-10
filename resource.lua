local Resource = class('Resource', Base)
Resource.static.instances = {}

function Resource:initialize(position)
  Base.initialize(self)
end
