local View = require("UIShowItemBad/UIShowItemBadView")
local DataModel = require("UIShowItemBad/UIShowItemBadDataModel")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  ShowItemBad_Btn_OK_Click = function(btn, str)
    CommonItem:DestroyInstantiate()
    UIManager:CloseTip("UI/Monopoly/UI/ShowItemBad")
    View.self:Confirm()
  end,
  ShowItemBad_ScrollGrid_Items_SetGrid = function(element, elementIndex)
    local row = DataModel.Data[tonumber(elementIndex)]
    CommonItem:SetItem(element.Group_Item, row, nil, 1, View, true)
    element.Group_Item.Btn_Item:SetClickParam(elementIndex)
    element.Group_Item.Group_Extra:SetActive(row.extra == true or row.product_extra)
    element.Group_Item.Group_ExtraBuff:SetActive(row.product_buff)
  end,
  ShowItemBad_ScrollGrid_Items_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(DataModel.Data[tonumber(str)].id, DataModel.Data[tonumber(str)])
  end
}
return ViewFunction
