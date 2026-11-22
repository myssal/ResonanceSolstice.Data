local PayDmmHelper = {}
PayDmmHelper.RestoreActions = {}

function PayDmmHelper.Buy(productId, cb, uiParams)
  local args = Json.decode(uiParams)
  local productName = args.name
  local payAmount = args.payAmount
  local shpoId = args.shopId
  local currencyType = PayHelper.GetCurrencyTypeStr()
  local sPayType = "dmm"
  SdkHelper.OpenWaiting()
  Net:SendProto("pay.create_oid", function(json1)
    local isFirst = json1.is_first or 0
    local out_trade_no = json1.out_trade_no
    SdkReporter.TrackOrder(out_trade_no, payAmount, currencyType, sPayType)
    CS.PayLuaface.PayByDmm(productId, function(isSuccess, inAppPurchaseData, inAppDataSignature)
      if not isSuccess then
        SdkReporter.TrackBuyFail(out_trade_no, payAmount, sPayType, productId, productName, isFirst)
        SdkHelper.CloseWaiting()
        return
      end
      
      local function cbSuccess(json)
        SdkHelper.CloseWaiting()
        SdkReporter.TrackBuySuccess(out_trade_no, payAmount, sPayType, productId, productName, isFirst)
        PayDmmHelper.ConfirmPendingPurchase()
        pcall(cb, json)
      end
      
      local function cbFail(json)
        SdkHelper.CloseWaiting()
        PayDmmHelper.OnIosChargeRefreshFailed(json)
      end
      
      Net:SendProto("pay.dmm_charge_refresh", cbSuccess, inAppPurchaseData, inAppDataSignature, cbFail)
    end)
  end, productId, shpoId)
end

function PayDmmHelper.OnInitialized()
  Debug.Log("PayDmmHelper.OnInitialized")
end

function PayDmmHelper.OnDmmRestoreTransactions(result, transactionId)
end

function PayDmmHelper.OnDmmFirstProcessPurchase(receipt, transactioniId)
  if receipt == nil or receipt == "" then
    return
  end
end

function PayDmmHelper.OnDmmProcessPurchase(receipt, transactioniId)
  if receipt == nil or receipt == "" then
    return
  end
  if LoginGV.IsEnterGame() == false then
    local t = {inAppPurchaseData = receipt, inAppDataSignature = transactioniId}
    table.insert(PayDmmHelper.RestoreActions, t)
    return
  end
  PayDmmHelper.RestoreIosPurchase(receipt, transactioniId)
end

function PayDmmHelper.RestoreIosPurchase(receipt, transactionId)
  local function cbSuccess(json)
    PayDmmHelper.ConfirmPendingPurchase()
    
    CommonTips.OpenShowItem(json.reward)
  end
  
  local function cbFail(json)
    PayDmmHelper.OnIosChargeRefreshFailed(json)
  end
  
  Net:SendProto("pay.dmm_charge_refresh", cbSuccess, receipt, transactionId, cbFail)
end

function PayDmmHelper.OnIosChargeRefreshFailed(json)
  local rc = json.rc
  if rc == "" then
    return
  end
  CommonTips.OpenTips(json.msg)
  if rc == "80100300" then
    PayDmmHelper.ConfirmPendingPurchase()
  end
end

function PayDmmHelper.ConfirmPendingPurchase()
  CommonHelper.SafeCallCsFunc(CS.PayLuaface.ChannelConfirmPendingPurchase)
end

function PayDmmHelper.OnEnterGame()
  local ts = PayDmmHelper.RestoreActions
  if ts == nil then
    return
  end
  for i, v in pairs(ts) do
    PayDmmHelper.RestoreIosPurchase(v.inAppPurchaseData, v.inAppDataSignature)
  end
  PayDmmHelper.RestoreActions = {}
end

return PayDmmHelper
