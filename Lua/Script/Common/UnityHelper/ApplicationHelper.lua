local ApplicationHelper = {}

function ApplicationHelper.OpenUrl(url)
  if PlatformHelper.IsIPhone() then
    if CommonHelper.HasCsFunc(CS.ApplicationHelper.OpenUrl) then
      CommonHelper.SafeCallCsFunc(CS.ApplicationHelper.OpenUrl, url)
    else
      CS.UnityEngine.Application.OpenURL(url)
    end
  else
    CS.UnityEngine.Application.OpenURL(url)
  end
end

return ApplicationHelper
