local View = require("UITeam_CubeNew/UITeam_CubeNewView")
local DataModel = require("UITeam_CubeNew/UITeam_CubeNewDataModel")
local Controller = require("UITeam_CubeNew/UITeam_CubeNewController")
local ViewFunction = {
  Team_CubeNew_Btn_Battle_Click = function(btn, str)
    Controller:OnBtnBattle()
  end,
  Team_CubeNew_Btn_Back_Click = function(btn, str)
    Controller:OnClickReturn()
  end,
  Team_CubeNew_Btn_Descent_Click = function(btn, str)
    Controller:SaveCubeDeck()
    UIManager:Open("UI/CubeRogue/Descent/Descent", Json.encode({
      cubeId = PlayerData.TempCache.RogueCache.cubeId
    }))
  end,
  Team_CubeNew_Group_Select_Group_Check_Btn_Role_Click = function(btn, str)
    Controller:SetSelectMode(1)
  end,
  Team_CubeNew_Group_Select_Group_Check_Btn_Team_Click = function(btn, str)
    Controller:SetSelectMode(2)
  end,
  Team_CubeNew_Group_Select_Group_RoleList_ScrollGrid_RoleList_SetGrid = function(element, elementIndex)
    Controller:OnSetRoleGrid(element, elementIndex)
  end,
  Team_CubeNew_Group_Select_Group_RoleList_ScrollGrid_RoleList_Group_RoleFace_Btn_Click_Click = function(btn, str)
    Controller:OnClickRoleBtn(str)
  end,
  Team_CubeNew_Group_Select_Group_RoleList_Btn_Level_Click = function(btn, str)
    Controller:SetRoleSortType(1)
  end,
  Team_CubeNew_Group_Select_Group_RoleList_Btn_Rarity_Click = function(btn, str)
    Controller:SetRoleSortType(2)
  end,
  Team_CubeNew_Group_Select_Group_RoleList_Btn_Time_Click = function(btn, str)
    Controller:SetRoleSortType(3)
  end,
  Team_CubeNew_Group_Select_Group_RoleList_Btn_Screen_Click = function(btn, str)
    Controller:OpenRoleFilter()
  end,
  Team_CubeNew_Group_Select_ScrollGrid_TeamList_SetGrid = function(element, elementIndex)
    Controller:OnSetTeamGrid(element, elementIndex)
  end,
  Team_CubeNew_Group_Select_ScrollGrid_TeamList_Group_Team_Group_RoleList_StaticGrid_Role_SetGrid = function(element, elementIndex)
    Controller:OnSetTeamRoleGrid(element, elementIndex)
  end,
  Team_CubeNew_Group_Select_ScrollGrid_TeamList_Group_Team_Btn_Click_Click = function(btn, str)
    Controller:OnClickTeamBtn(str)
  end,
  Team_CubeNew_Group_Level_Group_Enemy_ScrollView_Info_Viewport_Content_Group_Boss_StaticGrid_Boss_SetGrid = function(element, elementIndex)
    Controller:OnSetBossGrid(element, elementIndex)
  end,
  Team_CubeNew_Group_Level_Group_Enemy_ScrollView_Info_Viewport_Content_Group_Boss_StaticGrid_Boss_Group_EnemyBoss_Btn_Click_Click = function(btn, str)
    Controller:SaveCubeDeck()
    UIManager:Open("UI/Book/Enemy_Illustration/Enemy_SkillDetail", Json.encode({
      enemyId = tonumber(str)
    }))
  end,
  Team_CubeNew_Group_Level_Group_Enemy_ScrollView_Info_Viewport_Content_Group_Random_StaticGrid_Random_SetGrid = function(element, elementIndex)
    Controller:OnSetRandomGrid(element, elementIndex)
  end,
  Team_CubeNew_Group_Level_Group_Enemy_ScrollView_Info_Viewport_Content_Group_Random_StaticGrid_Random_Group_EnemyRandom_Btn_Click_Click = function(btn, str)
    Controller:SaveCubeDeck()
    UIManager:Open("UI/Book/Enemy_Illustration/Enemy_SkillDetail", Json.encode({
      enemyId = tonumber(str)
    }))
  end,
  Team_CubeNew_Group_Level_Group_Team_StaticGrid_Team_SetGrid = function(element, elementIndex)
    Controller:OnSetLevelRoleGrid(element, elementIndex)
  end,
  Team_CubeNew_Group_Level_Group_Team_StaticGrid_Team_Group_Role_Btn_Click_Click = function(btn, str)
    Controller:OnClickLevelRole(str)
  end,
  Team_CubeNew_Group_Level_Group_Team_StaticGrid_Team_Group_Role_Btn_Click_LongPress = function(btn, str)
    Controller:BeginDrag(1, tonumber(str))
  end,
  Team_CubeNew_Group_Level_Group_Btn_Btn_Clear_Click = function(btn, str)
    Controller:OnClickLevelBtn()
  end,
  Team_CubeNew_Group_Level_Group_Btn_Btn_Setting_Click = function(btn, str)
    Controller:OnClickBtnAuto()
  end,
  Team_CubeNew_Screen_Chapter_New_Btn_BG_Click = function(btn, str)
    Controller:ExitRoleFilter(false)
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Group_Btn_All_Click = function(btn, str)
    Controller:OnClickBtnAll("Group_Group")
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Group_Btn_C01_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Group_Btn_C02_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Group_Btn_C03_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Group_Btn_C04_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Group_Btn_C05_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Group_Btn_C06_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Group_Btn_C07_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Group_Btn_C08_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Group_Btn_C09_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Group", tonumber(str))
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Rarity_Btn_All_Click = function(btn, str)
    Controller:OnClickBtnAll("Group_Rarity")
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Rarity_Btn_G01_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Rarity", tonumber(str))
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Rarity_Btn_G02_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Rarity", tonumber(str))
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Rarity_Btn_G03_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Rarity", tonumber(str))
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Rarity_Btn_G04_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Rarity", tonumber(str))
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Rarity_Btn_G05_Click = function(btn, str)
    Controller:AddFilterMap(btn, "Group_Rarity", tonumber(str))
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Tag_Btn_All_Click = function(btn, str)
    Controller:SetSpecialTagType("All")
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Tag_Btn_Occupation_Click = function(btn, str)
    Controller:SetSpecialTagType("Occupation")
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Tag_Btn_Hit_Click = function(btn, str)
    Controller:SetSpecialTagType("Hit")
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Tag_Btn_Technology_Click = function(btn, str)
    Controller:SetSpecialTagType("Technology")
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Tag_Img_Bg_ScrollGrid_Tag_SetGrid = function(element, elementIndex)
    Controller:OnSetSpecialTagGrid(element, elementIndex)
  end,
  Team_CubeNew_Screen_Chapter_New_Group_Tag_Img_Bg_ScrollGrid_Tag_Group_Item_Btn_Tag_Click = function(btn, str)
    Controller:AddTagFilterMap(str)
  end,
  Team_CubeNew_Screen_Chapter_New_Btn_OK_Click = function(btn, str)
    Controller:ExitRoleFilter(true)
  end,
  Team_CubeNew_Screen_Chapter_New_Btn_Cancel_Click = function(btn, str)
    Controller:ExitRoleFilter(false)
  end,
  Team_CubeNew_Group_Level_Group_Team_ScrollGrid_Team_SetGrid = function(element, elementIndex)
    Controller:OnSetLevelRoleGrid(element, elementIndex)
  end,
  Team_CubeNew_Group_Level_Group_Team_ScrollGrid_Team_Group_Role_Btn_Click_Click = function(btn, str)
    Controller:OnClickLevelRole(str)
  end,
  Team_CubeNew_Group_Level_Group_Team_ScrollGrid_Team_Group_Role_Btn_Click_LongPress = function(btn, str)
    local roleIndex = tonumber(str)
    local roleId = tostring(DataModel.levelRoleList[roleIndex])
    local data = {
      currentRoleId = roleId,
      fromView = EnumDefine.CommonFilterType.SquadView
    }
    Controller:SaveCubeDeck()
    Net:SendProto("hero.info", function(json)
      if json.roles then
        PlayerData.ServerData.roles[roleId] = json.roles[roleId]
        UIManager:Open("UI/CharacterInfo/CharacterInfo", Json.encode(data))
      end
    end, tonumber(roleId))
  end,
  Team_CubeNew_Group_RoleTemp_Btn_Click_Click = function(btn, str)
  end,
  Team_CubeNew_Group_RoleTemp_Btn_Click_LongPress = function(btn, str)
  end
}
return ViewFunction
