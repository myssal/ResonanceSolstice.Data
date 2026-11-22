local PlatformHelper = {}

function PlatformHelper.CanUseThisFunc()
  local s, r = CommonHelper.SafeCallCsFunc(CS.PlatformLuaface.IsEditor)
  if s == nil or r == nil then
    return false
  end
  return true
end

function PlatformHelper.IsEditor()
  local s, r = CommonHelper.SafeCallCsFunc(CS.PlatformLuaface.IsEditor)
  if s == nil or r == nil then
    return false
  end
  return r == true
end

function PlatformHelper.IsAndroid()
  local s, r = CommonHelper.SafeCallCsFunc(CS.PlatformLuaface.IsAndroid)
  if s == nil or r == nil then
    return false
  end
  return r == true
end

function PlatformHelper.IsIPhone()
  local s, r = CommonHelper.SafeCallCsFunc(CS.PlatformLuaface.IsIPhone)
  if s == nil or r == nil then
    return false
  end
  return r == true
end

function PlatformHelper.IsPC()
  local s, r = CommonHelper.SafeCallCsFunc(CS.PlatformLuaface.IsPC)
  if s == nil or r == nil then
    return false
  end
  return r == true
end

return PlatformHelper
