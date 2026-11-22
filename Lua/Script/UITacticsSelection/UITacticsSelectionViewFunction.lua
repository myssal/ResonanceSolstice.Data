local View = require("UITacticsSelection/UITacticsSelectionView")
local DataModel = require("UITacticsSelection/UITacticsSelectionDataModel")
local Controller = require("UITacticsSelection/UITacticsSelectionController")
local ViewFunction = {
  TacticsSelection_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:OnBtnReturn()
  end,
  TacticsSelection_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  TacticsSelection_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  TacticsSelection_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  TacticsSelection_ScrollGrid_List_Group_Item_Btn_Choose_Click = function(btn, str)
    Controller:OnClickBtnChoose(str)
  end,
  TacticsSelection_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller:OnSetTeamGrid(element, elementIndex)
  end,
  TacticsSelection_Group_Info_Group_Detail_Btn_Confirm_Click = function(btn, str)
    Controller:OpenSquads()
  end,
  TacticsSelection_Group_Info_Group_Detail_Group_Combo_ScrollGrid_Buff_SetGrid = function(element, elementIndex)
    Controller:OnSetExtraSkillGrid(element, elementIndex)
  end,
  TacticsSelection_Group_Info_Group_Detail_Group_Combo_ScrollGrid_Buff_Viewport_Grid_Btn_Buff_000_Click = function(btn, str)
  end,
  TacticsSelection_Group_Info_Group_Detail_Group_Combo_ScrollGrid_Buff_Viewport_Grid_Btn_Buff_001_Click = function(btn, str)
  end,
  TacticsSelection_Group_Info_Group_Detail_Group_Combo_ScrollGrid_Buff_Viewport_Grid_Btn_Buff_002_Click = function(btn, str)
  end,
  TacticsSelection_Group_Info_Group_Detail_Group_Combo_ScrollGrid_Buff_Viewport_Grid_Btn_Buff_003_Click = function(btn, str)
  end,
  TacticsSelection_Group_Info_Group_Detail_Group_Combo_ScrollGrid_Buff_Viewport_Grid_Btn_Buff_004_Click = function(btn, str)
  end,
  TacticsSelection_Group_Info_Btn_Left_Click = function(btn, str)
  end,
  TacticsSelection_Group_Info_Btn_Right_Click = function(btn, str)
  end,
  TacticsSelection_Group_Item_Btn_Choose_Click = function(btn, str)
  end,
  TacticsSelection_StaticGrid_List_SetGrid = function(element, elementIndex)
    Controller:OnSetTeamGrid(element, elementIndex)
  end,
  TacticsSelection_StaticGrid_List_Group_Item_Btn_Choose_Click = function(btn, str)
    Controller:OnClickBtnChoose(str)
  end
}
return ViewFunction
