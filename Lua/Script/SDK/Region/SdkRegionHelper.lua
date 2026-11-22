local SdkRegionHelper = {}

function SdkRegionHelper.GetRegion()
  return SdkRuntimeSetting.GetRegion()
end

function SdkRegionHelper.IsRegionCN()
  return SdkRuntimeSetting.IsRegionCN()
end

function SdkRegionHelper.IsRegionJP()
  return SdkRuntimeSetting.IsRegionJP()
end

function SdkRegionHelper.IsNotRegionJP()
  return SdkRuntimeSetting.IsRegionJP() == false
end

function SdkRegionHelper.IsRegionKR()
  return SdkRuntimeSetting.IsRegionKR()
end

function SdkRegionHelper.IsNotRegionKR()
  return SdkRuntimeSetting.IsRegionKR() == false
end

function SdkRegionHelper.IsRegionUS()
  return SdkRuntimeSetting.IsRegionUS()
end

function SdkRegionHelper.IsRegionTW()
  return SdkRuntimeSetting.IsRegionTW()
end

return SdkRegionHelper
