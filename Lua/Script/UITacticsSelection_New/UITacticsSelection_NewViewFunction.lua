local View = require("UITacticsSelection_New/UITacticsSelection_NewView")
local DataModel = require("UITacticsSelection_New/UITacticsSelection_NewDataModel")
local Controller = require("UITacticsSelection_New/UITacticsSelection_NewController")
local ViewFunction = {
  TacticsSelection_New_Btn_Back_Click = function(btn, str)
    Controller:OnBtnReturn()
  end,
  TacticsSelection_New_Group_Selection_StaticGrid_Tactics_SetGrid = function(element, elementIndex)
    Controller:OnSetTeamGrid(element, elementIndex)
  end,
  TacticsSelection_New_Group_Selection_StaticGrid_Tactics_Group_Tactics_Btn_Click_Click = function(btn, str)
    Controller:OnChooseTactics(str)
  end,
  TacticsSelection_New_Group_Info_Group_ExtraBuff_Group_Buff_Img_BG_StaticGrid_ExtraBuff_SetGrid = function(element, elementIndex)
  end,
  TacticsSelection_New_Group_Info_Group_ExtraBuff_Group_Buff_Img_BG_StaticGrid_ExtraBuff_Group_ExtraBuff_Btn_Click_Click = function(btn, str)
  end,
  TacticsSelection_New_Group_Info_Btn_Confirm_Click = function(btn, str)
    Controller:OpenSquads()
  end,
  TacticsSelection_New_Group_Info_Group_ExtraBuff_Group_Buff_Img_BG_ScrollGrid_ExtraBuff_SetGrid = function(element, elementIndex)
    Controller:OnSetExtraSkillGrid(element, elementIndex)
  end,
  TacticsSelection_New_Group_Info_Group_ExtraBuff_Group_Buff_Img_BG_ScrollGrid_ExtraBuff_Viewport_Grid_Btn_ExtraBuff_000_Click = function(btn, str)
    Controller:RefreshExtraBuffPreposition(1)
  end,
  TacticsSelection_New_Group_Info_Group_ExtraBuff_Group_Buff_Img_BG_ScrollGrid_ExtraBuff_Viewport_Grid_Btn_ExtraBuff_001_Click = function(btn, str)
    Controller:RefreshExtraBuffPreposition(2)
  end,
  TacticsSelection_New_Group_Info_Group_ExtraBuff_Group_Buff_Img_BG_ScrollGrid_ExtraBuff_Viewport_Grid_Btn_ExtraBuff_002_Click = function(btn, str)
    Controller:RefreshExtraBuffPreposition(3)
  end,
  TacticsSelection_New_Group_Info_Group_ExtraBuff_Group_Buff_Img_BG_ScrollGrid_ExtraBuff_Viewport_Grid_Btn_ExtraBuff_003_Click = function(btn, str)
    Controller:RefreshExtraBuffPreposition(4)
  end,
  TacticsSelection_New_Group_Info_Group_ExtraBuff_Group_Buff_Img_BG_ScrollGrid_ExtraBuff_Viewport_Grid_Btn_ExtraBuff_004_Click = function(btn, str)
    Controller:RefreshExtraBuffPreposition(5)
  end,
  TacticsSelection_New_Group_Info_Group_ExtraBuff_Group_Buff_Img_BG_ScrollGrid_ExtraBuff_Viewport_Grid_Btn_ExtraBuff_005_Click = function(btn, str)
    Controller:RefreshExtraBuffPreposition(6)
  end,
  TacticsSelection_New_Group_Info_Group_ExtraBuff_Group_Buff_Img_BG_ScrollGrid_ExtraBuff_Btn_ExtraBuff_Btn_Click_Click = function(btn, str)
    UIManager:Open("UI/CubeRogue/TacticsSelection/BuffInfo", Json.encode({id = str}))
  end,
  TacticsSelection_New_Group_Info_Group_Buff_StaticGrid_Buff_SetGrid = function(element, elementIndex)
    Controller:OnSetInitSkillGrid(element, elementIndex)
  end
}
return ViewFunction
