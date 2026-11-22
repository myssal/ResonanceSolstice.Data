local PaySetting = {}

function PaySetting:HasCSPaySetting()
  if CS.PaySetting == nil then
    return false
  end
  return true
end

function PaySetting:CanCnOfficialWebPcPayTotal()
  if CS.PaySetting == nil then
    return true
  end
  local s, r = CommonHelper.SafeCallCsFunc(CS.PaySetting.GetCnOcPcWebPayTotal)
  if s == nil or r == nil or s == false then
    return true
  end
  if r == 1 then
    return false
  end
  return true
end

function PaySetting:GetCnOcPcWebPayTotalDisableTipContent()
  if CS.PaySetting == nil then
    return ""
  end
  local s, r = CommonHelper.SafeCallCsFunc(CS.PaySetting.GetCnOcPcWebPayTotalDisableTipContent)
  if s == nil or r == nil or s == false then
    return ""
  end
  return r
end

function PaySetting:GetCnOcPcWebPayTotalDisableTipBtnOk()
  if CS.PaySetting == nil then
    return ""
  end
  local s, r = CommonHelper.SafeCallCsFunc(CS.PaySetting.GetCnOcPcWebPayTotalDisableTipBtnOk)
  if s == nil or r == nil or s == false then
    return ""
  end
  return r
end

return PaySetting
