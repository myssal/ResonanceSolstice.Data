local PayIapMgr = {}

function PayIapMgr.OnInitialized()
  Debug.Log("PayIapMgr.OnInitialized")
end

function PayIapMgr.OnRestoreTransactions(result, transactionId)
end

function PayIapMgr.OnFirstProcessPurchase(receipt, transactioniId)
  if receipt == nil or receipt == "" then
    return
  end
end

function PayIapMgr.OnProcessPurchase(receipt, transactioniId)
  if receipt == nil or receipt == "" then
    return
  end
  PayIapMgr:RestoreIosPurchase(receipt, transactioniId)
end

function PayIapMgr:RestoreIosPurchase(receipt, transactionId)
  local function cbSuccess(json)
    PayIapMgr:ConfirmPendingPurchase()
    
    CommonTips.OpenShowItem(json.reward)
  end
  
  local function cbFail(json)
    PayIapMgr:OnIosChargeRefreshFailed(json)
  end
  
  Net:SendProto("pay.ios_charge_refresh", cbSuccess, receipt, "", transactionId, cbFail)
end

function PayIapMgr:OnIosChargeRefreshFailed(json)
  local rc = json.rc
  if rc == "" then
    return
  end
  CommonTips.OpenTips(json.msg)
  if rc == "80100300" then
    self:ConfirmPendingPurchase()
  end
end

function PayIapMgr:GetTransactionId()
  local isSuccess, result = CommonHelper.SafeCallCsFunc(CS.PayLuaface.GetTransactionId)
  return result or ""
end

function PayIapMgr:ConfirmPendingPurchase()
  CommonHelper.SafeCallCsFunc(CS.PayLuaface.ConfirmPendingPurchase)
end

return PayIapMgr
