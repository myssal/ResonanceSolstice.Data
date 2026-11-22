local View = require("UILeadCommentTip/UILeadCommentTipView")
local ViewController = {}

function ViewController:OnBtnAccept()
  UJoyRateHelper.SetIsOpenedGameRate()
  View.self:CloseUI()
  UJoyRateHelper.OpenNativeRate()
end

function ViewController:OnBtnRefuse()
  View.self:CloseUI()
end

return ViewController
