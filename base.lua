local Base = class('Base')

--- Base class constructor.
--
-- Probably doesn't make sense to call directly. Should only be used by subclasses.
function Base:initialize()
  self.id = generateID()
end

--- Function to be called to update the object.
--
-- Ensures a minimum functionality. Can be overridden.
function Base:update()
end

--- Function to be called to draw the object.
--
-- Ensures a minimum functionality. Can be overridden.
function Base:render()
end

--- Returns a string representation of the object.
function Base:__tostring()
  return "Instance of ".. self.class.name .." with ID ".. self.id
end

function Base.__concat(value1, value2)
  return tostring(value1) .. tostring(value2)
end

return Base
