local View = require("UIActivityTurntable/UIActivityTurntableView")
local DataModel = require("UIActivityTurntable/UIActivityTurntableDataModel")
local Controller = require("UIActivityTurntable/UIActivityTurntableController")
local ViewFunction = {
  ActivityTurntable_Group_Main_StaticGrid_Reward_SetGrid = function(element, elementIndex)
    Controller.RefreshRewardElement(element, elementIndex)
  end,
  ActivityTurntable_Group_Main_Btn_One_Click = function(btn, str)
    Controller.OnOneBtnClick()
  end,
  ActivityTurntable_Group_Main_Btn_Many_Click = function(btn, str)
    Controller.OnManyBtnClick()
  end,
  ActivityTurntable_Group_Main_Group_Skip_Btn_Skip_Click = function(btn, str)
    Controller.OnSkipBtnClick()
  end,
  ActivityTurntable_Group_Main_Btn_View_Click = function(btn, str)
    Controller.OnSkinDetailBtnClick()
  end,
  ActivityTurntable_Group_Main_Group_Diamond_Btn_Add_Click = function(btn, str)
    CommonTips.OpenStoreBuy()
  end,
  ActivityTurntable_Group_Main_Group_GoldCoin_Btn_Add_Click = function(btn, str)
  end,
  ActivityTurntable_Group_Main_StaticGrid_Reward_Group_Reward_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    if not itemId then
      return
    end
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  ActivityTurntable_Group_BuyItem_Btn_BG_Click = function(btn, str)
    View.Group_BuyItem.self:SetActive(false)
  end,
  ActivityTurntable_Group_BuyItem_Group_Middle_Group_Item1_Btn_Item_Click = function(btn, str)
  end,
  ActivityTurntable_Group_BuyItem_Group_Middle_Group_Item2_Btn_Item_Click = function(btn, str)
  end,
  ActivityTurntable_Group_BuyItem_Btn_Confirm_Click = function(btn, str)
    Controller.OnBuyItemConfirmBtnClick()
  end,
  ActivityTurntable_Group_BuyItem_Btn_Cancel_Click = function(btn, str)
    View.Group_BuyItem.self:SetActive(false)
  end,
  ActivityTurntable_Group_Main_Group_ItemCoin_Btn_Add_Click = function(btn, str)
  end,
  ActivityTurntable_Group_Main_Btn_Probability_Click = function(btn, str)
    Controller.ShowProbabilityPanel()
  end,
  ActivityTurntable_Group_Probability_Btn_BG_Click = function(btn, str)
    View.Group_Probability:SetActive(false)
  end,
  ActivityTurntable_Group_Probability_Group_Three_Btn_Probability_Click = function(btn, str)
  end,
  ActivityTurntable_Group_Probability_Group_Probability_ScrollGrid_detail_SetGrid = function(element, elementIndex)
    Controller.RefreshProbabilityItemElement(element, elementIndex)
  end
}
return ViewFunction
