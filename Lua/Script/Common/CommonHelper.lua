local CommonHelper = {}
EventMgr = require("Logic/Common/Event/EventMgr")
DeviceHelper = require("Common/Device/DeviceHelper")
UnityHelper = require("Common/UnityHelper/UnityHelper")

function CommonHelper.SafeCallCsFunc(csFunc, ...)
  if csFunc ~= nil and type(csFunc) == "function" then
    return pcall(csFunc, ...)
  end
  return nil, nil
end

function CommonHelper.HasCsFunc(csFunc)
  if csFunc ~= nil and type(csFunc) == "function" then
    return true
  end
  return false
end

return CommonHelper
