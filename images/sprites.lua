-- Generated with TexturePacker (http://www.codeandweb.com/texturepacker)
-- with a custom export by Stewart Bracken (http://stewart.bracken.bz)
--
-- $TexturePacker:SmartUpdate:da87262b87453a569f96e5f611626f8b:b5fdf75c4ee540596bf4ceb98dd15144:ce59e0ef6b4af9fefc088af809f682f1$
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

Quads["bg"] = love.graphics.newQuad(1, 1, 1024, 600, 1374, 624 )
Quads["cloud1"] = love.graphics.newQuad(1287, 521, 42, 42, 1374, 624 )
Quads["cloud2"] = love.graphics.newQuad(1331, 521, 42, 42, 1374, 624 )
Quads["cloud3"] = love.graphics.newQuad(1287, 565, 42, 42, 1374, 624 )
Quads["fan_blue_no_trolley_1"] = love.graphics.newQuad(1027, 1, 50, 50, 1374, 624 )
Quads["fan_blue_no_trolley_2"] = love.graphics.newQuad(1079, 1, 50, 50, 1374, 624 )
Quads["fan_blue_trolley_1"] = love.graphics.newQuad(1131, 1, 50, 50, 1374, 624 )
Quads["fan_blue_trolley_2"] = love.graphics.newQuad(1183, 1, 50, 50, 1374, 624 )
Quads["fire_blink1"] = love.graphics.newQuad(1235, 1, 50, 50, 1374, 624 )
Quads["fire_blink2"] = love.graphics.newQuad(1287, 1, 50, 50, 1374, 624 )
Quads["fire_blink3"] = love.graphics.newQuad(1027, 53, 50, 50, 1374, 624 )
Quads["fire_blink4"] = love.graphics.newQuad(1079, 53, 50, 50, 1374, 624 )
Quads["fire_blink5"] = love.graphics.newQuad(1131, 53, 50, 50, 1374, 624 )
Quads["fire_blink6"] = love.graphics.newQuad(1183, 53, 50, 50, 1374, 624 )
Quads["fire_blink7"] = love.graphics.newQuad(1235, 53, 50, 50, 1374, 624 )
Quads["fire_normal1"] = love.graphics.newQuad(1235, 1, 50, 50, 1374, 624 )
Quads["fire_normal2"] = love.graphics.newQuad(1287, 53, 50, 50, 1374, 624 )
Quads["fire_normal3"] = love.graphics.newQuad(1027, 53, 50, 50, 1374, 624 )
Quads["fire_normal4"] = love.graphics.newQuad(1027, 105, 50, 50, 1374, 624 )
Quads["fire_normal5"] = love.graphics.newQuad(1131, 53, 50, 50, 1374, 624 )
Quads["fire_normal6"] = love.graphics.newQuad(1183, 53, 50, 50, 1374, 624 )
Quads["fire_normal7"] = love.graphics.newQuad(1235, 53, 50, 50, 1374, 624 )
Quads["fire_not_happy1"] = love.graphics.newQuad(1079, 105, 50, 50, 1374, 624 )
Quads["fire_not_happy2"] = love.graphics.newQuad(1131, 105, 50, 50, 1374, 624 )
Quads["fire_not_happy3"] = love.graphics.newQuad(1183, 105, 50, 50, 1374, 624 )
Quads["fire_not_happy4"] = love.graphics.newQuad(1235, 105, 50, 50, 1374, 624 )
Quads["fire_not_happy5"] = love.graphics.newQuad(1287, 105, 50, 50, 1374, 624 )
Quads["fire_not_happy6"] = love.graphics.newQuad(1027, 157, 50, 50, 1374, 624 )
Quads["fire_not_happy7"] = love.graphics.newQuad(1079, 157, 50, 50, 1374, 624 )
Quads["fire_super_happy1"] = love.graphics.newQuad(1131, 157, 50, 50, 1374, 624 )
Quads["fire_super_happy2"] = love.graphics.newQuad(1287, 1, 50, 50, 1374, 624 )
Quads["fire_super_happy3"] = love.graphics.newQuad(1183, 157, 50, 50, 1374, 624 )
Quads["fire_super_happy4"] = love.graphics.newQuad(1079, 53, 50, 50, 1374, 624 )
Quads["fire_super_happy5"] = love.graphics.newQuad(1235, 157, 50, 50, 1374, 624 )
Quads["fire_super_happy6"] = love.graphics.newQuad(1287, 157, 50, 50, 1374, 624 )
Quads["fire_super_happy7"] = love.graphics.newQuad(1027, 209, 50, 50, 1374, 624 )
Quads["flame00"] = love.graphics.newQuad(1079, 209, 50, 50, 1374, 624 )
Quads["flame01"] = love.graphics.newQuad(1131, 209, 50, 50, 1374, 624 )
Quads["flame02"] = love.graphics.newQuad(1183, 209, 50, 50, 1374, 624 )
Quads["flame03"] = love.graphics.newQuad(1235, 209, 50, 50, 1374, 624 )
Quads["flame04"] = love.graphics.newQuad(1287, 209, 50, 50, 1374, 624 )
Quads["flame05"] = love.graphics.newQuad(1027, 261, 50, 50, 1374, 624 )
Quads["flame06"] = love.graphics.newQuad(1079, 261, 50, 50, 1374, 624 )
Quads["flame07"] = love.graphics.newQuad(1131, 261, 50, 50, 1374, 624 )
Quads["flame08"] = love.graphics.newQuad(1183, 261, 50, 50, 1374, 624 )
Quads["flame09"] = love.graphics.newQuad(1235, 261, 50, 50, 1374, 624 )
Quads["lava9"] = love.graphics.newQuad(1027, 521, 50, 50, 1374, 624 )
Quads["lava10"] = love.graphics.newQuad(1287, 261, 50, 50, 1374, 624 )
Quads["lava11"] = love.graphics.newQuad(1027, 313, 50, 50, 1374, 624 )
Quads["lava12"] = love.graphics.newQuad(1027, 365, 50, 50, 1374, 624 )
Quads["lava13"] = love.graphics.newQuad(1027, 417, 50, 50, 1374, 624 )
Quads["lava14"] = love.graphics.newQuad(1027, 469, 50, 50, 1374, 624 )
Quads["man_pushing001"] = love.graphics.newQuad(1027, 573, 50, 50, 1374, 624 )
Quads["man_pushing002"] = love.graphics.newQuad(1079, 313, 50, 50, 1374, 624 )
Quads["man_pushing003"] = love.graphics.newQuad(1131, 313, 50, 50, 1374, 624 )
Quads["man_pushing004"] = love.graphics.newQuad(1183, 313, 50, 50, 1374, 624 )
Quads["man_pushing005"] = love.graphics.newQuad(1079, 313, 50, 50, 1374, 624 )
Quads["man_pushing006"] = love.graphics.newQuad(1027, 573, 50, 50, 1374, 624 )
Quads["man_pushing007"] = love.graphics.newQuad(1235, 313, 50, 50, 1374, 624 )
Quads["man_pushing008"] = love.graphics.newQuad(1287, 313, 50, 50, 1374, 624 )
Quads["man_pushing009"] = love.graphics.newQuad(1079, 365, 50, 50, 1374, 624 )
Quads["man_pushing010"] = love.graphics.newQuad(1235, 313, 50, 50, 1374, 624 )
Quads["man_walking1"] = love.graphics.newQuad(1079, 417, 50, 50, 1374, 624 )
Quads["man_walking2"] = love.graphics.newQuad(1079, 521, 50, 50, 1374, 624 )
Quads["man_walking3"] = love.graphics.newQuad(1079, 573, 50, 50, 1374, 624 )
Quads["man_walking4"] = love.graphics.newQuad(1131, 365, 50, 50, 1374, 624 )
Quads["man_walking5"] = love.graphics.newQuad(1183, 365, 50, 50, 1374, 624 )
Quads["man_walking6"] = love.graphics.newQuad(1235, 365, 50, 50, 1374, 624 )
Quads["man_walking7"] = love.graphics.newQuad(1287, 365, 50, 50, 1374, 624 )
Quads["man_walking8"] = love.graphics.newQuad(1131, 417, 50, 50, 1374, 624 )
Quads["man_walking9"] = love.graphics.newQuad(1131, 469, 50, 50, 1374, 624 )
Quads["man_walking10"] = love.graphics.newQuad(1079, 469, 50, 50, 1374, 624 )
Quads["winning_dance_1_1"] = love.graphics.newQuad(1131, 521, 50, 50, 1374, 624 )
Quads["winning_dance_1_2"] = love.graphics.newQuad(1235, 417, 50, 50, 1374, 624 )
Quads["winning_dance_1_3"] = love.graphics.newQuad(1131, 521, 50, 50, 1374, 624 )
Quads["winning_dance_1_4"] = love.graphics.newQuad(1235, 417, 50, 50, 1374, 624 )
Quads["winning_dance_1_5"] = love.graphics.newQuad(1131, 521, 50, 50, 1374, 624 )
Quads["winning_dance_1_6"] = love.graphics.newQuad(1235, 417, 50, 50, 1374, 624 )
Quads["winning_dance_1_7"] = love.graphics.newQuad(1183, 417, 50, 50, 1374, 624 )
Quads["winning_dance_1_8"] = love.graphics.newQuad(1131, 573, 50, 50, 1374, 624 )
Quads["winning_dance_1_9"] = love.graphics.newQuad(1183, 417, 50, 50, 1374, 624 )
Quads["winning_dance_1_10"] = love.graphics.newQuad(1131, 573, 50, 50, 1374, 624 )
Quads["winning_dance_1_11"] = love.graphics.newQuad(1183, 417, 50, 50, 1374, 624 )
Quads["winning_dance_1_12"] = love.graphics.newQuad(1131, 573, 50, 50, 1374, 624 )
Quads["winning_dance_2_1"] = love.graphics.newQuad(1287, 417, 50, 50, 1374, 624 )
Quads["winning_dance_2_2"] = love.graphics.newQuad(1183, 469, 50, 50, 1374, 624 )
Quads["winning_dance_2_3"] = love.graphics.newQuad(1183, 521, 50, 50, 1374, 624 )
Quads["winning_dance_2_4"] = love.graphics.newQuad(1183, 573, 50, 50, 1374, 624 )
Quads["winning_dance_2_5"] = love.graphics.newQuad(1235, 469, 50, 50, 1374, 624 )
Quads["winning_dance_2_6"] = love.graphics.newQuad(1287, 469, 50, 50, 1374, 624 )
Quads["winning_dance_2_7"] = love.graphics.newQuad(1235, 521, 50, 50, 1374, 624 )
Quads["winning_dance_2_8"] = love.graphics.newQuad(1235, 573, 50, 50, 1374, 624 )

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
