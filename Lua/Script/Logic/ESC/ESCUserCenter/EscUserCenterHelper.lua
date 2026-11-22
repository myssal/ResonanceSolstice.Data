local EscUserCenterHelper = {}
EscUserCenterHelper.BindAccountSuccessListener1 = nil

function EscUserCenterHelper.IsShowRedPoint()
  local isKR = SdkRegionHelper.IsRegionKR()
  if isKR then
    return ChannelUJoyHelper.IsLoginTypeVisitor()
  else
    return false
  end
end

function EscUserCenterHelper.OnBindAccountSuccess()
  local func = EscUserCenterHelper.BindAccountSuccessListener1
  if func == nil then
    return
  end
  pcall(func)
  EscUserCenterHelper.BindAccountSuccessListener1 = nil
end

return EscUserCenterHelper
