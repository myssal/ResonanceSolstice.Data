local SdkShareHelper = {}

function SdkShareHelper.IsShareUsable()
  local s, r = CommonHelper.SafeCallCsFunc(CS.MSDKExternSetting.IsUseNativeShare)
  if s == nil or r == nil then
    return false
  end
  local result = r
  return result
end

function SdkShareHelper.StartShare(args, cb)
  if SdkShareHelper.IsShareUsable() then
    CommonHelper.SafeCallCsFunc(CS.GameSdkLuaface.StartShare, args, cb)
  end
end

return SdkShareHelper
