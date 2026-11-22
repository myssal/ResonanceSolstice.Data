local CnBiliPcPayHelper = {}

function CnBiliPcPayHelper.IsUse()
  if SdkChannelHelper.IsCurCnBiliPc() then
    return true
  else
    return false
  end
end

function CnBiliPcPayHelper.IsUseBiliPcPayType()
  local s, r = CommonHelper.SafeCallCsFunc(CS.MSDKExternSetting.IsBiliPcPayUsable)
  if s == nil or r == nil then
    return false
  end
  return r
end

function CnBiliPcPayHelper.GetOcWebPayRoleLevel()
  local s, r = CommonHelper.SafeCallCsFunc(CS.MSDKExternSetting.GetBiliPcOcWebPayRoleLevel)
  if s == nil or r == nil then
    return 99
  end
  return r
end

function CnBiliPcPayHelper.GetBiliPcPayTipUrl()
  local s, r = CommonHelper.SafeCallCsFunc(CS.MSDKExternSetting.GetBiliPcPayTipUrl)
  return r or ""
end

function CnBiliPcPayHelper.Buy(productId, cb, uiParams)
  local isUseBiliPcPay = CnBiliPcPayHelper.IsUseBiliPcPayType()
  local nowPlayerlv = PlayerData:GetPlayerLevel()
  local targetPlayerLv = CnBiliPcPayHelper.GetOcWebPayRoleLevel()
  local svrLv = Net.bilipc_charge_playerlv
  if svrLv ~= nil and type(svrLv) == "number" and 0 < svrLv then
    targetPlayerLv = svrLv
  end
  Debug.Log(string.format("[CnBiliPcPayHelper]nowPlayerlv=%s,targetPlayerLv=%s", nowPlayerlv, targetPlayerLv))
  if isUseBiliPcPay == false then
    Net:SendProto("main.query_ip_address", function(json)
      local registerRegion = CnBiliPcPayHelper.GetCityFromAddress(json.reg_addr)
      local currentRegion = CnBiliPcPayHelper.GetCityFromAddress(json.lg_addr)
      local blockedRegions = Net.bilipc_charge_blocked_regions
      if CnBiliPcPayHelper.IsInBlockedRegion(registerRegion, currentRegion, blockedRegions) then
        targetPlayerLv = Net.bilipc_charge_blocked_ip_playerlv
      else
        targetPlayerLv = Net.bilipc_charge_normal_ip_playerlv
      end
      if targetPlayerLv == nil or type(targetPlayerLv) ~= "number" or targetPlayerLv <= 0 then
        targetPlayerLv = CnBiliPcPayHelper.GetOcWebPayRoleLevel()
      end
      if nowPlayerlv < targetPlayerLv then
        local tipUrl = CnBiliPcPayHelper.GetBiliPcPayTipUrl()
        if tipUrl ~= "" then
          CS.UnityEngine.Application.OpenURL(tipUrl)
        end
        CommonTips.OnPromptConfirmOnly("80609665", "80600068", function()
        end, false)
      else
        CnOfficialWebPcPayHelper.Buy(productId, cb, uiParams)
      end
    end)
    return
  end
  local args = Json.decode(uiParams)
  local productName = args.name
  local payAmount = args.payAmount
  local shpoId = args.shopId
  local currencyType = PayHelper.GetCurrencyTypeStr()
  Net:SendProto("pay.biligame_order_str", function(json)
    local isFirst = json.is_first or 0
    local orignData = json.origin_data
    local out_trade_no = orignData.out_trade_no
    SdkReporter.TrackOrder(out_trade_no, payAmount, currencyType, "bilibili")
    orignData.subject = productName
    orignData.body = productName
    orignData.sign = json.sign
    local jsonStr = Json.encode(orignData)
    print_r("[Pay]pay.biligame_order_str recv jsonStr=" .. jsonStr)
    PayHelper.CallChannelPay(function(json)
      local jsonData = Json.decode(json)
      if jsonData.Status ~= 0 then
        SdkReporter.TrackBuyFail(out_trade_no, payAmount, "bilibili", productId, productName, isFirst)
        return
      end
      SdkReporter.TrackBuySuccess(out_trade_no, payAmount, "bilibili", productId, productName, isFirst)
      PayHelper.ReqQueryOID(out_trade_no, cb, args)
    end, jsonStr)
  end, productId, shpoId, "biligame_pc")
end

function CnBiliPcPayHelper.IsInBlockedRegion(registerRegion, currentRegion, blockedRegions)
  if string.nilorempty(blockedRegions) then
    return false
  end
  local regions = string.split(blockedRegions, "|")
  for k, v in ipairs(regions) do
    if v ~= nil and type(v) == "string" then
      if not string.nilorempty(registerRegion) and string.contains(v, registerRegion) then
        return true
      end
      if not string.nilorempty(currentRegion) and string.contains(v, currentRegion) then
        return true
      end
    end
  end
  return false
end

function CnBiliPcPayHelper.GetCityFromAddress(address)
  if address == nil or type(address) ~= "table" or address.city == nil or type(address.city) ~= "string" then
    return ""
  end
  return address.city
end

return CnBiliPcPayHelper
