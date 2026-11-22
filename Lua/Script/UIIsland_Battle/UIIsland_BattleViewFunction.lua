local View = require("UIIsland_Battle/UIIsland_BattleView")
local DataModel = require("UIIsland_Battle/UIIsland_BattleDataModel")
local Controller = require("UIIsland_Battle/UIIsland_BattleController")
local ViewFunction = {
  Island_Battle_ScrollView_Select_Viewport_Content_Group_Select_Btn_Return_Click = function(btn, str)
  end,
  Island_Battle_ScrollView_Select_Viewport_Content_Group_Select_Group_Level_Group_Level_Btn_Select_Click = function(btn, str)
  end,
  Island_Battle_ScrollView_Select_Viewport_Content_Group_Select_Group_Level_StaticGrid_Level_SetGrid = function(element, elementIndex)
    Controller:SetLevelGrid(element, elementIndex)
  end,
  Island_Battle_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if DataModel.upDateLevelTime then
      return
    end
    Controller:OnClickReturn()
  end,
  Island_Battle_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  Island_Battle_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Island_Battle_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Island_Battle_Group_Right_Btn_Energy_Click = function(btn, str)
    if DataModel.upDateLevelTime then
      return
    end
    Controller:OpenEnergyBuy()
  end,
  Island_Battle_Group_Right_Btn_Energy_Btn_Add_Click = function(btn, str)
  end,
  Island_Battle_Group_Right_Group_Drop_ScrollGrid_Item_SetGrid = function(element, elementIndex)
    Controller:OnSetRewardGrid(element, elementIndex)
  end,
  Island_Battle_Group_Right_Group_Drop_ScrollGrid_Item_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  Island_Battle_Group_Right_Group_Fight_Btn_StartFight_Click = function(btn, str)
    if DataModel.upDateLevelTime then
      return
    end
    Controller:TryBattle()
  end,
  Island_Battle_Group_Right_Group_Auto_Btn_Auto_Click = function(btn, str)
    if DataModel.upDateLevelTime then
      return
    end
    Controller:OnClickBtnAuto()
  end,
  Island_Battle_Group_Right_Btn_Close_Click = function(btn, str)
    if DataModel.upDateLevelTime then
      return
    end
    Controller:CloseLevelDetail()
  end,
  Island_Battle_ScrollView_Select_Viewport_Content_Group_Select_Group_Level_StaticGrid_Level_Group_Level_Btn_Select_Click = function(btn, str)
    if DataModel.upDateLevelTime then
      return
    end
    Controller:OnClickLevel(tonumber(str))
  end
}
return ViewFunction
