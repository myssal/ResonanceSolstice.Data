local FirebaseReporter = {}

function FirebaseReporter.IsUse()
  local r, s = CommonHelper.SafeCallCsFunc(CS.MSDKExternSetting.IsUseFirebase)
  if r == nil or r == false or s == nil or s == false then
    return false
  end
  return true
end

function FirebaseReporter.TryTrackCustomEvent(eventName, propertiesTable, dict)
  if eventName == SdkConst.EvtName.level_up and propertiesTable ~= nil then
    FirebaseReporter.TrackLevelUp(propertiesTable[SdkConst.EvtProp.level], dict)
  end
end

function FirebaseReporter.TrackLevelUp(levelNow, dict)
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
  FirebaseReporter.TrackCustomOnlyKey(token)
end

function FirebaseReporter.TrackCustomOnlyKey(key)
  if FirebaseReporter.IsUse() == false then
    return
  end
  CommonHelper.SafeCallCsFunc(CS.Firebase.Analytics.FirebaseAnalytics.LogEvent, key)
end

function FirebaseReporter.TrackBeginCheckout(strCurrency, nValue)
  if FirebaseReporter.IsUse() == false then
    return
  end
  local key = "begin_checkout"
  FirebaseReporter.TrackCustomOnlyKey(key)
end

return FirebaseReporter
