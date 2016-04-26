local Base = require('base')
local PhysicsObject = class('PhysicsObject', Base)

local globalFixtures = setmetatable(t, { __mode = 'k' })

--- PhysicsObject class constructor.
function PhysicsObject:initialize(fixtures)
  Base.initialize(self)

  if type(fixtures) ~= 'table' then
    fixtures = {fixtures}
  end

  assert(#fixtures > 1, 'PhysicsObject expects at least one fixture')

  for _, fixture in ipairs(fixtures) do
    assert(fixture.type and fixture:type() == 'Fixture', 'PhysicsObject expects a table of fixtures')
    fixture:setUserData(self)
  end

  globalFixtures[self] = fixtures
end

--- Function to be called to draw the object.
--
-- Ensures a minimum functionality. Can be overridden.
function PhysicsObject:draw()
  local lineJoin = love.graphics.getLineJoin()
  love.graphics.setLineJoin('none')

  local fixtures = globalFixtures[self]

  local color = {}
  for i,fixture in ipairs(fixtures) do
    local body = fixture:getBody()

    if not body:isAwake() then
      color={100, 100, 100, 255}
    else
      color={100, 200, 255, 255}
    end

    local bodyX, bodyY = body:getPosition()
    local bodyAngle = body:getAngle()

    local shape=fixture:getShape()
    local shapeType = shape:type()
    local shapeR=shape:getRadius()
    if shapeType=="CircleShape" then
      color[4]=255
      love.graphics.setColor(color)
      love.graphics.circle("line", bodyX, bodyY, shapeR)
      love.graphics.line(bodyX,bodyY,bodyX+math.cos(bodyAngle)*shapeR,bodyY+math.sin(bodyAngle)*shapeR)
      color[4]=50
      love.graphics.setColor(color)
      love.graphics.circle("fill", bodyX, bodyY, shapeR)
    elseif shapeType=="ChainShape" or shapeType=="EdgeShape" then
      color[4]=255
      love.graphics.setColor(color)
      love.graphics.line(body:getWorldPoints(shape:getPoints()))
    else
      color[4]=255
      love.graphics.setColor(color)
      love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
      color[4]=50
      love.graphics.setColor(color)
      love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
    end
  end

  love.graphics.setLineJoin(lineJoin)
end


return PhysicsObject
