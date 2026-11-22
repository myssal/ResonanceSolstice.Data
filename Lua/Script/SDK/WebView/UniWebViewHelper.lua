local UniWebViewHelper = {}

function UniWebViewHelper.CanUse()
  local s, r = CommonHelper.SafeCallCsFunc(CS.MSDKExternSetting.IsUseUniWebView)
  if s == nil or r == nil then
    return false
  end
  return r
end

function UniWebViewHelper.Open(url)
  if UniWebViewHelper.CanUse() == false then
    return
  end
  CommonHelper.SafeCallCsFunc(CS.UniWebViewUtil.Open, url)
end

return UniWebViewHelper
