local SolarEngineDataReporter = {}

function SolarEngineDataReporter.GetReporter()
  local s, r = CommonHelper.SafeCallCsFunc(CS.MSDKExternSetting.IsUseSolarEngine)
  if s == nil or r == nil then
    return nil
  end
  if r == false then
    return nil
  end
  local report = CS.GameSdkMonoMgr.Instance:GetOneDataReporter("SolarEngine")
  return report
end

function SolarEngineDataReporter.TryTrackCustomEvent(eventName, propertiesTable, dict)
  if eventName == SdkConst.EvtName.level_up and propertiesTable ~= nil then
    SolarEngineDataReporter.TrackLevelUp(propertiesTable[SdkConst.EvtProp.level], dict)
  end
end

function SolarEngineDataReporter.TrackLevelUp(levelNow, dict)
  if levelNow == nil then
    return
  end
  if type(levelNow) ~= "number" then
    return
  end
  local token = ""
  if 32 <= levelNow then
    token = "level_32"
  elseif 29 <= levelNow then
    token = "level_29"
  elseif 25 <= levelNow then
    token = "level_25"
  elseif 20 <= levelNow then
    token = "level_20"
  elseif 15 <= levelNow then
    token = "level_15"
  elseif 11 <= levelNow then
    token = "level_11"
  elseif 10 <= levelNow then
    token = "level_10"
  elseif 8 <= levelNow then
    token = "level_8"
  elseif 6 <= levelNow then
    token = "level_6"
  elseif 4 <= levelNow then
    token = "level_4"
  end
  SolarEngineDataReporter.simpleTrack(token, dict)
end

function SolarEngineDataReporter.simpleTrack(eventName, dict)
  local reporter = SolarEngineDataReporter.GetReporter()
  if reporter == nil then
    return
  end
  if eventName == "" then
    return
  end
  CommonHelper.SafeCallCsFunc(CS.SolarEngine.Analytics.track, eventName, dict)
end

return SolarEngineDataReporter
