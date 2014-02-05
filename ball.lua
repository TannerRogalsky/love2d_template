Ball = class('Ball', Base)

function Ball:initialize(attributes)
  Base.initialize(self)
  for k,v in pairs(attributes or {}) do
    self[k] = v
  end
end

function Ball:render()
end
