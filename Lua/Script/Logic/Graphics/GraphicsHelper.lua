GraphicsSettingHelper = require("Logic/Graphics/GraphicsSettingHelper")
local GraphicsHelper = {}

function GraphicsHelper.SetDefaultScreenResolutionWithFullscreen()
  if not PlatformHelper.IsPC() then
    return
  end
  CommonHelper.SafeCallCsFunc(CS.PlatformLuaface.SetScreenResolution, 1920, 1080, true)
end

function GraphicsHelper.SetScreenResolution(width, height, fullscreen, savePrefs)
  if width == nil or height == nil then
    return
  end
  if not PlatformHelper.IsPC() then
    return
  end
  CommonHelper.SafeCallCsFunc(CS.PlatformLuaface.SetScreenResolution, width, height, fullscreen)
  if savePrefs then
    GraphicsSettingPrefsHelper.SetResolutionDisplay(string.format("%sx%s", width, height))
  end
end

function GraphicsHelper.SetResolutionWithCurrentScreenMode(width, height)
  if width == nil or height == nil then
    return
  end
  if not PlatformHelper.IsPC() then
    return
  end
  local isFull = GraphicsHelper.IsFullScreen()
  CommonHelper.SafeCallCsFunc(CS.PlatformLuaface.SetScreenResolution, width, height, isFull)
  GraphicsSettingPrefsHelper.SetResolutionDisplay(string.format("%sx%s", width, height))
end

function GraphicsHelper.IsFullScreen()
  return Screen.fullScreen
end

function GraphicsHelper.GetScreenWidth()
  return Screen.width
end

function GraphicsHelper.GetScreenHeight()
  return Screen.height
end

function GraphicsHelper.SetFullScreenMode()
  local curWidht = GraphicsHelper.GetScreenWidth()
  local curHeight = GraphicsHelper.GetScreenHeight()
  GraphicsHelper.SetScreenResolution(curWidht, curHeight, true)
end

function GraphicsHelper.SetWindowMode()
  local curWidht = GraphicsHelper.GetScreenWidth()
  local curHeight = GraphicsHelper.GetScreenHeight()
  GraphicsHelper.SetScreenResolution(curWidht, curHeight, false)
end

return GraphicsHelper
