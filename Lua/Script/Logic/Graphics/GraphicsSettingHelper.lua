GraphicsSettingData = require("Logic/Graphics/GraphicsSettingData")
GraphicsSettingPcData = require("Logic/Graphics/GraphicsSettingPcData")
GraphicsSettingPcHelper = require("Logic/Graphics/GraphicsSettingPcHelper")
GraphicsSettingPrefsHelper = require("Logic/Graphics/GraphicsSettingPrefsHelper")
local GraphicsSettingHelper = {}
GraphicsSettingHelper.IsSetted = false

function GraphicsSettingHelper.Init()
  EventMgr:AddEvent("event_uimainui_enable", function()
    GraphicsSettingHelper.EnterGameSet()
    TimerHelper.Start("GraphicsSettingHelper_Init", 3, function()
      GraphicsSettingHelper.SetVisualFPSAgain()
      TimerHelper.Stop("GraphicsSettingHelper_Init")
    end)
  end)
end

function GraphicsSettingHelper.EnterGameSet()
  if GraphicsSettingHelper.IsSetted then
    return
  end
  GraphicsSettingHelper.IsSetted = true
  if GraphicsSettingPrefsHelper.HasFirstSet() then
    if PlatformHelper.IsPC() then
      GraphicsSettingHelper.SetVisualFPSAgain()
      GraphicsSettingHelper.SetShadowQualityAgain()
      GraphicsSettingHelper.SetBloomAgain()
      GraphicsSettingHelper.SetMSAAAgain()
      GraphicsSettingHelper.SetDefaultViewFarValue()
    end
  else
    GraphicsSettingHelper.FirstEnterGameSet()
  end
  if PlatformHelper.IsPC() then
    GraphicsSettingHelper.SetLodBiasAgain()
    GraphicsSettingHelper.SetShadowDistanceAgain()
    GraphicsSettingHelper.SetVSyncAgain()
  end
end

function GraphicsSettingHelper.FirstEnterGameSet()
  if PlatformHelper.IsPC() then
    GraphicsSettingHelper.SetVisualFPS(1)
    GraphicsSettingHelper.SetShadowQuality(1)
    GraphicsSettingHelper.SetMSAA(GraphicsSettingPcData.PcDefaultAntiAnliasingQuality)
    GraphicsSettingHelper.SetViewFarValue(4)
    GraphicsSettingHelper.SetVisualBloom(1)
    GraphicsSettingPrefsHelper.FirstSet()
  end
end

function GraphicsSettingHelper.SetMSAAAgain()
  local quality = GraphicsSettingPrefsHelper.GetMSAA()
  GraphicsSettingHelper.SetMSAA(quality)
end

function GraphicsSettingHelper.SetMSAA(quality)
  if GraphicsSettingHelper.CanUseMSAA() == false then
    return
  end
  local count = GraphicsSettingData.GetAntiAliasCount(quality)
  PlayerPrefs.SetInt("currentMSAA", quality)
  GraphicsSettingPrefsHelper.SetMSAA(quality)
end

function GraphicsSettingHelper.CanUseMSAA()
  if GameSetting.platform == "StandaloneWindows64" or GameSetting.platform == "StandaloneWindows" or GameSetting.platform == "WIN_DB" then
    local qs = CS.UnityEngine.QualitySettings
    local antiAliasing = GameSetting.SetAntiAliasing
    if antiAliasing ~= nil then
      return true
    end
  end
  return false
end

function GraphicsSettingHelper.SetBloomAgain()
  local quality = GraphicsSettingPrefsHelper.GetBloom()
  GraphicsSettingHelper.SetVisualBloom(quality)
end

function GraphicsSettingHelper.SetVisualBloom(open)
  GameSetting:SetVisualbloom(open)
  GraphicsSettingPrefsHelper.SetBloom(open)
  GameSetting.currentVisualBloom = open
  GraphicsSettingHelper.SavePlayerConfig()
end

function GraphicsSettingHelper.SetShadowQualityAgain()
  local quality = GraphicsSettingPrefsHelper.GetShadowQuality()
  GraphicsSettingHelper.SetShadowQuality(quality)
end

function GraphicsSettingHelper.SetShadowQuality(open)
  GameSetting:SetShadowQuality(open)
  GraphicsSettingPrefsHelper.SetShadowQuality(open)
end

function GraphicsSettingHelper.SetVisualFPSAgain()
  local quality = GraphicsSettingPrefsHelper.GetVisualFPS()
  GraphicsSettingHelper.SetVisualFPS(quality)
end

function GraphicsSettingHelper.SetVisualFPS(fpsType, internalCall, isTrain)
  if internalCall == nil or isTrain == nil then
    GameSetting:SetVisualFPS(fpsType)
  else
    GameSetting:SetVisualFPS(fpsType, internalCall, isTrain)
  end
  GraphicsSettingPrefsHelper.SetVisualFPS(fpsType)
  if PlatformHelper.IsPC() then
    local fps = 60
    if fpsType == 1 then
      fps = 120
    end
    CS.UnityEngine.Application.targetFrameRate = fps
  end
