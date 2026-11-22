local SdkAdMarkHelper = {}

function SdkAdMarkHelper.GetType()
  local s, r = CommonHelper.SafeCallCsFunc(CS.GameSdkConst.GetAdMarkType)
  if r == nil then
    return ""
  end
  return r
end

function SdkAdMarkHelper.IsTypeTaptap()
  return SdkAdMarkHelper.GetType() == "oc_pc_tap"
end

function SdkAdMarkHelper.IsTypeOverseas()
  return SdkAdMarkHelper.GetType() == "oc_pc_overseas"
end

return SdkAdMarkHelper
