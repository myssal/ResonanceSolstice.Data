local View = require("UILogin/UILoginView")
local Controller = {}

function Controller:InitView()
  local isShow = false
  if DataLinkLoginHelper.IsShowDataLink == false then
    View.Group_Account.Btn_Link:SetActive(false)
    return
  end
  if SdkRegionHelper.IsRegionJP() then
    isShow = true
  elseif SdkRegionHelper.IsRegionCN() then
    if PlatformHelper.IsPC() and not SdkChannelHelper.IsCurCnBiliPc() then
      isShow = true
    end
    if SdkChannelHelper.IsCurSteam() then
      isShow = false
    end
  end
  View.Group_Account.Btn_Link:SetActive(isShow)
end

function Controller:OpenDataLink()
  UIManager:Open("UI/Login/Link_Login/LinkLogin")
end

return Controller
