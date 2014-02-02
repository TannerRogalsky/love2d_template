Map = class('Map', Base)

function Map:initialize(attributes)
  for k,v in pairs(attributes or {}) do
    self[k] = v
  end
end

function Map:render()
end
