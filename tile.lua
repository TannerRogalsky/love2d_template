Tile = class('Tile', Base)

function Tile:initialize(attributes)
  for k,v in pairs(attributes) do
    self[k] = v
  end
end

function Tile:render()
  local w, h = self.width, self.height
  local px, py = (self.x - 1) * w, (self.y - 1) * h

  -- if self.bit_value == 1 then
  --   g.setColor(COLORS.yellow:rgb())
  --   g.rectangle("fill", px, py, self.width, self.height)
  -- end

  if self.body then
    g.setColor(self.color:rgba())
    g.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
  end
  -- g.setColor(COLORS.black:rgba())
  -- g.print(self.masked_value, px, py)
end

function Tile:set_mask_data(masked_value)
  self.masked_value = masked_value
  local mask_data = Generator.mask_data[self.masked_value]

  self.color = mask_data.color

  local vertices = mask_data.geometry
  local w, h = self.width, self.height
  local px, py = (self.x - 1) * w, (self.y - 1) * h

  if self.bit_value == 1 then
    self.body = love.physics.newBody(World, px, py, "static")
    self.shape = love.physics.newPolygonShape(unpack(vertices))
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
    self.fixture:setGroupIndex(-1)
  end
end
