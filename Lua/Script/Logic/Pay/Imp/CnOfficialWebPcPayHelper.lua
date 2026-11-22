local CnOfficialWebPcPayHelper = {}

function CnOfficialWebPcPayHelper.IsUseCnOfficialWebPcPay()
  if SdkRegionHelper.IsRegionCN() and SdkChannelHelper.IsCurCnOfficial() and PlatformHelper.IsPC() then
    return true
  else
    return false
  end
end

function CnOfficialWebPcPayHelper.Buy(productId, cb, uiParams)
  if not CnOfficialWebPcPayHelper.CanBuy() then
    return
  end
  local args = Json.decode(uiParams)
  local shpoId = args.shopId
  
  local function onCreateOid(json)
    if json.rc and json.rc ~= "" then
      CommonTips.OpenTips(json.msg)
      return
    end
    local charge_url = json.charge_url_cn or ""
    local charge_tips = json.charge_tips or ""
    
    local function funcPay()
      SdkHelper.CloseWaiting()
      if charge_url ~= nil and charge_url ~= "" then
        CS.UnityEngine.Application.OpenURL(charge_url)
        if charge_tips ~= nil and charge_tips == "1" then
          CommonTips.OnPromptConfirmOnly("80608797", "80600068", function()
          end, false)
        end
      end
    end
    
    local out_trade_no = json.out_trade_no
    if OfficialWebCoinPayHelper.CanOfficalWebCoinPay(productId) then
      OfficialWebCoinPayHelper.StartOfficialWebCoinPay(productId, out_trade_no, uiParams, cb, funcPay)
    else
      funcPay()
    end
  end
  
  local needRealInfo = PayHelper.GetArgNeedRealInfo()
  Net:SendProto("pay.create_oid", onCreateOid, productId, shpoId, PayGV.PayType.Web, needRealInfo)
end

function CnOfficialWebPcPayHelper.CanBuy()
  if CnOfficialWebPcPayHelper.CanBuyTotal() == false then
    return false
  end
  if SdkAdMarkHelper.IsTypeTaptap() then
    return CnOfficialWebPcPayHelper.CanBuyTap()
  end
  return true
end

function CnOfficialWebPcPayHelper.CanBuyTotal()
  if PaySetting:CanCnOfficialWebPcPayTotal() == false then
    local txtOk = PaySetting:GetCnOcPcWebPayTotalDisableTipBtnOk()
    local txtContent = PaySetting:GetCnOcPcWebPayTotalDisableTipContent()
    CommonTips.OnPromptConfirmOnly(txtContent, txtOk, function()
    end, false)
    return false
  end
  return true
end

function CnOfficialWebPcPayHelper.CanBuyTap()
  local wantedLv = Net.pc_tap_charge_playerlv
  local nowPlayerlv = PlayerData:GetPlayerLevel()
  if wantedLv < 0 or wantedLv > nowPlayerlv then
    CommonTips.OnPromptConfirmOnly("80610063", "80600068", function()
    end, false)
    return false
  end
  return true
end

return CnOfficialWebPcPayHelper
