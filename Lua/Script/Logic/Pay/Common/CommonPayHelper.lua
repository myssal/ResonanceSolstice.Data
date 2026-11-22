local CommonPayHelper = {}

function CommonPayHelper.Buy(productId, cb, uiParams)
  local args = Json.decode(uiParams)
  local payAmount = args.payAmount
  local productName = args.name
  local productDesc = args.name
  local currencyType = PayHelper.GetCurrencyTypeStr()
  local channelFlag = SdkHelper.GetChannelFlag()
  local uid = PlayerData:GetUserInfo().uid
  local isDelayCall = CommonPayHelper.IsUseDelayCall()
  if isDelayCall == true then
    CommonHelper.SafeCallCsFunc(CS.PayLuaface.SetIsUsePayCallbackDelay, true)
  end
  local strProductid = CommonPayHelper.MakeProductToString(productId)
  
  local function onRecvOrder(json)
    local isFirst = json.is_first or 0
    local out_trade_no = json.out_trade_no
    local notify_url = json.notify_url or ""
    local isAudit = json.isAudit or 0
    local amount = payAmount
    if CommonPayHelper.CanSetTestAmount() then
      amount = json.amount
    else
    end
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
    local jsonStr = Json.encode(args)
    
    local function funcPay()
      local function onRecvSdkCb(json)
        SdkHelper.CloseWaiting()
        
        local jsonData = Json.decode(json)
        if jsonData.Status ~= 0 then
          Debug.Log("[SDK Pay] CommonPayHelper.Buy failed")
          SdkReporter.TrackBuyFail(out_trade_no, payAmount, channelFlag, strProductid, productName, isFirst)
          return
        end
        
        local function onRecvQuery(json)
          local sdkPrice = json.platform_amount or 0
          SdkReporter.TrackBuySuccess(out_trade_no, payAmount, channelFlag, strProductid, productName, isFirst, sdkPrice)
          pcall(cb, json)
        end
        
        PayHelper.ReqQueryOID(out_trade_no, onRecvQuery, args)
      end
      
      SdkHelper.OpenWaiting()
      PayHelper.CallChannelPay(onRecvSdkCb, jsonStr)
    end
    
    if OfficialWebCoinPayHelper.CanOfficalWebCoinPay(productId) then
      OfficialWebCoinPayHelper.StartOfficialWebCoinPay(productId, out_trade_no, uiParams, cb, funcPay)
    else
      funcPay()
    end
  end
  
  Net:SendProto("pay.common_order_str", onRecvOrder, channelFlag, strProductid, productName)
end

function CommonPayHelper.CanSetTestAmount()
  local secondaryChannel = SdkChannelHelper.GetSecondaryChannelFlag()
  if secondaryChannel ~= nil and secondaryChannel == "quick_24" then
    return false
  end
  return true
end

function CommonPayHelper.IsUseDelayCall()
  local secondaryChannel = SdkChannelHelper.GetSecondaryChannelFlag()
  if secondaryChannel ~= nil and secondaryChannel == "quick_24" then
    return true
  end
  return false
end

function CommonPayHelper.MakeProductToString(productId)
  if type(productId) ~= "string" then
    return tostring(productId)
  end
  return productId
end

function CommonPayHelper.GetExtra(notify_url)
  if SdkChannelHelper.IsCurUjoy() then
    local extra = {
      callback_url = notify_url,
      channel = CS.MSDKExternSetting.GetUJoyChannel()
    }
    return Json.encode(extra)
  end
  return "default"
end

function CommonPayHelper.GetServerId()
  if SdkChannelHelper.IsCurUjoy() then
    local serverId = CS.MSDKExternSetting.GetUJoyGameServerId()
    return tostring(serverId)
  end
  return "1"
end

function CommonPayHelper.GetAudit(audit)
  if SdkChannelHelper.IsCurUjoy() then
    return tostring(audit)
  end
  return "0"
end

function CommonPayHelper.GetSandbox()
  if SdkChannelHelper.IsCurUjoy() then
    local sandbox = CS.MSDKExternSetting.GetUJoySandbox()
    return tostring(sandbox)
  end
  return "0"
end

return CommonPayHelper
