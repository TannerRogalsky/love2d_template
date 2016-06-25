-- Generated with TexturePacker (http://www.codeandweb.com/texturepacker)
-- with a custom export by Stewart Bracken (http://stewart.bracken.bz)
--
-- $TexturePacker:SmartUpdate:b03fae90702b7f9c4c4f53239ca06083:c682e53a804c1b37f3adcae0407ad7ef:ce59e0ef6b4af9fefc088af809f682f1$
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

Quads["bg"] = love.graphics.newQuad(1, 1, 1024, 600, 1226, 624 )
Quads["cloud1"] = love.graphics.newQuad(1131, 573, 42, 42, 1226, 624 )
Quads["cloud2"] = love.graphics.newQuad(1175, 573, 42, 42, 1226, 624 )
Quads["cloud3"] = love.graphics.newQuad(1183, 1, 42, 42, 1226, 624 )
Quads["fan_blue_no_trolley_1"] = love.graphics.newQuad(1027, 1, 50, 50, 1226, 624 )
Quads["fan_blue_no_trolley_2"] = love.graphics.newQuad(1027, 53, 50, 50, 1226, 624 )
Quads["fan_blue_trolley_1"] = love.graphics.newQuad(1027, 105, 50, 50, 1226, 624 )
Quads["fan_blue_trolley_2"] = love.graphics.newQuad(1027, 157, 50, 50, 1226, 624 )
Quads["flame00"] = love.graphics.newQuad(1027, 209, 50, 50, 1226, 624 )
Quads["flame01"] = love.graphics.newQuad(1027, 261, 50, 50, 1226, 624 )
Quads["flame02"] = love.graphics.newQuad(1027, 313, 50, 50, 1226, 624 )
Quads["flame03"] = love.graphics.newQuad(1027, 365, 50, 50, 1226, 624 )
Quads["flame04"] = love.graphics.newQuad(1027, 417, 50, 50, 1226, 624 )
Quads["flame05"] = love.graphics.newQuad(1027, 469, 50, 50, 1226, 624 )
Quads["flame06"] = love.graphics.newQuad(1027, 521, 50, 50, 1226, 624 )
Quads["flame07"] = love.graphics.newQuad(1027, 573, 50, 50, 1226, 624 )
Quads["flame08"] = love.graphics.newQuad(1079, 1, 50, 50, 1226, 624 )
Quads["flame09"] = love.graphics.newQuad(1079, 53, 50, 50, 1226, 624 )
Quads["man_pushing001"] = love.graphics.newQuad(1079, 105, 50, 50, 1226, 624 )
Quads["man_pushing002"] = love.graphics.newQuad(1079, 157, 50, 50, 1226, 624 )
Quads["man_pushing003"] = love.graphics.newQuad(1079, 209, 50, 50, 1226, 624 )
Quads["man_pushing004"] = love.graphics.newQuad(1079, 261, 50, 50, 1226, 624 )
Quads["man_pushing005"] = love.graphics.newQuad(1079, 157, 50, 50, 1226, 624 )
Quads["man_pushing006"] = love.graphics.newQuad(1079, 105, 50, 50, 1226, 624 )
Quads["man_pushing007"] = love.graphics.newQuad(1079, 313, 50, 50, 1226, 624 )
Quads["man_pushing008"] = love.graphics.newQuad(1079, 365, 50, 50, 1226, 624 )
Quads["man_pushing009"] = love.graphics.newQuad(1079, 417, 50, 50, 1226, 624 )
Quads["man_pushing010"] = love.graphics.newQuad(1079, 313, 50, 50, 1226, 624 )
Quads["man_walking1"] = love.graphics.newQuad(1079, 469, 50, 50, 1226, 624 )
Quads["man_walking2"] = love.graphics.newQuad(1079, 573, 50, 50, 1226, 624 )
Quads["man_walking3"] = love.graphics.newQuad(1131, 1, 50, 50, 1226, 624 )
Quads["man_walking4"] = love.graphics.newQuad(1131, 53, 50, 50, 1226, 624 )
Quads["man_walking5"] = love.graphics.newQuad(1131, 105, 50, 50, 1226, 624 )
Quads["man_walking6"] = love.graphics.newQuad(1131, 157, 50, 50, 1226, 624 )
Quads["man_walking7"] = love.graphics.newQuad(1131, 209, 50, 50, 1226, 624 )
Quads["man_walking8"] = love.graphics.newQuad(1131, 261, 50, 50, 1226, 624 )
Quads["man_walking9"] = love.graphics.newQuad(1131, 313, 50, 50, 1226, 624 )
Quads["man_walking10"] = love.graphics.newQuad(1079, 521, 50, 50, 1226, 624 )
Quads["winning_dance_1_1"] = love.graphics.newQuad(1131, 365, 50, 50, 1226, 624 )
Quads["winning_dance_1_2"] = love.graphics.newQuad(1131, 521, 50, 50, 1226, 624 )
Quads["winning_dance_1_3"] = love.graphics.newQuad(1131, 365, 50, 50, 1226, 624 )
Quads["winning_dance_1_4"] = love.graphics.newQuad(1131, 521, 50, 50, 1226, 624 )
Quads["winning_dance_1_5"] = love.graphics.newQuad(1131, 365, 50, 50, 1226, 624 )
Quads["winning_dance_1_6"] = love.graphics.newQuad(1131, 521, 50, 50, 1226, 624 )
Quads["winning_dance_1_7"] = love.graphics.newQuad(1131, 469, 50, 50, 1226, 624 )
Quads["winning_dance_1_8"] = love.graphics.newQuad(1131, 417, 50, 50, 1226, 624 )
Quads["winning_dance_1_9"] = love.graphics.newQuad(1131, 469, 50, 50, 1226, 624 )
Quads["winning_dance_1_10"] = love.graphics.newQuad(1131, 417, 50, 50, 1226, 624 )
Quads["winning_dance_1_11"] = love.graphics.newQuad(1131, 469, 50, 50, 1226, 624 )
Quads["winning_dance_1_12"] = love.graphics.newQuad(1131, 417, 50, 50, 1226, 624 )

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
