local View = require("UIDiceReward/UIDiceRewardView")
local Controller = {}

function Controller.Init(diceNum, itemId)
  View.Group_Reward.Group_Des.Txt_Num:SetText(tostring(diceNum))
  local ca = PlayerData:GetFactoryData(itemId, "ItemFactory")
  if ca then
    View.Group_Reward.Group_Des.Txt_Name:SetText(ca.name)
    View.Group_Reward.Btn_Icon:SetSprite(ca.iconPath)
    View.Group_Reward.Btn_Icon:SetClickParam(itemId)
  end
end

return Controller
