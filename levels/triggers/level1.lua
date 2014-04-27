local triggers = {}
local common_triggers = require("levels/triggers/common")
for k,v in pairs(common_triggers) do
  triggers[k] = v
end

return triggers