end

function GraphicsSettingHelper.SetDefaultViewFarValue()
  local num = GameSetting.currentVisualFar
  GraphicsSettingHelper.SetViewFarValue(num)
end

function GraphicsSettingHelper.SetViewFarValue(num)
  GameSetting:SetFarValue(num)
  if PlatformHelper.IsPC() then
    local farValue = 1000
    if num == 4 then
      farValue = 4200
    elseif num == 3 then
      farValue = 3600
    elseif num == 2 then
      farValue = 2900
    elseif num == 1 then
      farValue = 2200
    elseif num == 0 then
      farValue = 1500
    end
    TrainManager:SetCameraFar(farValue)
  end
end

function GraphicsSettingHelper.SavePlayerConfig()
  GameSetting:SavePlayerConfig()
end

function GraphicsSettingHelper.SetLodBiasAgain()
  local tier = GraphicsSettingHelper.GetLoadBias()
  GraphicsSettingHelper.SetLodBias(tier)
end

function GraphicsSettingHelper.SetLodBias(tier)
  if not PlatformHelper.IsPC() then
    return
  end
  if not GraphicsSettingHelper.CanUseLodBias() then
    return
  end
  local value = GraphicsSettingData.GetLodBiasByIndex(tier)
  CommonHelper.SafeCallCsFunc(CS.IngameSettingLuaface.SetGraphicLodBias, value)
  GraphicsSettingPrefsHelper.SetLodBias(tier)
end

function GraphicsSettingHelper.GetLoadBias()
  if GraphicsSettingPrefsHelper.HasKeyLodBias() then
    return GraphicsSettingPrefsHelper.GetLodBias()
  end
  return GraphicsSettingData.DefaultLodBiasTier
end

function GraphicsSettingHelper.CanUseLodBias()
  return CommonHelper.HasCsFunc(CS.IngameSettingLuaface.SetGraphicLodBias)
end

function GraphicsSettingHelper.SetShadowDistanceAgain()
  local tier = GraphicsSettingHelper.GetShadowDistance()
  GraphicsSettingHelper.SetShadowDistance(tier)
end

function GraphicsSettingHelper.SetShadowDistance(tier)
  if not PlatformHelper.IsPC() then
    return
  end
  if not GraphicsSettingHelper.CanUseShadowDistance() then
    return
  end
  CommonHelper.SafeCallCsFunc(CS.IngameSettingLuaface.SetGraphicShadowProjection, 1)
  local shadowResolution = GraphicsSettingData.GetShadowResolutionByIndex(tier)
  CommonHelper.SafeCallCsFunc(CS.IngameSettingLuaface.SetGraphicShadowResolution, shadowResolution)
  local shadowDistance = GraphicsSettingData.GetShadowDistanceByIndex(tier)
  CommonHelper.SafeCallCsFunc(CS.IngameSettingLuaface.SetGraphicShadowDistance, shadowDistance)
  local shadowCascades = GraphicsSettingData.GetShadowCascadesByIndex(tier)
  CommonHelper.SafeCallCsFunc(CS.IngameSettingLuaface.SetGraphicShadowCascades, shadowCascades)
  GraphicsSettingPrefsHelper.SetShadowDistance(tier)
end

function GraphicsSettingHelper.GetShadowDistance()
  if GraphicsSettingPrefsHelper.HasKeyShadowDistance() then
    return GraphicsSettingPrefsHelper.GetShadowDistance()
  end
  return GraphicsSettingData.DefaultShadowDistanceTier
end

function GraphicsSettingHelper.CanUseShadowDistance()
  return CommonHelper.HasCsFunc(CS.IngameSettingLuaface.SetGraphicShadowDistance)
end

function GraphicsSettingHelper.CanUseVSync()
  return CommonHelper.HasCsFunc(CS.IngameSettingLuaface.SetGraphicVSync)
end

function GraphicsSettingHelper.GetVSync()
  if GraphicsSettingPrefsHelper.HasKeyVSync() then
    return GraphicsSettingPrefsHelper.GetVSync()
  end
  return GraphicsSettingData.DefaultVSync
end

function GraphicsSettingHelper.SetVSync(value)
  CommonHelper.SafeCallCsFunc(CS.IngameSettingLuaface.SetGraphicVSync, value)
  GraphicsSettingPrefsHelper.SetVSync(value)
end

function GraphicsSettingHelper.SetVSyncAgain()
  local cur = GraphicsSettingHelper.GetVSync()
  GraphicsSettingPrefsHelper.SetVSync(cur)
end

function GraphicsSettingHelper.IsVSyncOn()
  local value = GraphicsSettingHelper.GetVSync()
  return value == 1
end

function GraphicsSettingHelper.TurnVSync()
  local targetValue = 0
  local value = GraphicsSettingHelper.GetVSync()
  if value == 1 then
    targetValue = 0
  else
    targetValue = 1
  end
  GraphicsSettingHelper.SetVSync(targetValue)
end

GraphicsSettingHelper.Init()
return GraphicsSettingHelper
