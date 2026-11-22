local View = require("UIRandomLevel/UIRandomLevelView")
local DataModel = require("UIRandomLevel/UIRandomLevelDataModel")
local Controller = require("UIRandomLevel/UIRandomLevelController")
local ViewFunction = {
  RandomLevel_Group_Level_ScrollView_Level_Viewport_Content_Group_Level1_Btn_Level_Click = function(btn, str)
  end,
  RandomLevel_Group_Level_ScrollView_Level_Viewport_Content_Group_Level2_Btn_Level_Click = function(btn, str)
  end,
  RandomLevel_Group_Level_ScrollView_Level_Viewport_Content_Group_Level3_Btn_Level_Click = function(btn, str)
  end,
  RandomLevel_Group_Level_ScrollView_Level_Viewport_Content_Group_Level4_Btn_Level_Click = function(btn, str)
  end,
  RandomLevel_Group_Level_ScrollView_Level_Viewport_Content_Group_Level5_Btn_Level_Click = function(btn, str)
  end,
  RandomLevel_Group_Level_ScrollView_Level_Viewport_Content_Group_Level6_Btn_Level_Click = function(btn, str)
  end,
  RandomLevel_Group_Level_ScrollView_Level_Viewport_Content_Group_Level7_Btn_Level_Click = function(btn, str)
  end,
  RandomLevel_Group_Level_ScrollView_Level_Viewport_Content_Group_Level8_Btn_Level_Click = function(btn, str)
  end,
  RandomLevel_Group_LevelDetails_Btn_Fight_Click = function(btn, str)
    Controller:OnClickLevel()
  end,
  RandomLevel_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:OnClickReturn()
  end,
  RandomLevel_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  RandomLevel_Group_CommomBottomLeft_Btn_Rank_Click = function(btn, str)
  end,
  RandomLevel_Group_Team_Group_Item_Btn_Click_Click = function(btn, str)
  end,
  RandomLevel_Group_Team_StaticGrid_Team_SetGrid = function(element, elementIndex)
    Controller:SetRoleGrid(element, elementIndex)
  end,
  RandomLevel_Group_Team_StaticGrid_Team_Group_Item_Btn_Click_Click = function(btn, str)
    Controller:OnClickRole(str)
  end,
  RandomLevel_Group_Level_Group_Hp_StaticGrid_Hp_SetGrid = function(element, elementIndex)
    Controller:OnSetHPGrid(element, elementIndex)
  end,
  RandomLevel_Group_Team_Btn_Auto_Click = function(btn, str)
    Controller:OnClickBtnAuto()
  end,
  RandomLevel_Group_Level_Btn_GiveUp_Click = function(btn, str)
    Controller:OnBtnGiveUp()
  end
}
return ViewFunction
