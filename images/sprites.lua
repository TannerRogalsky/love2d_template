-- Generated with TexturePacker (http://www.codeandweb.com/texturepacker)
-- with a custom export by Stewart Bracken (http://stewart.bracken.bz)
--
-- $TexturePacker:SmartUpdate:b7be1aab3486032b77474c2fdcd179bd:437b0e4e1cfea8ed1215cdc371981382:ce59e0ef6b4af9fefc088af809f682f1$
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

Quads["bg"] = love.graphics.newQuad(1, 1, 1024, 600, 1076, 602 )
Quads["cloud1"] = love.graphics.newQuad(1027, 464, 42, 19, 1076, 602 )
Quads["cloud2"] = love.graphics.newQuad(1027, 558, 33, 22, 1076, 602 )
Quads["cloud3"] = love.graphics.newQuad(1027, 537, 36, 19, 1076, 602 )
Quads["flame00"] = love.graphics.newQuad(1027, 261, 44, 50, 1076, 602 )
Quads["flame01"] = love.graphics.newQuad(1027, 1, 48, 50, 1076, 602 )
Quads["flame02"] = love.graphics.newQuad(1027, 313, 44, 50, 1076, 602 )
Quads["flame03"] = love.graphics.newQuad(1027, 485, 41, 50, 1076, 602 )
Quads["flame04"] = love.graphics.newQuad(1027, 365, 44, 50, 1076, 602 )
Quads["flame05"] = love.graphics.newQuad(1027, 53, 48, 50, 1076, 602 )
Quads["flame06"] = love.graphics.newQuad(1027, 105, 48, 50, 1076, 602 )
Quads["flame07"] = love.graphics.newQuad(1027, 209, 45, 50, 1076, 602 )
Quads["flame08"] = love.graphics.newQuad(1027, 157, 48, 50, 1076, 602 )
Quads["flame09"] = love.graphics.newQuad(1027, 417, 44, 45, 1076, 602 )

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
