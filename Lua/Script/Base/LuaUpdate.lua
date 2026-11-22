local LuaUpdate = {}
local uiGoBack = require("UIGoBack")

function LuaUpdate.Update(realtimeSinceStartup, deltaTime)
  TimerMgr:Update(realtimeSinceStartup, deltaTime)
  uiGoBack.GoBack()
end

TimerMgr = require("Common/Timer/TimerMgr")
return LuaUpdate
