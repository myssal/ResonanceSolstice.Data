local ChannelPayMgr = {}

function ChannelPayMgr:Init()
  if SdkChannelHelper.IsCurHarmony() then
    HarmonyChannelPayMgr:Init()
  end
end

function ChannelPayMgr:IsUseChannelPay()
  if SdkChannelHelper.IsCurHarmony() then
    return true
  end
  return false
end

function ChannelPayMgr:IsUseCommonOrderReq()
  if SdkChannelHelper.IsCurHarmony() then
    return true
  end
  return false
end

function ChannelPayMgr:Buy(productId, cb, uiParams)
  local channelFlag = self:GetCommonPayChannelFlag()
  local strProductid = CommonPayHelper.MakeProductToString(productId)
  local args = Json.decode(uiParams)
  local payAmount = args.payAmount
  local productName = args.name
  
  local function onRecvOrder(json)
    self:OnRecvCommonOrder(json, productId, cb, uiParams)
  end
  
  if self:IsUseCommonOrderReq() then
    Net:SendProto("pay.common_order_str", onRecvOrder, channelFlag, strProductid, productName)
  end
end

function ChannelPayMgr:OnRecvCommonOrder(json, productId, cb, uiParams)
  local isFirst = json.is_first or 0
  local out_trade_no = json.out_trade_no
  local notify_url = json.notify_url or ""
  local isAudit = json.isAudit or 0
  local args = Json.decode(uiParams)
  local payAmount = args.payAmount
  local currencyType = PayHelper.GetCurrencyTypeStr()
  local channelFlag = self:GetCommonPayChannelFlag()
  local strProductid = CommonPayHelper.MakeProductToString(productId)
  local productName = args.name
  local productDesc = args.name
  local amount = payAmount
  local uid = PlayerData:GetUserInfo().uid
  SdkReporter.TrackOrder(out_trade_no, payAmount, currencyType, channelFlag)
  local args = {
    product_id = strProductid,
    product_name = productName,
    product_desc = productDesc,
    quantifier = "\228\184\170",
    out_trade_no = out_trade_no,
    notify_url = notify_url,
    amount = tostring(amount),
    count = "1",
    extras_params = CommonPayHelper.GetExtra(notify_url),
    server_id = CommonPayHelper.GetServerId(),
    role_id = uid,
    audit = CommonPayHelper.GetAudit(isAudit),
    sandbox = CommonPayHelper.GetSandbox()
  }
  self:BeforeCall(args)
  local jsonStr = Json.encode(args)
  
  local function onRecvSdkCb(json)
    local jsonData = Json.decode(json)
    if jsonData.Status ~= 0 then
      SdkHelper.CloseWaiting()
      Debug.Log("[SDK Pay] CommonPayHelper.Buy failed")
      SdkReporter.TrackBuyFail(out_trade_no, payAmount, channelFlag, strProductid, productName, isFirst)
      self:OnSdkPurchaseFailed(jsonData)
      return
    end
    self:OnSdkPurchaseSuccess(jsonData)
    
    local function onRecvQuery(json)
      SdkHelper.CloseWaiting()
      local sdkPrice = json.platform_amount or 0
      SdkReporter.TrackBuySuccess(out_trade_no, payAmount, channelFlag, strProductid, productName, isFirst, sdkPrice)
      pcall(cb, json)
    end
    
    PayHelper.ReqQueryOID(out_trade_no, onRecvQuery, args)
  end
  
  PayHelper.CallChannelPay(onRecvSdkCb, jsonStr)
end

function ChannelPayMgr:BeforeCall(jsonData)
  if SdkChannelHelper.IsCurHarmony() then
    HarmonyChannelPayMgr:BeforeCall(jsonData)
  end
end

function ChannelPayMgr:OnSdkPurchaseFailed(jsonData)
  if SdkChannelHelper.IsCurHarmony() then
    HarmonyChannelPayMgr:OnSdkPurchaseFailed(jsonData)
  end
end

function ChannelPayMgr:OnSdkPurchaseSuccess(data)
  if SdkChannelHelper.IsCurHarmony() then
    HarmonyChannelPayMgr:OnSdkPurchaseSuccess(data)
  end
end

function ChannelPayMgr:GetCommonPayChannelFlag()
  if SdkChannelHelper.IsCurHarmony() then
    return "hmos"
  end
  return ""
end

function ChannelPayMgr:MakeProductToString(productId)
  if type(productId) ~= "string" then
    return tostring(productId)
  end
  return productId
end

return ChannelPayMgr
