local View = require("UIOrderTips/UIOrderTipsView")
local DataModel = require("UIOrderTips/UIOrderTipsDataModel")
local ViewFunction = {
  OrderTips_Btn_BG_Click = function(btn, str)
    UIManager:CloseTip("UI/StageQuest/Order/OrderTips")
  end,
  OrderTips_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenRewardDetail(DataModel.ItemId)
  end,
  OrderTips_Btn_Min_Click = function(btn, str)
    DataModel.CurNum = 1
    DataModel.RefreshPanel()
  end,
  OrderTips_Btn_Dec_Click = function(btn, str)
    DataModel.CurNum = DataModel.CurNum - 1
    if DataModel.CurNum < 1 then
      DataModel.CurNum = 1
    end
    DataModel.RefreshPanel()
  end,
  OrderTips_Group_Slider_Slider_Value_Slider = function(slider, value)
    DataModel.CurNum = math.floor(value + 0.5)
    DataModel.SetSlider()
  end,
  OrderTips_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  OrderTips_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  OrderTips_Btn_Add_Click = function(btn, str)
    DataModel.CurNum = DataModel.CurNum + 1
    if DataModel.CurNum > DataModel.MaxNum then
      DataModel.CurNum = DataModel.MaxNum
    end
    DataModel.RefreshPanel()
  end,
  OrderTips_Btn_Max_Click = function(btn, str)
    DataModel.CurNum = DataModel.MaxNum
    DataModel.RefreshPanel()
  end,
  OrderTips_Btn_Cancel_Click = function(btn, str)
    UIManager:CloseTip("UI/StageQuest/Order/OrderTips")
  end,
  OrderTips_Btn_Sale_Click = function(btn, str)
    local orderController = require("UIStageQuest/UIStageQuestController")
    orderController:DoDeliverTeamOrder(DataModel.CurNum)
    UIManager:CloseTip("UI/StageQuest/Order/OrderTips")
  end
}
return ViewFunction
