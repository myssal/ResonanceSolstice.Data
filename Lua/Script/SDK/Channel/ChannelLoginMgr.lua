ChannelPayMgr = require("SDK/Channel/ChannelPayMgr")
local ChannelLoginMgr = {}

function ChannelLoginMgr:TryHandlerResult(data)
  if data == nil then
    return false
  end
  if SdkChannelHelper.IsCurHarmony() then
    return HarmonyChannelLoginMgr:TryHandlerResult(data)
  end
  return false
end

function ChannelLoginMgr:IsUseChannelLogin()
  if SdkChannelHelper.IsCurHarmony() then
    return HarmonyChannelLoginMgr:IsUseChannelLogin()
  end
  return nil
end

function ChannelLoginMgr:BeforeLogoutInLogin()
  if SdkChannelHelper.IsCurHarmony() then
    HarmonyChannelLoginMgr:BeforeLogoutInLogin()
  end
end

function ChannelLoginMgr:BeforeLoginInit()
  if SdkChannelHelper.IsCurHarmony() then
    HarmonyChannelLoginMgr:BeforeLoginInit()
  end
end

function ChannelLoginMgr:BeforeSendIndex(send, context)
  if SdkChannelHelper.IsCurHarmony() then
    HarmonyChannelLoginMgr:BeforeSendIndex(send, context)
  end
end

function ChannelLoginMgr:AfterRecvIndex(msg, context)
  if SdkChannelHelper.IsCurHarmony() then
    HarmonyChannelLoginMgr:AfterRecvIndex(msg, context)
  end
end

function ChannelLoginMgr:AfterLogoutInLoginScene()
  if SdkChannelHelper.IsCurHarmony() then
    HarmonyChannelLoginMgr:AfterLogoutInLoginScene()
  end
end

function ChannelLoginMgr:AfterLogoutInGameScene()
end

function ChannelLoginMgr:TryLogoutInLoginScene()
  if SdkChannelHelper.IsCurHarmony() then
    HarmonyChannelLoginMgr:TryLogoutInLoginScene()
  end
end

function ChannelLoginMgr:TryLogoutInGameScene()
  if SdkChannelHelper.IsCurHarmony() then
    HarmonyChannelLoginMgr:TryLogoutInGameScene()
  end
end

function ChannelLoginMgr:OnRecvMainIndex()
  if SdkChannelHelper.IsCurHarmony() then
    HarmonyChannelLoginMgr:OnRecvMainIndex()
  end
end

return ChannelLoginMgr
