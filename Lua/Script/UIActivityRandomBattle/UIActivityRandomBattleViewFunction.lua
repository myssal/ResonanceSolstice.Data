local View = require("UIActivityRandomBattle/UIActivityRandomBattleView")
local DataModel = require("UIActivityRandomBattle/UIActivityRandomBattleDataModel")
local Controller = require("UIActivityRandomBattle/UIActivityRandomBattleController")
local ViewFunction = {
  ActivityRandomBattle_Group_Main_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:OnSetPreviewGrid(element, elementIndex)
  end,
  ActivityRandomBattle_Group_Main_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:RewardClickElemnt(str)
  end,
  ActivityRandomBattle_Group_Main_Btn_Enter_Click = function(btn, str)
    Controller:OnBtnEnter()
  end,
  ActivityRandomBattle_Group_Main_Btn_Start_Click = function(btn, str)
    Controller:OnBtnStart()
  end,
  ActivityRandomBattle_Group_Main_Btn_Shop_Click = function(btn, str)
    Controller:OpenRandomBattleStore()
  end,
  ActivityRandomBattle_Group_Cost_Btn_BG_Click = function(btn, str)
  end,
  ActivityRandomBattle_Group_Cost_Group_Middle_ScrollGrid_Dikuang_SetGrid = function(element, elementIndex)
    Controller:OnSetCostGrid(element, elementIndex)
  end,
  ActivityRandomBattle_Group_Cost_Group_Middle_ScrollGrid_Dikuang_Group_Item_Img_Dikuang_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  ActivityRandomBattle_Group_Cost_Btn_Confirm_Click = function(btn, str)
    Controller:OnBtnCostConfirm()
  end,
  ActivityRandomBattle_Group_Cost_Btn_Cancel_Click = function(btn, str)
    Controller:OnBtnCostCancle()
  end,
  ActivityRandomBattle_Group_Start_Btn_BG_Click = function(btn, str)
    Controller:CloseGroupStart()
  end,
  ActivityRandomBattle_Group_Start_Btn_Min_Click = function(btn, str)
    Controller:MinNum()
  end,
  ActivityRandomBattle_Group_Start_Btn_Dec_Click = function(btn, str)
    Controller:SubNum()
  end,
  ActivityRandomBattle_Group_Start_Group_Slider_Slider_Value_Slider = function(slider, value)
    Controller:SetNum(math.floor(tonumber(value) + 0.5))
  end,
  ActivityRandomBattle_Group_Start_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  ActivityRandomBattle_Group_Start_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  ActivityRandomBattle_Group_Start_Btn_Add_Click = function(btn, str)
    Controller:AddNum()
  end,
  ActivityRandomBattle_Group_Start_Btn_Max_Click = function(btn, str)
    Controller:MaxNum()
  end,
  ActivityRandomBattle_Group_Start_Group_Middle_ScrollGrid_Dikuang_SetGrid = function(element, elementIndex)
    Controller:OnSetCostGrid(element, elementIndex)
  end,
  ActivityRandomBattle_Group_Start_Group_Middle_ScrollGrid_Dikuang_Group_Item_Img_Dikuang_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  ActivityRandomBattle_Group_Start_Btn_Confirm_Click = function(btn, str)
    Controller:OnInitMeleeAndOpenChoose()
  end,
  ActivityRandomBattle_Group_Start_Btn_Cancel_Click = function(btn, str)
    Controller:CloseGroupStart()
  end
}
return ViewFunction
