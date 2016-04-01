--- LovePixlr - Automagic scaling and letterboxing for LÖVE.
-- @module LovePixlr
-- @author Josef N Patoprsty <seppi@josefnpat.com>
-- @copyright 2014
-- @license <a href="http://www.opensource.org/licenses/zlib-license.php">zlib/libpng</a>

LovePixlr = {
  _VERSION = "LovePixlr v0.1.0",
  _DESCRIPTION = "Automagic scaling and letterboxing for LÖVE.",
  _URL = "http://github.com/josefnpat/LovePixlr",
  _LICENSE = [[
    The zlib/libpng License

    Copyright (c) 2014 Josef N Patoprsty

    This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
    Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
    3. This notice may not be removed or altered from any source distribution.
  ]]
}

-- Init some default structure
LovePixlr.msg = {
  too_small = "Window is too small..."
}
LovePixlr._old = {}
LovePixlr._old.mouse = {}
LovePixlr._new = {}
LovePixlr._new.mouse = {}

--- Initialize global LovePixlr stuff.
-- This function should be called unless you know what you're doing.
function LovePixlr.init()
  LovePixlr.setDefaultFilterMax("nearest")
  LovePixlr.font = love.graphics.getFont()
  return LovePixlr
end

--- Bind LovePixlr to love.
-- This function will modify the love object to create a new viewport.
-- This function is higly invasive
-- @param w <i>Required</i> This is the width of your new viewport.
-- @param h <i>Required</i> This is the height of your new viewport.
function LovePixlr.bind(w,h)
  LovePixlr._bound = true
  LovePixlr._w,LovePixlr._h = w,h

  -- init the mouse position as love does
  LovePixlr._lastmouse = {x=0,y=0}

  -- override love stuff
  LovePixlr._old.draw = love.draw
  love.draw = LovePixlr._new.draw

  LovePixlr._old.mouse.getPosition = love.mouse.getPosition
  love.mouse.getPosition = LovePixlr._new.mouse.getPosition
  love.mouse.getPositionReal = LovePixlr._new.mouse.getPositionReal

  LovePixlr._old.mouse.getX = love.mouse.getX
  love.mouse.getX = LovePixlr._new.mouse.getX

  LovePixlr._old.mouse.getY = love.mouse.getY
  love.mouse.getY = LovePixlr._new.mouse.getY

  return LovePixlr
end

--- Check to see if LovePixlr is bound.
-- @return boolean
function LovePixlr.isBound()
  return LovePixlr._bound
end

--- Get the scale of LovePixlr or a specific size
-- @param w <i>Optional</i> the width of the viewport. Defaults the the window width.
-- @param h <i>Optional</i> the height of the viewport. Defaults the the window height.
function LovePixlr.getScale(w,h)
  local sx = math.floor( (w or love.graphics.getWidth()) /LovePixlr._w)
  local sy = math.floor( (h or love.graphics.getHeight())/LovePixlr._h)
  return math.min(sx,sy)
end

--- Set the scale of LovePixlr
-- @param s <i>Required</i> the scale at which you want to set.
function LovePixlr.setScale(s)
  local current_scale = LovePixlr.getScale()
  if current_scale ~= s and -- not the currently set scale
    s > 0 and -- not a negative or zero scale
    s <= LovePixlr.getMaxScale() and -- not larger than the max scale
    math.floor(s) == s then -- Totally an integer
    local _,_,flags = love.window.getMode()
    love.window.setMode(s*LovePixlr._w,s*LovePixlr._h,flags)
  end
end

--- Get the maximum scale that LovePixlr will allow.
-- @return integer scale
function LovePixlr.getMaxScale()
  local _,_,flags = love.window.getMode()
  local w,h = love.window.getDesktopDimensions(flags.display)
  return LovePixlr.getScale(w,h)
end

--- Set the scale of LovePixlr to the maximum size.
function LovePixlr.setMaxScale()
  LovePixlr.setScale(LovePixlr.getMaxScale())
end

--- Set the font used by LovePixlr.
-- @param font <i>Required</i> The font that you want to use.
function LovePixlr.setFont(font)
  LovePixlr.font = font
end

