local View = require("UIChoseSkinTip/UIChoseSkinTipView")
local DataModel = require("UIChoseSkinTip/UIChoseSkinTipDataModel")
local ViewFunction = {
  ChoseSkinTip_Btn_BG_Click = function(btn, str)
    UIManager:GoBack()
  end,
  ChoseSkinTip_Btn_Cancel_Click = function(btn, str)
    UIManager:GoBack()
  end,
  ChoseSkinTip_Btn_Sale_Click = function(btn, str)
    Net:SendProto("item.use_items", function(json)
      UIManager:GoBack()
      CommonTips.OpenShowItem(json.reward, function()
        UIManager:GoBack()
      end)
      PlayerData:RefreshUseItems({
        [DataModel.ItemId] = 1
      })
    end, tostring(DataModel.ItemId), 1, DataModel.Index - 1, 0)
  end,
  ChoseSkinTip_ScrollGrid_List_SetGrid = function(element, elementIndex)
  end,
  ChoseSkinTip_ScrollGrid_List_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  ChoseSkinTip_Group_SkinCho_ScrollGrid_List_SetGrid = function(element, elementIndex)
  end
}
return ViewFunction
