local CommonItem = require("Common/BtnItem")
local View = require("UIGroup_Construction/UIGroup_ConstructionView")
local DataModel = require("UIGroup_Construction/UIGroup_ConstructionDataModel")
local ViewFunction = {
  Group_Construction_Group_Residue_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local row = DataModel.NotJoinReward[elementIndex]
    CommonItem:SetItem(element.Group_Item, row)
    element.Group_Item.Btn_Item:SetClickParam(row.id)
  end,
  Group_Construction_Group_Residue_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(str, nil, nil, true)
  end,
  Group_Construction_Group_Residue_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(DataModel.activityCA.helpId)
  end,
  Group_Construction_Group_Residue_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local row = DataModel.ConstructionPreviewList[elementIndex]
    element.Group_Item.Btn_Item:SetClickParam(row.id)
    local ca = PlayerData:GetFactoryData(row.id)
    element.Group_Item.Img_Item:SetSprite(ca.iconPath or ca.imagePath)
    element.Group_Item.Txt_Name:SetText(ca.name)
  end,
  Group_Construction_Group_Residue_ScrollGrid_List_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(str, nil, nil, true)
  end
}
return ViewFunction
