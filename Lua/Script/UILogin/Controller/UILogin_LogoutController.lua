local View = require("UILogin/UILoginView")
local Controller = {}

function Controller:InitView()
  if SdkHelper.IsChannelDmm() then
    View.Group_Account.Btn_Logout:SetActive(false)
  end
end

return Controller
