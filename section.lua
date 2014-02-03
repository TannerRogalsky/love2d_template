Section = class('Section', Base)

function Section:initialize(attributes)
  for k,v in pairs(attributes or {}) do
    self[k] = v
  end
end

function Section:render()
end
