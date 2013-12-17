Direction = class('Direction', Base)

function Direction:initialize(x, y)
  Base.initialize(self)
  self.x = x
  self.y = y

  if self.x == 0 and self.y == -1 then
    self.cardinal_name = "NORTH"
  elseif self.x == 0 and self.y == 1 then
    self.cardinal_name = "SOUTH"
  elseif self.x == 1 and self.y == 0 then
    self.cardinal_name = "EAST"
  elseif self.x == -1 and self.y == 0 then
    self.cardinal_name = "WEST"
  end
end

function Direction:unpack()
  return self.x, self.y
end

-- will sterilize the vector and return the most appropriate direction
function Direction.static.from_vector(x, y)

  -- only use the largest
  if math.abs(x) > math.abs(y) then y = 0 else x = 0 end

  -- is there a better way to force numbers to 1 or -1 depending on their sign?
  if x < 0 then x = -1 end
  if x > 0 then x = 1 end
  if y < 0 then y = -1 end
  if y > 0 then y = 1 end

  return Direction[x][y]
end

Direction.NORTH = Direction:new(0, -1)
Direction.SOUTH = Direction:new(0, 1)
Direction.EAST = Direction:new(1, 0)
Direction.WEST = Direction:new(-1, 0)

Direction[-1], Direction[0], Direction[1] = {}, {}, {}
Direction[0][-1] = Direction.NORTH
Direction[0][1] = Direction.SOUTH
Direction[1][0] = Direction.EAST
Direction[-1][0] = Direction.WEST

Direction.list = { Direction.NORTH, Direction.EAST, Direction.SOUTH, Direction.WEST}
