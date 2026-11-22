local PayGoogleHelper = {}

function PayGoogleHelper.IsUseGooglePay()
  local defaultPay = PayHelper.GetDefaultPayType()
  if defaultPay == "google" then
    return true
  end
  return false
end

function PayGoogleHelper.Buy(productId, cb, uiParams)
  local args = Json.decode(uiParams)
  local productName = args.name
  local payAmount = args.payAmount
  local shpoId = args.shopId
  local currencyType = PayHelper.GetCurrencyTypeStr()
  local sProductId = productId
  if type(productId) ~= "string" then
    sProductId = tostring(productId)
  end
  local sPayType = "applepay"
  if PlatformHelper.IsAndroid() then
    sPayType = "googlepay"
  end
  SdkHelper.OpenWaiting()
  Net:SendProto("pay.create_oid", function(json1)
    local isFirst = json1.is_first or 0
    local out_trade_no = json1.out_trade_no
    SdkReporter.TrackOrder(out_trade_no, payAmount, currencyType, sPayType)
    FirebaseReporter.TrackBeginCheckout(currencyType, payAmount)
    OfficialWebCoinPayHelper.TryOpenRechargeGuideUrl(json1.charge_url)
    local args = {goodId = sProductId, orderId = out_trade_no}
    
    local function funcMainPay()
      SdkHelper.OpenWaiting()
      CS.PayLuaface.MainPay(Json.encode(args), function(jsonStr, receipt, signature)
        local jsonData = Json.decode(jsonStr)
        local isSuccess = jsonData.Success
        local receipt = jsonData.Receipt
        local signature = jsonData.Signature
        if not isSuccess then
          SdkReporter.TrackBuyFail(out_trade_no, payAmount, sPayType, sProductId, productName, isFirst)
          SdkHelper.CloseWaiting()
          return
        end
        
        local function cbSuccess(json)
          SdkHelper.CloseWaiting()
          SdkReporter.TrackBuySuccess(out_trade_no, payAmount, sPayType, sProductId, productName, isFirst)
          pcall(cb, json)
          local argsConsume = {ProductId = sProductId}
          CS.PayLuaface.MainConsume(Json.encode(argsConsume))
        end
        
        local function cbFail(json)
          SdkHelper.CloseWaiting()
        end
        
        Net:SendProto("pay.gp_charge_refresh", cbSuccess, receipt, signature, cbFail)
      end)
    end
    
    local function funcOcWebTip()
      SdkHelper.CloseWaiting()
      
      local function yesFunc()
        OfficialWebPayHelper.Buy(productId, cb, uiParams, {tipWebCoin = false})
      end
      
      if WebViewHelper.CanUseWebView() then
        UIManager:Open("UI/Japanpay/JapanPay", uiParams, yesFunc, funcMainPay)
      else
        UIManager:Open("UI/Common/PayTips/TokenPayTipsPlus", nil, yesFunc, funcMainPay)
      end
    end
    
    if OfficialWebCoinPayHelper.CanOfficalWebCoinPay(productId) then
      OfficialWebCoinPayHelper.StartOfficialWebCoinPay(productId, out_trade_no, uiParams, cb, funcOcWebTip)
    else
      funcOcWebTip()
    end
  end, sProductId, shpoId)
end

function PayGoogleHelper.RestoreCharge(jsonStr)
  local jsonData = Json.decode(jsonStr)
  local isSuccess = jsonData.Success
  local receipt = jsonData.Receipt
  local signature = jsonData.Signature
  local productId = jsonData.ProductId
  if not isSuccess then
    return
  end
  
  local function cbSuccess(json)
    CommonTips.OpenTips(json.msg)
  end
  
  local function cbFail(json)
    local rc = json.rc
    if rc == "" then
      return
    end
    if rc == "80100300" then
      CS.PayLuaface.MainConsume(jsonStr)
    end
  end
  
  Net:SendProto("pay.gp_charge_refresh", cbSuccess, receipt, signature, cbFail)
end

return PayGoogleHelper
