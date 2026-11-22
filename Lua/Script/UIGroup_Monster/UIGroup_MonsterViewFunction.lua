local CommonItem = require("Common/BtnItem")
local View = require("UIGroup_Monster/UIGroup_MonsterView")
local DataModel = require("UIGroup_Monster/UIGroup_MonsterDataModel")
local ViewFunction = {
  Group_Monster_Group_Residue_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local row = DataModel.NotJoinReward[elementIndex]
    CommonItem:SetItem(element.Group_Item, row)
    element.Group_Item.Btn_Item:SetClickParam(row.id)
  end,
  Group_Monster_Group_Residue_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(str, nil, nil, true)
  end,
  Group_Monster_Group_Residue_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(DataModel.activityCA.helpId)
  end
}
return ViewFunction
