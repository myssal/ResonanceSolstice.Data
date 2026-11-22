local ChannelUJoyHelper = {}

function ChannelUJoyHelper.GetLoginType()
  return SdkHelper.GetLoginType() or -1
end

function ChannelUJoyHelper.IsLoginTypeVisitor()
  return ChannelUJoyHelper.GetLoginType() == 1
end

function ChannelUJoyHelper.GetChannel()
  if SdkChannelHelper.IsCurUjoy() then
    return CS.MSDKExternSetting.GetUJoyChannel()
  end
  return ""
end

function ChannelUJoyHelper.IsChannelPC()
  return ChannelUJoyHelper.GetChannel() == "PC"
end

function ChannelUJoyHelper.IsChannelGPPC()
  return ChannelUJoyHelper.GetChannel() == "GP_PC"
end

function ChannelUJoyHelper.IsChannelSteam()
  return ChannelUJoyHelper.GetChannel() == "STEAM"
end

function ChannelUJoyHelper.GetChannelLower()
  local channel = CS.MSDKExternSetting.GetUJoyChannel()
  if channel == "OS" then
    return "os"
  elseif channel == "GP" then
    return "gp"
  elseif channel == "AS" then
    return "as"
  elseif channel == "GP_PC" then
    return "gp_pc"
  else
    return "pc"
  end
end

function ChannelUJoyHelper.ShowFaqs()
  local t = {
    Store = ChannelUJoyHelper.GetChannelLower()
  }
  CS.UjoyGames.UjoyBaseApi.showFaqs(Json.encode(t))
end

function ChannelUJoyHelper.ShowCafe()
  if SdkRegionHelper.IsRegionUS() then
    local url = "https://discord.gg/aK3vGpka8p"
    ApplicationHelper.OpenUrl(url)
    return
  end
  if PlatformHelper.IsPC() then
    local url = "https://game.naver.com/lounge/RES/home"
    CS.UnityEngine.Application.OpenURL(url)
    return
  end
  CS.UjoyGames.UjoyBaseApi.showCafe()
end

function ChannelUJoyHelper.ShowConversation()
  if PlatformHelper.IsPC() then
    local url = "https://ujoy.helpshift.com/hc/en/18/contact-us/"
    if SdkRegionHelper.IsRegionUS() then
      url = "https://ujoy.helpshift.com/hc/en/24-resonance-solstice/"
    end
    CS.UnityEngine.Application.OpenURL(url)
    return
  end
  local t = {
    OpenID = LoginGV.GetViewId(),
    CharacterID = ChannelUJoyHelper.GetRoleUID(),
    Store = ChannelUJoyHelper.GetChannelLower(),
    DeviceRAM = DeviceHelper.GetDeviceMemorySizeTotal(),
    ChargeCrystal = ChannelUJoyHelper.GeRoleRockNum(),
    NickName = ChannelUJoyHelper.GetRoleName(),
    DeviceCPU = DeviceHelper.GetDeviceModel()
  }
  CS.UjoyGames.UjoyBaseApi.showConversation(Json.encode(t))
end

function ChannelUJoyHelper.ShowStoreReview()
  if SdkChannelHelper.IsCurUjoy() then
    CS.UjoyGames.UjoyBaseApi.storeReview()
  end
end

function ChannelUJoyHelper.GetRoleUID()
  local defaultUID = "0"
  if PlayerData.ServerData == nil then
    return defaultUID
  end
  if PlayerData.ServerData.user_info == nil then
    return defaultUID
  end
  return PlayerData.ServerData.user_info.uid or defaultUID
end

function ChannelUJoyHelper.GetRoleName()
  local defaultRoleName = "nil"
  if PlayerData.ServerData == nil then
    return defaultRoleName
  end
  if PlayerData.ServerData.user_info == nil then
    return defaultRoleName
  end
  return PlayerData.ServerData.user_info.role_name or defaultRoleName
end

function ChannelUJoyHelper.GeRoleRockNum()
  if PlayerData.ServerData == nil then
    return 0
  end
  if PlayerData.ServerData.user_info == nil then
    return 0
  end
  return PlayerData.ServerData.user_info.bm_rock or 0
end

return ChannelUJoyHelper
