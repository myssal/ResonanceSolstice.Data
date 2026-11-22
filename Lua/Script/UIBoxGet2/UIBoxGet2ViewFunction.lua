local View = require("UIBoxGet2/UIBoxGet2View")
local DataModel = require("UIBoxGet2/UIBoxGet2DataModel")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  BoxGet2_StaticGrid_reward_SetGrid = function(element, elementIndex)
    local row = DataModel.Data[tonumber(elementIndex)]
    CommonItem:SetItem(element.Group_Item, row, nil, 1)
    element.Group_Item.Btn_Item:SetClickParam(elementIndex)
    print_r(row)
    element.Group_Txt.Txt_Name:SetText(row.factoryName.name)
    element.Group_Txt.Txt_Num:SetText(tostring(row.num))
  end,
  BoxGet2_StaticGrid_reward_Group_reward_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(DataModel.Data[tonumber(str)].id, DataModel.Data[tonumber(str)])
  end,
  BoxGet2_Group_reward_Group_Item_Btn_Item_Click = function(btn, str)
  end
}
return ViewFunction