--- Set the LovePixlr detail (upper left text in letterbox)
-- @param data <i>Required</i> if data is a function, LovePixlr will take the returned value of the function and use it instead of LovePixlr._defaultDetail(). If data is not a function, whatever it resolves to when cast to a boolean will determine if the text is shown.
function LovePixlr.setDetail(data)
  LovePixlr.detail = data
end

--- Set the LovePixlr detail (upper left text in letterbox)
-- @return mixed data
function LovePixlr.getDetail()
  return LovePixlr.detail
end

--- The default function for LovePixlr's detail that returns a string
-- @return string
function LovePixlr._defaultDetail()
  return love.timer.getFPS()
end

--- Get the offset for the letterboxing.
-- @return float,float
function LovePixlr._getOffset()
  local s = LovePixlr.getScale()
  local tx = (love.graphics.getWidth() -LovePixlr._w*s)/2
  local ty = (love.graphics.getHeight()-LovePixlr._h*s)/2
  return tx,ty
end

--- Set the max default filter and leave the other components alone.
-- @param fmax <i>Optional</i> Defaults to "nearest".
function LovePixlr.setDefaultFilterMax(fmax)
  local min,_,anisotropy = love.graphics.getDefaultFilter()
  love.graphics.setDefaultFilter(min,max or "nearest",anisotropy)
end

--- Override of love, love.draw()
-- The meat and potatoes of this whole library. This function automagically scales and letterboxes your content.
function LovePixlr._new.draw()
  if LovePixlr.detail then
    love.graphics.print(
      type(LovePixlr.detail) == "function" and
        LovePixlr.detail() or LovePixlr._defaultDetail(),
    2,2)
  end
  local s = LovePixlr.getScale()
  if s <= 0 then
    local old_font = love.graphics.getFont()
    love.graphics.setFont(LovePixlr.font)
    love.graphics.printf(LovePixlr.msg.too_small,
      0,(love.graphics.getHeight()-LovePixlr.font:getHeight())/2,
      love.graphics.getWidth(),"center")
    love.graphics.setFont(old_font)
  else
    local tx,ty = LovePixlr._getOffset()
    love.graphics.setScissor(tx,ty,LovePixlr._w*s,LovePixlr._h*s)
    love.graphics.push()
    love.graphics.translate(tx,ty)
    love.graphics.scale(s,s)
    LovePixlr._old.draw()
    love.graphics.pop()
    love.graphics.setScissor()
  end
end

--- Addition to love, love.mouse.getPositionReal
-- This function differs from love.mouse.getPosition as it returns the values
-- as full floats, allowing you to have more precise input.
-- adds third boolean return of "isOffscreen"
-- @return float x, float y, boolean isOffscreen
function LovePixlr._new.mouse.getPositionReal()
  local x,y = LovePixlr._old.mouse.getPosition()
  local tx,ty = LovePixlr._getOffset()
  local s = LovePixlr.getScale()

  -- the real mouse position
  local newx,newy = (x-tx)/s,(y-ty)/s

  -- clamp the mouse to the viewport.
  if newx > 0 and newx < LovePixlr._w and
    newy > 0 and newy < LovePixlr._h then
    LovePixlr._lastmouse = {x=newx,y=newy}
    return newx,newy,false
  else
    return LovePixlr._lastmouse.x,LovePixlr._lastmouse.y,true
  end

  return retx,rety
end

--- Override of love, love.mouse.getPosition()
-- This function returns the mouse values rounded, so that it stays in spec with
-- love's integer value return. use love.mouse.getPositionReal if you want
-- the full float value.
-- adds third boolean return of "isOffscreen"
-- @return integer x, integer y, boolean isOffscreen
function LovePixlr._new.mouse.getPosition()
  local x,y,isOffscreen  = LovePixlr._new.mouse.getPositionReal()
  return math.floor(x+0.5),math.floor(y+0.5),isOffscreen
end

--- Override of love, love.mouse.getX()
-- @return integer x
function LovePixlr._new.mouse.getX()
  local x,y = LovePixlr._new.mouse.getPosition()
  return x
end

--- Override of love, love.mouse.getY()
-- @return integer y
function LovePixlr._new.mouse.getY()
  local x,y = LovePixlr._new.mouse.getPosition()
  return y
end

return LovePixlr
