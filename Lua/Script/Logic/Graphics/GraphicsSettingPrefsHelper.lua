local GraphicsSettingPrefsHelper = {}
GraphicsSettingPrefsHelper.isAddPidToKey = false
GraphicsSettingPrefsHelper.KeyIsFirstSet = "Setting_Graphics_IsFirstSet"
GraphicsSettingPrefsHelper.KeyVisualFPS = "Setting_Graphics_VisualFPS"
GraphicsSettingPrefsHelper.KeyShadowQuality = "Setting_Graphics_ShadowQuality"
GraphicsSettingPrefsHelper.KeyBloom = "Setting_Graphics_Bloom"
GraphicsSettingPrefsHelper.KeyMSAA = "Setting_Graphics_MSAA"
GraphicsSettingPrefsHelper.KeyResolutionDisplay = "Setting_Graphics_ResolutionDisplay"
GraphicsSettingPrefsHelper.KeyLodBias = "Setting_Graphics_LodBias"
GraphicsSettingPrefsHelper.KeyShadowDistance = "Setting_Graphics_ShadowDistance"
GraphicsSettingPrefsHelper.KeyVSync = "Setting_Graphics_VSync"

function GraphicsSettingPrefsHelper.HasFirstSet()
  if GraphicsSettingPrefsHelper.HasKey(GraphicsSettingPrefsHelper.KeyIsFirstSet) then
    return true
  end
  return false
end

function GraphicsSettingPrefsHelper.FirstSet()
  GraphicsSettingPrefsHelper.SetInt(GraphicsSettingPrefsHelper.KeyIsFirstSet, 1)
end

function GraphicsSettingPrefsHelper.SetVisualFPS(value)
  GraphicsSettingPrefsHelper.SetInt(GraphicsSettingPrefsHelper.KeyVisualFPS, value)
end

function GraphicsSettingPrefsHelper.GetVisualFPS()
  return GraphicsSettingPrefsHelper.GetInt(GraphicsSettingPrefsHelper.KeyVisualFPS)
end

function GraphicsSettingPrefsHelper.SetShadowQuality(value)
  GraphicsSettingPrefsHelper.SetInt(GraphicsSettingPrefsHelper.KeyShadowQuality, value)
end

function GraphicsSettingPrefsHelper.GetShadowQuality()
  return GraphicsSettingPrefsHelper.GetInt(GraphicsSettingPrefsHelper.KeyShadowQuality)
end

function GraphicsSettingPrefsHelper.SetBloom(value)
  GraphicsSettingPrefsHelper.SetInt(GraphicsSettingPrefsHelper.KeyBloom, value)
end

function GraphicsSettingPrefsHelper.GetBloom()
  return GraphicsSettingPrefsHelper.GetInt(GraphicsSettingPrefsHelper.KeyBloom)
end

function GraphicsSettingPrefsHelper.SetMSAA(value)
  GraphicsSettingPrefsHelper.SetInt(GraphicsSettingPrefsHelper.KeyMSAA, value)
end

function GraphicsSettingPrefsHelper.GetMSAA()
  return GraphicsSettingPrefsHelper.GetInt(GraphicsSettingPrefsHelper.KeyMSAA)
end

function GraphicsSettingPrefsHelper.SetResolutionDisplay(value)
  GraphicsSettingPrefsHelper.SetString(GraphicsSettingPrefsHelper.KeyResolutionDisplay, value)
end

function GraphicsSettingPrefsHelper.GetResolutionDisplay()
  return GraphicsSettingPrefsHelper.GetString(GraphicsSettingPrefsHelper.KeyResolutionDisplay)
end

function GraphicsSettingPrefsHelper.SetLodBias(value)
  GraphicsSettingPrefsHelper.SetInt(GraphicsSettingPrefsHelper.KeyLodBias, value)
end

function GraphicsSettingPrefsHelper.GetLodBias()
  return GraphicsSettingPrefsHelper.GetInt(GraphicsSettingPrefsHelper.KeyLodBias)
end

function GraphicsSettingPrefsHelper.HasKeyLodBias()
  return GraphicsSettingPrefsHelper.HasKey(GraphicsSettingPrefsHelper.KeyLodBias)
end

function GraphicsSettingPrefsHelper.SetShadowDistance(value)
  GraphicsSettingPrefsHelper.SetInt(GraphicsSettingPrefsHelper.KeyShadowDistance, value)
end

function GraphicsSettingPrefsHelper.GetShadowDistance()
  return GraphicsSettingPrefsHelper.GetInt(GraphicsSettingPrefsHelper.KeyShadowDistance)
end

function GraphicsSettingPrefsHelper.HasKeyShadowDistance()
  return GraphicsSettingPrefsHelper.HasKey(GraphicsSettingPrefsHelper.KeyShadowDistance)
end

function GraphicsSettingPrefsHelper.SetVSync(value)
  GraphicsSettingPrefsHelper.SetInt(GraphicsSettingPrefsHelper.KeyVSync, value)
end

function GraphicsSettingPrefsHelper.GetVSync()
  return GraphicsSettingPrefsHelper.GetInt(GraphicsSettingPrefsHelper.KeyVSync)
end

function GraphicsSettingPrefsHelper.HasKeyVSync()
  return GraphicsSettingPrefsHelper.HasKey(GraphicsSettingPrefsHelper.KeyVSync)
end

function GraphicsSettingPrefsHelper.GetString(key)
  local aKey = GraphicsSettingPrefsHelper.GetPidKey(key)
  if GraphicsSettingPrefsHelper.HasKey(key) then
    local value = PlayerPrefs.GetString(aKey)
    return value
  end
  return ""
end

function GraphicsSettingPrefsHelper.SetString(key, value)
  local aKey = GraphicsSettingPrefsHelper.GetPidKey(key)
  PlayerPrefs.SetString(GraphicsSettingPrefsHelper.GetPidKey(key), value)
end

function GraphicsSettingPrefsHelper.GetInt(key)
  local aKey = GraphicsSettingPrefsHelper.GetPidKey(key)
  if GraphicsSettingPrefsHelper.HasKey(key) then
    local value = PlayerPrefs.GetInt(aKey)
    return value
  end
  return 0
end

function GraphicsSettingPrefsHelper.SetInt(key, value)
  local aKey = GraphicsSettingPrefsHelper.GetPidKey(key)
  return PlayerPrefs.SetInt(GraphicsSettingPrefsHelper.GetPidKey(key), value)
end

function GraphicsSettingPrefsHelper.HasKey(key)
  local aKey = GraphicsSettingPrefsHelper.GetPidKey(key)
  local has = PlayerPrefs.HasKey(GraphicsSettingPrefsHelper.GetPidKey(key))
  return has
end

function GraphicsSettingPrefsHelper.GetPidKey(key)
  if GraphicsSettingPrefsHelper.isAddPidToKey then
    return key .. "_" .. PlayerData:GetPid()
  else
    return key
  end
end

return GraphicsSettingPrefsHelper
