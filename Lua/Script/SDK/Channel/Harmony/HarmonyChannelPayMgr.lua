local HarmonyChannelPayMgr = {}

function HarmonyChannelPayMgr:Init()
  CS.ChannelHarmonyMgr.Instance:InitIAP()
end

function HarmonyChannelPayMgr:Buy(productId, cb, uiParams)
  CS.ChannelHarmonyMgr.Instance:Purchase(productId)
end

function HarmonyChannelPayMgr:BeforeCall(jsonData)
  jsonData.extras_params = jsonData.out_trade_no
end

function HarmonyChannelPayMgr:onRecvSdkCb(jsonData)
end

function HarmonyChannelPayMgr:OnSdkPurchaseFailed(data)
  Debug.Log(string.format("[HMS]OnSdkPurchaseFailed data=%s", data.originSdkResult))
end

function HarmonyChannelPayMgr:OnSdkPurchaseSuccess(data)
  local sdkResult = data.originSdkResult
  Debug.Log(string.format("[HMS]OnSdkPurchaseSuccess data=%s", data.originSdkResult))
  CS.ChannelHarmonyMgr.Instance:ConsumePurchase(sdkResult)
end

return HarmonyChannelPayMgr
