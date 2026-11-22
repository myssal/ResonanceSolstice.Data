local View = require("UIFightAward/UIFightAwardView")
local DataModel = require("UIFightAward/UIFightAwardDataModel")
local BtnItem = require("Common/BtnItem")
local ViewFunction = {
  FightAward_Btn_Close_Click = function(btn, str)
    View.self:CloseUI()
  end,
  FightAward_ScrollGrid_Item_SetGrid = function(element, elementIndex)
    local data = DataModel.reward[elementIndex]
    element.Btn_Item:SetClickParam(data.id)
    BtnItem:SetItem(element, {
      id = data.id,
      num = data.num
    })
  end,
  FightAward_ScrollGrid_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  FightAward_Btn_Confirm_Click = function(btn, str)
    Net:SendProto("playground.fg_reward_list", function(json)
      View.self:CloseUI()
      View.self:Confirm()
      CommonTips.OpenTips(80610272)
    end, 1)
  end
}
return ViewFunction
