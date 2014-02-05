Bound = class('Bound', Base)

function Bound:initialize(attributes)
  Base.initialize(self)
  for k,v in pairs(attributes or {}) do
    self[k] = v
  end
end

function Bound:render()
end
