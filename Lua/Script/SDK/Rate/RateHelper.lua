local RateHelper = {}
UJoyRateHelper = require("SDK/Rate/UJoyRateHelper")
RateHelper.CondPlayerLevel = 14

function RateHelper.Init()
  EventMgr:AddEvent("event_uimainui_enable", function()
    RateHelper.RequestAppleStoreWhenEnterMainMenu()
    UJoyRateHelper.TryRateByLevel()
  end)
end

function RateHelper.TryOpenRatePop()
  RateHelper.TryOpenRateWhenGetSSR()
end

function RateHelper.TryOpenRateWhenGetSSR(drawNum)
  if drawNum ~= nil and drawNum ~= GachaGV:GetLastDrawNum() then
    return
  end
  if GachaGV:LastTenPullPollIsNewbie() then
    return
  end
  if not GachaHelper.HasSSRInLastDraw() then
    return
  end
  RateHelper.RequestHaoplayReview()
end

function RateHelper.TryOpenRateWhenTenPullsViewOpen()
  UJoyRateHelper.TryRateBySSR()
end

function RateHelper.RequestHaoplayReview()
  if PlatformHelper.IsPC() then
    return
  end
  if not SdkHelper.IsChannelHaoPlay() then
    return
  end
  local isPlayed = PlayerData:GetPlayerPrefs("int", "HaoPlay_AppReview_State", true) == 1
  if isPlayed then
    return
  end
  PlayerData:SetPlayerPrefs("int", "HaoPlay_AppReview_State", 1)
  local uid = PlayerData:GetUserInfo().uid
  local extra = {
    roleid = PlayerData:GetUserInfo().uid,
    level = PlayerData:GetPlayerLevel()
  }
  CS.GameSdkLuaface.HaoPlayAppReview(uid, extra)
end

function RateHelper.OpenRateWhenNewbiePoolFinish()
  local newbiewPoolId = GachaHelper.GetNewbiePoolId()
  local lastPullPoolId = GachaGV:GetLastTenPullPollId()
  if lastPullPoolId ~= newbiewPoolId then
    return
  end
  if GachaHelper.GetNewbiePoolLeftNum() > 0 then
    return
  end
  if DeviceHelper.IsDeviceIOS() then
    RateHelper.RequestAppleStoreReview()
  end
end

function RateHelper.RequestAppleStoreReview()
end

function RateHelper.OpenAppleStoreReview()
  local isIOS = PlatformHelper.IsIPhone()
  if not isIOS then
    return
  end
  local status = PlayerData:GetPlayerPrefs("int", "AppleStoreReviewPopStatus")
  if status == nil or status == 1 then
    return
  end
  local s = CommonHelper.SafeCallCsFunc(CS.RateLuaface.RequestAppleStoreReview)
  if s then
    PlayerData:SetPlayerPrefs("int", "AppleStoreReviewPopStatus", 1)
  end
end

function RateHelper.OpenGoogleStoreReview()
  local r, s = CommonHelper.SafeCallCsFunc(CS.MSDKExternSetting.IsUseGooglePlayPlugins)
  if r == nil or r == false or s == nil or s == false then
    return
  end
  local status = PlayerData:GetPlayerPrefs("int", "GoogleStoreReviewPopStatus")
  if status == nil or status == 1 then
    return
  end
  local s = CommonHelper.SafeCallCsFunc(CS.RateLuaface.RequestGoogleStoreReview)
  if s then
    PlayerData:SetPlayerPrefs("int", "GoogleStoreReviewPopStatus", 1)
  end
end

function RateHelper.RequestAppleStoreWhenEnterMainMenu()
  if SdkHelper.IsChannelHaoPlay() then
    return
  end
  if SdkHelper.IsChannelUjoy() then
    return
  end
  local playerLevel = PlayerData:GetPlayerLevel()
  if playerLevel >= RateHelper.CondPlayerLevel then
    RateHelper.OpenAppleStoreReview()
    RateHelper.OpenGoogleStoreReview()
  end
end

function RateHelper.CheckReviewByPlayerLevel()
  local playerLevel = PlayerData:GetPlayerLevel()
  if playerLevel < RateHelper.CondPlayerLevel then
    return
  end
  ChannelUJoyHelper.ShowStoreReview()
end

RateHelper.Init()
return RateHelper
