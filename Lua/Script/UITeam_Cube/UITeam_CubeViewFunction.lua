local View = require("UITeam_Cube/UITeam_CubeView")
local DataModel = require("UITeam_Cube/UITeam_CubeDataModel")
local Controller = require("UITeam_Cube/UITeam_CubeController")
local ViewFunction = {
  Team_Cube_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:OnClickReturn()
  end,
  Team_Cube_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    Controller:OnClickHome()
  end,
  Team_Cube_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Team_Cube_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Team_Cube_Group_Level_Group_Role_Btn_Click_Click = function(btn, str)
  end,
  Team_Cube_Group_Level_Group_Role_Btn_Click_LongPress = function(btn, str)
  end,
  Team_Cube_Group_Level_Group_Level_Btn_Select_Click = function(btn, str)
  end,
  Team_Cube_Group_Level_Group_Level_Btn_Detail_Click = function(btn, str)
    UIManager:Open("UI/Book/Enemy_Illustration/Enemy_SkillDetail", Json.encode({
      levelId = tonumber(str)
    }))
  end,
  Team_Cube_Group_Level_Group_Level_Btn_Auto_Click = function(btn, str)
    Controller:OnClickBtnAuto()
  end,
  Team_Cube_Group_Level_Group_Level_StaticGrid_RoleList_SetGrid = function(element, elementIndex)
    Controller:OnSetLevelRoleGrid(element, elementIndex)
  end,
  Team_Cube_Group_Level_Group_Level_StaticGrid_RoleList_Group_Role_Btn_Click_Click = function(btn, str)
    Controller:OnClickLevelRole(str)
  end,
  Team_Cube_Group_Level_Group_Level_StaticGrid_RoleList_Group_Role_Btn_Click_LongPress = function(btn, str)
    Controller:BeginDrag(1, tonumber(str))
  end,
  Team_Cube_Group_Level_Btn_Clear_Click = function(btn, str)
    Controller:OnClickLevelBtn()
  end,
  Team_Cube_Group_Select_Group_Check_Btn_Role_Click = function(btn, str)
    Controller:SetSelectMode(1)
  end,
  Team_Cube_Group_Select_Group_Check_Btn_Team_Click = function(btn, str)
    Controller:SetSelectMode(2)
  end,
  Team_Cube_Group_Select_Group_RoleList_ScrollGrid_RoleList_SetGrid = function(element, elementIndex)
    Controller:OnSetRoleGrid(element, elementIndex)
  end,
  Team_Cube_Group_Select_Group_RoleList_ScrollGrid_RoleList_Group_Item_Btn_Click_Click = function(btn, str)
    Controller:OnClickRoleBtn(str)
  end,
  Team_Cube_Group_Select_Group_RoleList_Btn_Level_Click = function(btn, str)
    Controller:SetRoleSortType(1)
  end,
  Team_Cube_Group_Select_Group_RoleList_Btn_Rarity_Click = function(btn, str)
    Controller:SetRoleSortType(2)
  end,
  Team_Cube_Group_Select_Group_RoleList_Btn_Time_Click = function(btn, str)
    Controller:SetRoleSortType(3)
  end,
  Team_Cube_Group_Select_Group_RoleList_Btn_Screen_Click = function(btn, str)
    Controller:OpenRoleFilter()
  end,
  Team_Cube_Group_Select_Group_TeamList_ScrollGrid_TeamList_SetGrid = function(element, elementIndex)
    Controller:OnSetTeamGrid(element, elementIndex)
  end,
  Team_Cube_Group_Select_Group_TeamList_ScrollGrid_TeamList_Group_Team_StaticGrid_Role_SetGrid = function(element, elementIndex)
    Controller:OnSetTeamRoleGrid(element, elementIndex)
  end,
  Team_Cube_Group_Select_Group_TeamList_ScrollGrid_TeamList_Group_Team_Btn_Click_Click = function(btn, str)
    Controller:OnClickTeamBtn(str)
  end,
  Team_Cube_Group_Select_Group_Team_StaticGrid_Role_SetGrid = function(element, elementIndex)
  end,
  Team_Cube_Group_Select_Group_Team_Btn_Click_Click = function(btn, str)
  end,
  Team_Cube_Group_Select_Group_Item_Btn_Click_Click = function(btn, str)
  end,
  Team_Cube_Group_Select_Btn_Back_Click = function(btn, str)
  end,
  Team_Cube_Btn_Battle_Click = function(btn, str)
    Controller:OnBtnBattle()
  end,
  Team_Cube_Screen_Chapter_Btn_BG_Click = function(btn, str)
  end,
  Team_Cube_Screen_Chapter_Group_Career_Btn_All_Click = function(btn, str)
    Controller:OnClickBtnAll("Group_Career")
  end,
  Team_Cube_Screen_Chapter_Group_Career_Btn_C01_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Career", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Career_Btn_C02_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Career", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Career_Btn_C03_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Career", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Career_Btn_C04_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Career", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Career_Btn_C05_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Career", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Career_Btn_C06_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Career", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Career_Btn_C07_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Career", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Career_Btn_C08_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Career", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Career_Btn_C09_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Career", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Group_Btn_All_Click = function(btn, str)
    Controller:OnClickBtnAll("Group_Group")
  end,
  Team_Cube_Screen_Chapter_Group_Group_Btn_G01_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Group_Btn_G02_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Group_Btn_G03_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Group_Btn_G04_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Group_Btn_G05_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Group_Btn_G06_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Group_Btn_G07_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Group_Btn_G08_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Group_Btn_G09_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Rarity_Btn_All_Click = function(btn, str)
    Controller:OnClickBtnAll("Group_Rarity")
  end,
  Team_Cube_Screen_Chapter_Group_Rarity_Btn_R01_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Rarity", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Rarity_Btn_R02_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Rarity", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Rarity_Btn_R03_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Rarity", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Group_Rarity_Btn_R04_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Rarity", tonumber(str))
  end,
  Team_Cube_Screen_Chapter_Btn_OK_Click = function(btn, str)
    Controller:ExitRoleFilter(true)
  end,
  Team_Cube_Screen_Chapter_Btn_Cancel_Click = function(btn, str)
    Controller:ExitRoleFilter(false)
  end
}
return ViewFunction
