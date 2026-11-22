ChannelUJoyHelper = require("SDK/Channel/ChannelUJoyHelper")
SdkAdMarkHelper = require("SDK/Channel/SdkAdMarkHelper")
ChannelLoginMgr = require("SDK/Channel/ChannelLoginMgr")
HarmonyCHannelMgr = require("SDK/Channel/Harmony/HarmonyCHannelMgr")
local SdkChannelHelper = {}

function SdkChannelHelper.IsCurCnOfficial()
  local flag = SdkHelper.GetChannelFlag()
  return flag == SdkChannelConst.ChannelFlag.Official
end

function SdkChannelHelper.IsCurHarmony()
  return SdkHelper.GetChannelFlag() == SdkChannelConst.ChannelFlag.Harmony
end

function SdkChannelHelper.IsCurCnBiliPc()
  local flag = SdkHelper.GetChannelFlag()
  return flag == SdkChannelConst.ChannelFlag.BiliPc
end

function SdkChannelHelper.IsCurSteam()
  local flag = SdkHelper.GetChannelFlag()
  return flag == SdkChannelConst.ChannelFlag.Steam
end

function SdkChannelHelper.IsCurJapanOfficial()
  local flag = SdkHelper.GetChannelFlag()
  return flag == SdkChannelConst.ChannelFlag.JapanOffical
end

function SdkChannelHelper.IsCurJPOfficialWeb()
  local flag = SdkHelper.GetChannelFlag()
  return flag == SdkChannelConst.ChannelFlag.JPOfficialWeb
end

function SdkChannelHelper.IsCurTwOfficial()
  local flag = SdkHelper.GetChannelFlag()
  return flag == SdkChannelConst.ChannelFlag.TwOffical
end

function SdkChannelHelper.IsCurTwOfficialWeb()
  local flag = SdkHelper.GetChannelFlag()
  return flag == SdkChannelConst.ChannelFlag.TwOfficialWeb
end

function SdkChannelHelper.IsCurHaoplay()
  local flag = SdkHelper.GetChannelFlag()
  return flag == SdkChannelConst.ChannelFlag.HaoPlay
end

function SdkChannelHelper.IsCurUjoy()
  local flag = SdkHelper.GetChannelFlag()
  return flag == SdkChannelConst.ChannelFlag.Ujoy
end

function SdkChannelHelper.IsCurNotUjoy()
  local flag = SdkHelper.GetChannelFlag()
  return flag ~= SdkChannelConst.ChannelFlag.Ujoy
end

function SdkChannelHelper.GetSecondaryChannelFlag()
  local s, r = CommonHelper.SafeCallCsFunc(CS.GameSdkLuaface.GetSecondaryChannelFlag)
  if s then
    return r or ""
  end
  return ""
end

return SdkChannelHelper
