local View = require("UIShowCharacter/UIShowCharacterView")
local UIShowCharacterController = {}

function UIShowCharacterController:InitView(initParams)
  ComBtnShareComp.InitButton(View.Btn_Share)
end

function UIShowCharacterController:GetSpineUrl(unitView)
  if unitView == nil then
    return ""
  end
  if unitView.gachaPerformUrl ~= nil and unitView.gachaPerformUrl ~= "" then
    return unitView.gachaPerformUrl
  elseif unitView.spine2Url ~= nil and unitView.spine2Url ~= "" then
    return unitView.spine2Url
  else
    return ""
  end
end

function UIShowCharacterController:TryCloseView()
  RateHelper.TryOpenRateWhenGetSSR(1)
end

function UIShowCharacterController:OnBtnShare()
  ComBtnShareComp.OnClickShareWithNoneArgs(View.Btn_Share)
end

return UIShowCharacterController
