local triggers = {}

love.audio.stop()

local bgm = love.audio.newSource("/sounds/music1.ogg", "stream")
bgm:play()
bgm:setVolume(0.4)

local common_triggers = require("levels/triggers/common")
for k,v in pairs(common_triggers) do
  triggers[k] = v
end

return triggers
