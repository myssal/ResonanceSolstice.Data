local OfficialWebPayHelper = {}
OfficialWebPayHelper.PTYPE_NONE = "0"
OfficialWebPayHelper.PTYPE_CARD = "1"
OfficialWebPayHelper.PTYPE_GOOGLE = "2"
OfficialWebPayHelper.PTYPE_APPLE = "3"

function OfficialWebPayHelper.Buy(productId, cb, uiParams, eArgs)
  local args = Json.decode(uiParams)
  local payAmount = args.payAmount
  local productName = args.name
  local productDesc = args.name
  local currencyType = PayHelper.GetCurrencyTypeStr()
  local channelFlag = "airwallex"
  local ptype = OfficialWebPayHelper.GetPayType()
  if eArgs == nil then
    eArgs = PayHelper.GetDefaultEArgs()
  end
  
  local function onRecvOrder(json)
    local url = json.notify_url
    local out_trade_no = json.out_trade_no
    local amount = payAmount
    
    local function funcPay()
      CommonTips.OnPromptConfirmOnly("80608797", "80600068", function()
      end, false)
      SdkReporter.TrackOrder(out_trade_no, payAmount, currencyType, channelFlag)
      if ptype == OfficialWebPayHelper.PTYPE_CARD or ptype == OfficialWebPayHelper.PTYPE_APPLE then
        WebViewHelper.OpenUrl(url)
      else
        ApplicationHelper.OpenUrl(url)
      end
    end
    
    local function funcCoinPayCancel()
      SdkHelper.CloseWaiting()
      funcPay()
    end
    
    if eArgs.tipWebCoin and OfficialWebCoinPayHelper.CanOfficalWebCoinPay(productId) then
      OfficialWebCoinPayHelper.StartOfficialWebCoinPay(productId, out_trade_no, uiParams, cb, funcCoinPayCancel)
    else
      funcPay()
    end
  end
  
  Net:SendProto("pay.common_order_str", onRecvOrder, channelFlag, productId, productName, nil, nil, nil, nil, nil, nil, ptype)
end

function OfficialWebPayHelper.GetPayType()
  local last = OfficialWebPayHelper.lastPayType
  if last == nil then
    return OfficialWebPayHelper.PTYPE_NONE
  else
    return last
  end
end

function OfficialWebPayHelper.SetPayType(pType)
  OfficialWebPayHelper.lastPayType = pType
end

return OfficialWebPayHelper
