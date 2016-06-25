-- Generated with TexturePacker (http://www.codeandweb.com/texturepacker)
-- with a custom export by Stewart Bracken (http://stewart.bracken.bz)
--
-- $TexturePacker:SmartUpdate:fa9d11b9621bb20450f3102117914611:7964e01f46bd5b8e86759c5ec0490f73:ce59e0ef6b4af9fefc088af809f682f1$
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

Quads["bg"] = love.graphics.newQuad(1, 1, 1024, 600, 1026, 1006 )
Quads["cloud1"] = love.graphics.newQuad(734, 780, 42, 19, 1026, 1006 )
Quads["cloud2"] = love.graphics.newQuad(699, 780, 33, 22, 1026, 1006 )
Quads["cloud3"] = love.graphics.newQuad(778, 780, 36, 19, 1026, 1006 )
Quads["flame00"] = love.graphics.newQuad(357, 805, 163, 200, 1026, 1006 )
Quads["flame01"] = love.graphics.newQuad(1, 603, 176, 200, 1026, 1006 )
Quads["flame02"] = love.graphics.newQuad(522, 805, 163, 200, 1026, 1006 )
Quads["flame03"] = love.graphics.newQuad(687, 805, 149, 200, 1026, 1006 )
Quads["flame04"] = love.graphics.newQuad(534, 603, 163, 200, 1026, 1006 )
Quads["flame05"] = love.graphics.newQuad(1, 805, 176, 200, 1026, 1006 )
Quads["flame06"] = love.graphics.newQuad(179, 603, 176, 200, 1026, 1006 )
Quads["flame07"] = love.graphics.newQuad(357, 603, 175, 200, 1026, 1006 )
Quads["flame08"] = love.graphics.newQuad(179, 805, 176, 200, 1026, 1006 )
Quads["flame09"] = love.graphics.newQuad(699, 603, 163, 175, 1026, 1006 )

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
