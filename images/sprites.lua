-- Generated with TexturePacker (http://www.codeandweb.com/texturepacker)
-- with a custom export by Stewart Bracken (http://stewart.bracken.bz)
--
-- $TexturePacker:SmartUpdate:2d5be8ae5cdfe96719bb71e511598afa:60c3122a9c26ac84994c8030f6191ba4:ce59e0ef6b4af9fefc088af809f682f1$
--
--[[------------------------------------------------------------------------
-- Example Usage --

function love.load()
	myAtlas = require("sprites")
	batch = love.graphics.newSpriteBatch( myAtlas.texture, 100, "stream" )
end
function love.draw()
	batch:clear()
	batch:bind()
		batch:add( myAtlas.quads['mySpriteName'], love.mouse.getX(), love.mouse.getY() )
	batch:unbind()
	love.graphics.draw(batch)
end

--]]------------------------------------------------------------------------

local TextureAtlas = {}
local Quads = {}
local Texture = game.preloaded_images["sprites.png"]

Quads["bg"] = love.graphics.newQuad(1, 1, 1024, 600, 1115, 602 )
Quads["cloud1"] = love.graphics.newQuad(1027, 568, 42, 19, 1115, 602 )
Quads["cloud2"] = love.graphics.newQuad(1079, 1, 33, 22, 1115, 602 )
Quads["cloud3"] = love.graphics.newQuad(1077, 105, 36, 19, 1115, 602 )
Quads["fan_blue_no_trolley_1"] = love.graphics.newQuad(1074, 313, 39, 50, 1115, 602 )
Quads["fan_blue_no_trolley_2"] = love.graphics.newQuad(1073, 417, 39, 50, 1115, 602 )
Quads["fan_blue_trolley_1"] = love.graphics.newQuad(1027, 1, 50, 50, 1115, 602 )
Quads["fan_blue_trolley_2"] = love.graphics.newQuad(1027, 53, 50, 50, 1115, 602 )
Quads["flame00"] = love.graphics.newQuad(1027, 365, 44, 50, 1115, 602 )
Quads["flame01"] = love.graphics.newQuad(1027, 105, 48, 50, 1115, 602 )
Quads["flame02"] = love.graphics.newQuad(1027, 417, 44, 50, 1115, 602 )
Quads["flame03"] = love.graphics.newQuad(1073, 365, 41, 50, 1115, 602 )
Quads["flame04"] = love.graphics.newQuad(1027, 469, 44, 50, 1115, 602 )
Quads["flame05"] = love.graphics.newQuad(1027, 157, 48, 50, 1115, 602 )
Quads["flame06"] = love.graphics.newQuad(1027, 209, 48, 50, 1115, 602 )
Quads["flame07"] = love.graphics.newQuad(1027, 313, 45, 50, 1115, 602 )
Quads["flame08"] = love.graphics.newQuad(1027, 261, 48, 50, 1115, 602 )
Quads["flame09"] = love.graphics.newQuad(1027, 521, 44, 45, 1115, 602 )

function TextureAtlas:getDimensions(quadName)
	local quad = self.quads[quadName]
	if not quad then
		return nil
	end
	local x, y, w, h = quad:getViewport()
    return w, h
end

TextureAtlas.quads = Quads
TextureAtlas.texture = Texture

return TextureAtlas
