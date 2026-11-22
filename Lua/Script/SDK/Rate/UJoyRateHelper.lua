local UJoyRateHelper = {}
UJoyRateHelper.MaxOpenCount = 2

function UJoyRateHelper.TryRate()
  if UJoyRateHelper.CanUse() == false then
    return
  end
  local isOpenedNative = UJoyRateHelper.IsOpenedNative()
  if isOpenedNative then
    return
  end
  local openedCount = UJoyRateHelper.GetOpenedCount()
  if openedCount >= UJoyRateHelper.MaxOpenCount then
    return
  end
  UJoyRateHelper.OpenGameRate()
end

function UJoyRateHelper.TryRateBySSR()
  if UJoyRateHelper.CanUse() == false then
    return
  end
  if not GachaHelper.HasSSRInLastDraw() then
    return
  end
  UJoyRateHelper.TryRate()
end

function UJoyRateHelper.TryRateByLevel()
  if UJoyRateHelper.CanUse() == false then
    return
  end
  local playerLevel = PlayerData:GetPlayerLevel()
  local targetLevel = UJoyRateHelper.GetRateTargetLevel()
  if playerLevel < targetLevel then
    return
  end
  UJoyRateHelper.TryRate()
end

function UJoyRateHelper.GetRateTargetLevel()
  return 35
end

function UJoyRateHelper.CanUse()
  if SdkHelper.IsChannelUjoy() == false then
    return false
  end
  if PlatformHelper.IsPC() or ChannelUJoyHelper.GetChannel() == "OS" then
    return false
  end
  local isOpenedGame = UJoyRateHelper.IsOpenedGameRate()
  if isOpenedGame then
    return false
  end
  if GameSetting.SWUJoyAppReview ~= nil and GameSetting.SWUJoyAppReview ~= 0 then
    return GameSetting.SWUJoyAppReview == 1
  end
  return true
end

function UJoyRateHelper.OpenGameRate()
  TimerHelper.StartOnce("UJoyRateHelper_OpenGameRate", 1, function()
    UIManager:Open("UI/Common/OpenTips/KRLeadCommentTip/LeadCommentTip")
    UJoyRateHelper.AddOpenedCount()
  end)
end

function UJoyRateHelper.IsOpenedGameRate()
  return PlayerData:GetPlayerPrefs("int", "UJoy_AppReview", true) == 1
end

function UJoyRateHelper.SetIsOpenedGameRate()
  PlayerData:SetPlayerPrefs("int", "UJoy_AppReview", 1, true)
end

function UJoyRateHelper.GetOpenedCount()
  return PlayerData:GetPlayerPrefs("int", "UJoy_AppReview_Count", true) or 0
end

function UJoyRateHelper.AddOpenedCount()
  local cur = UJoyRateHelper.GetOpenedCount()
  PlayerData:SetPlayerPrefs("int", "UJoy_AppReview_Count", cur + 1, true)
end

function UJoyRateHelper.OpenNativeRate()
  ChannelUJoyHelper.ShowStoreReview()
end

function UJoyRateHelper.SetIsOpenedNative()
  PlayerData:SetPlayerPrefs("int", "UJoy_AppReview_OpenedNative", 1, true)
end

function UJoyRateHelper.IsOpenedNative()
  return PlayerData:GetPlayerPrefs("int", "UJoy_AppReview_OpenedNative", true) == 1
end

return UJoyRateHelper
