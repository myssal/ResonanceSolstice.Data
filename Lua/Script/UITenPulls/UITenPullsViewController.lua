local View = require("UITenPulls/UITenPullsView")
local ViewController = {}

function ViewController:InitView(InitView)
  ComBtnShareComp.InitButton(View.Btn_Share)
  RateHelper.TryOpenRateWhenTenPullsViewOpen()
end

function ViewController:OnBtnShare()
  ComBtnShareComp.OnClickShareWithNoneArgs(View.Btn_Share)
end

return ViewController
