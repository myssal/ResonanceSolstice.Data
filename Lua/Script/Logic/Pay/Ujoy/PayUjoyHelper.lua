local PayUjoyHelper = {}

function PayUjoyHelper.IsUseUjoyPay()
  if SdkChannelHelper.IsCurUjoy() then
    return true
  end
  return false
end

function PayUjoyHelper.Buy(productId, cb, uiParams)
  local args = Json.decode(uiParams)
  local payAmount = args.payAmount
  local productName = args.name
  local productDesc = args.name
  local currencyType = PayHelper.GetCurrencyTypeStr()
  local channelFlag = SdkHelper.GetChannelFlag()
  local uid = PlayerData:GetUserInfo().uid
  local isDelayCall = CommonPayHelper.IsUseDelayCall()
  local strProductid = CommonPayHelper.MakeProductToString(productId)
  local accessToken = LoginGV.GetAccessToken()
  local openId = LoginGV.GetViewId()
  local ujoyChannel = ChannelUJoyHelper.GetChannel()
  if PlatformHelper.IsPC() and not ChannelUJoyHelper.IsChannelSteam() then
    if ChannelUJoyHelper.IsChannelGPPC() then
      PayUjoyHelper.GPPCBuy(productId, cb, uiParams)
      return
    end
    
    local function onRecvOrder(json)
      local redirectUrl = json.redirectUrl
      local out_trade_no = json.out_trade_no
      
      local function funcPay()
        SdkHelper.CloseWaiting()
        CommonTips.OnPromptConfirmOnly("80608797", "80600068", function()
        end, false)
        SdkReporter.TrackOrder(out_trade_no, payAmount, currencyType, channelFlag)
        CS.UjoyGames.UjoyBaseApi.openWebView(redirectUrl)
      end
      
      if OfficialWebCoinPayHelper.CanOfficalWebCoinPay(productId) then
        OfficialWebCoinPayHelper.StartOfficialWebCoinPay(productId, out_trade_no, uiParams, cb, funcPay)
      else
        funcPay()
      end
    end
    
    Net:SendProto("pay.common_order_str", onRecvOrder, channelFlag, strProductid, productName, accessToken, openId, ujoyChannel)
    return
  end
  CommonPayHelper.Buy(productId, cb, uiParams)
end

function PayUjoyHelper.GPPCBuy(productId, cb, uiParams)
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
    Debug.Log("PayUjoyHelper.GPPCBuy onRecvOrder")
    CommonTips.OnPromptConfirmOnly("80608797", "80600068", function()
    end, false)
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

return PayUjoyHelper
