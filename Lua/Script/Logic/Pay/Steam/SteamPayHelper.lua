local SteamPayHelper = {}

function SteamPayHelper.Buy(productId, cb, uiParams)
  local args = Json.decode(uiParams)
  local shpoId = args.shopId
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
        
        Net:SendProto("pay.steam_charge_refresh", onRecvQuery, out_trade_no)
      end
      
      SdkHelper.OpenWaiting()
      PayHelper.CallChannelPay(onRecvSdkCb, jsonStr)
    end
    
    funcPay()
  end
  
  local steamId = CS.SteamManager.Instance:GetSteamIDStr()
  local language = SteamPayHelper.GetLanguage()
  local currency = SteamPayHelper.GetCurrency()
  
  local function onRecvOrderCoin(json)
    local out_trade_no = json.out_trade_no
    
    local function funcPayCoin()
      Net:SendProto("pay.common_order_str", onRecvOrder, channelFlag, strProductid, productName, nil, nil, nil, steamId, language, currency)
    end
    
    OfficialWebCoinPayHelper.StartOfficialWebCoinPay(productId, out_trade_no, uiParams, cb, funcPayCoin)
  end
  
  if OfficialWebCoinPayHelper.CanOfficalWebCoinPay(productId) then
    Net:SendProto("pay.common_order_str", onRecvOrderCoin, "", strProductid, productName)
  else
    Net:SendProto("pay.common_order_str", onRecvOrder, channelFlag, strProductid, productName, nil, nil, nil, steamId, language, currency)
  end
end

function SteamPayHelper.GetLanguage()
  if SdkRegionHelper.IsRegionCN() then
    return "zh-CN"
  elseif SdkRegionHelper.IsRegionJP() then
    return "ja"
  else
    return ""
  end
end

function SteamPayHelper.GetCurrency()
  if SdkRegionHelper.IsRegionCN() then
    return "CNY"
  elseif SdkRegionHelper.IsRegionJP() then
    return "JPY"
  else
    return ""
  end
end

return SteamPayHelper
