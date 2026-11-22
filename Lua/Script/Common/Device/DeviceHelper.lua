local DeviceHelper = {}

function DeviceHelper.GetDeviceId()
  local s, deviceId = CommonHelper.SafeCallCsFunc(CS.DeviceHelper.GetDeviceUniqueIdentifier)
  return deviceId or ""
end

function DeviceHelper.IsDeviceIOS()
  return PayHelper.IsPayPlatformIOS()
end

function DeviceHelper.GetDeviceModel()
  local s, r = CommonHelper.SafeCallCsFunc(CS.HK.Core.Utils.UtilsDevices.GetDeviceModel)
  return r or "nil"
end

function DeviceHelper.GetDeviceMemorySizeTotal()
  local s, r = CommonHelper.SafeCallCsFunc(CS.HK.Core.Utils.UtilsDevices.GetRunningMemoryTotalSize)
  return r or "nil"
end

return DeviceHelper
