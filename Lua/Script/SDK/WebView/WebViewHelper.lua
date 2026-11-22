local WebViewHelper = {}
UniWebViewHelper = require("SDK/WebView/UniWebViewHelper")

function WebViewHelper.CanUseWebView()
  if PlatformHelper.IsAndroid() or PlatformHelper.IsIPhone() then
    return UniWebViewHelper.CanUse()
  else
    return false
  end
end

function WebViewHelper.OpenUrl(url)
  if WebViewHelper.CanUseWebView() == false then
    ApplicationHelper.OpenUrl(url)
    return
  end
  if PlatformHelper.IsAndroid() or PlatformHelper.IsIPhone() then
    UniWebViewHelper.Open(url)
  end
end

return WebViewHelper
