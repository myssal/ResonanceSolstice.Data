local SdkRuntimeSetting = {}

function SdkRuntimeSetting.GetRegion()
  local s, r = CommonHelper.SafeCallCsFunc(CS.GameSdkLuaface.GetRegion)
  return r or "CN"
end

function SdkRuntimeSetting.IsRegionCN()
  return SdkRuntimeSetting.GetRegion() == SdkConst.ERegion.CN
end

function SdkRuntimeSetting.IsRegionJP()
  return SdkRuntimeSetting.GetRegion() == SdkConst.ERegion.JP
end

function SdkRuntimeSetting.IsRegionKR()
  return SdkRuntimeSetting.GetRegion() == SdkConst.ERegion.KR
end

function SdkRuntimeSetting.IsRegionUS()
  return SdkRuntimeSetting.GetRegion() == SdkConst.ERegion.US
end

function SdkRuntimeSetting.IsRegionTW()
  return SdkRuntimeSetting.GetRegion() == SdkConst.ERegion.TW
end

return SdkRuntimeSetting
