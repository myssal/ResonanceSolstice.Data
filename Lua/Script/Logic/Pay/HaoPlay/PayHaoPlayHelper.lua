local PayHaoPlayHelper = {}
PayHaoPlayHelper.QueryDelay = 1.2

function PayHaoPlayHelper.Buy(productId, shopId, cb)
  local payType = "haoplay"
  local currencyType = PayHelper.GetCurrencyTypeStr()
  local configPriceAmount = PayProductHelper.GetProductConfigPriceAmount(productId)
  local configName = PayProductHelper.GetProductConfigName(productId)
  
  local function funcSuccess(json1)
    local isFirst = json1.is_first or 0
    local out_trade_no = json1.out_trade_no
    local extra = {
      roleid = PlayerData:GetUserInfo().uid,
      level = PlayerData:GetPlayerLevel()
    }
    local extraJsonStr = Json.encode(extra)
    SdkReporter.TrackOrder(out_trade_no, configPriceAmount, currencyType, payType)
    local strNonce = out_trade_no
    if PlatformHelper.IsPC() then
      strNonce = string.format("%s|%s", out_trade_no, "pc")
      CommonTips.OnPromptConfirmOnly("80608797", "80600068", function()
      end, false)
    end
    CS.PayLuaface.BuyWithHaoPlay(productId, strNonce, extraJsonStr, function(success, productID, orderId, nonce, transactionId)
      if PlatformHelper.IsPC() then
        return
      end
      if not success then
        SdkReporter.TrackBuyFail(out_trade_no, configPriceAmount, payType, productId, configName, isFirst)
        return
      end
      SdkReporter.TrackBuySuccess(out_trade_no, configPriceAmount, payType, productId, configName, isFirst)
      local cbQuerySuccess = cb
      if cbQuerySuccess == nil then
        function cbQuerySuccess(json)
          CommonTips.OpenShowItem(json.reward)
        end
      end
      if PayHaoPlayHelper.IsNeedDelayQuery() then
        SdkHelper.OpenWaiting()
        TimerHelper.Start("PayHaoPlayHelper_Query", PayHaoPlayHelper.QueryDelay, function()
          SdkHelper.CloseWaiting()
          PayHelper.ReqQueryOID(out_trade_no, cbQuerySuccess)
          TimerHelper.Stop("PayHaoPlayHelper_Query")
        end)
      else
        PayHelper.ReqQueryOID(out_trade_no, cbQuerySuccess)
      end
    end)
  end
  
  Net:SendProto("pay.create_oid", funcSuccess, productId, shopId)
end

function PayHaoPlayHelper.IsNeedDelayQuery()
  return true
end

function PayHaoPlayHelper.OnRequestPayment(strProductId)
  PayHaoPlayHelper.Buy(strProductId, strProductId, nil)
end

function PayHaoPlayHelper.OnPaySuccess(strProductID, strOrderId, strNonce, strTransactionId)
  Debug.Log(string.format("[Pay][HaoPlay]OnPaySuccess productID=%s,orderId=%s,nonce=%s,transactionId=%s"))
end

return PayHaoPlayHelper
