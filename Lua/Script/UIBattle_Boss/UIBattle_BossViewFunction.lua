local View = require("UIBattle_Boss/UIBattle_BossView")
local DataModel = require("UIBattle_Boss/UIBattle_BossDataModel")
local Controller = require("UIBattle_Boss/UIBattle_BossController")
local ViewFunction = {
  Battle_Boss_Group_Right_Group_Drop_ScrollGrid_Item_SetGrid = function(element, elementIndex)
    Controller:RefreshReward(element, elementIndex)
  end,
  Battle_Boss_Group_Right_Group_Drop_ScrollGrid_Item_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  Battle_Boss_Group_Right_Btn_Energy_Click = function(btn, str)
    UIManager:Open("UI/Energy/Energy")
  end,
  Battle_Boss_Group_Right_Btn_Energy_Btn_Add_Click = function(btn, str)
  end,
  Battle_Boss_Group_Right_Group_Fight_Btn_StartFight_Click = function(btn, str)
    Controller:ClickBattle()
  end,
  Battle_Boss_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if View.Group_Right.self.IsActive then
      View.Group_Right.self:SetActive(false)
      if DataModel.curPeriodId ~= nil then
        View.Btn_Abyss.self:SetActive(true)
      end
      View.ScrollView_Select.Viewport.Content.Group_Select.Btn_Return:SetActive(false)
      View.Group_Best.self:SetActive(false)
      Controller:CloseChooseImgSelect()
      DataModel.SelectIndex = nil
      View.Group_CommomBottomLeft:SetActive(true)
      return
    end
    if DataModel.IsCityMapIn and DataModel.CallBackParms ~= nil then
      Controller:CloseChooseImgSelect()
      local parms = {}
      local info = DataModel.CallBackParms
      parms.stationId = DataModel.StationId
      parms.buildingId = info.buildingId
      parms.npcId = info.npcId
      parms.bgPath = info.bgPath
      parms.bgColor = info.bgColor
      parms.isBossBattle = true
      UIManager:Open("UI/HomeInvest/HomeInvest", Json.encode(parms))
      return
    end
    UIManager:GoBack()
  end,
  Battle_Boss_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    if View.Group_Right.self.IsActive then
      View.Group_Right.self:SetActive(false)
      View.ScrollView_Select.Viewport.Content.Group_Select.Btn_Return:SetActive(false)
      View.Group_Best.self:SetActive(false)
      Controller:CloseChooseImgSelect()
      DataModel.SelectIndex = nil
    end
    UIManager:GoHome()
  end,
  Battle_Boss_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Battle_Boss_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Battle_Boss_Group_Best_Btn_Check_Click = function(btn, str)
    Controller:ClickBestBtn(str)
  end,
  Battle_Boss_Group_Best_Btn_Reward_Click = function(btn, str)
    Controller:OpenTimeRewardPage(str)
  end,
  Battle_Boss_Group_TimeReward_ScrollGrid_Level_SetGrid = function(element, elementIndex)
    Controller:SetRewradParentGrid(element, elementIndex)
  end,
  Battle_Boss_Group_TimeReward_ScrollGrid_Level_Group_Item_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetRewradGrid(element, elementIndex)
  end,
  Battle_Boss_Group_TimeReward_ScrollGrid_Level_Group_Item_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  Battle_Boss_ScrollView_Select_Viewport_Content_Group_Select_Group_Level_StaticGrid_Level_SetGrid = function(element, elementIndex)
    DataModel:SetData(element, tonumber(elementIndex))
  end,
  Battle_Boss_ScrollView_Select_Viewport_Content_Group_Select_Btn_Return_Click = function(btn, str)
    if View.Group_Right.self.IsActive then
      View.Group_Right.self:SetActive(false)
      if DataModel.curPeriodId ~= nil then
        View.Btn_Abyss.self:SetActive(true)
      end
      View.ScrollView_Select.Viewport.Content.Group_Select.Btn_Return:SetActive(false)
      View.Group_Best.self:SetActive(false)
      Controller:CloseChooseImgSelect()
      DataModel.SelectIndex = nil
      View.Group_CommomBottomLeft:SetActive(true)
    end
  end,
  Battle_Boss_Group_TimeReward_Btn_Close_Click = function(btn, str)
    View.Group_TimeReward.self:SetActive(false)
  end,
  Battle_Boss_Group_TimeReward_ScrollGrid_Level_Group_Item_Group_Can_Btn_Click_Click = function(btn, str)
    Controller:ClickClaimBtn(str)
  end,
  Battle_Boss_Group_Right_Group_Title_Btn_Mechanism_Click = function(btn, str)
    Controller:BuffListSwitch(true)
  end,
  Battle_Boss_Group_BuffList_Btn_Close_Click = function(btn, str)
    Controller:BuffListSwitch(false)
  end,
  Battle_Boss_Group_CommomBottomLeft_Btn_Rank_Click = function(btn, str)
    local rankCA = PlayerData:GetFactoryData(84300005, "RankFactory")
    local rankType = rankCA.rankType
    local timeType = rankCA.timeType
    local BattleRankListDataModel = require("UIBattleRankList/UIBattleRankListDataModel")
    local minLv, maxLv = BattleRankListDataModel.GetCurLevelTween()
    local levelTween = ""
    if minLv and maxLv then
      levelTween = minLv .. "-" .. maxLv
    end
    Net:SendProto("main.rank", function(json)
      if json.rank_list and json.my_rank then
        UIManager:Open("UI/RankList/BattleRankList", Json.encode({
          stationId = DataModel.StationId,
          selfRank = json.my_rank,
          rankList = json.rank_list
        }))
      end
    end, rankType, timeType, levelTween, DataModel.StationId, rankCA.peopleNum)
  end,
  Battle_Boss_ScrollView_Select_Viewport_Content_Group_Select_Btn_Abyss_Click = function(btn, str)
    Controller:TryOpenAbyssPanel()
  end,
  Battle_Boss_Btn_Abyss_Click = function(btn, str)
    Controller:TryOpenAbyssPanel()
  end,
  Battle_Boss_ScrollView_Select_Viewport_Content_Group_Select_Group_Level_Group_Level_Group_On_Btn_Select_Click = function(btn, str)
  end,
  Battle_Boss_ScrollView_Select_Viewport_Content_Group_Select_Group_Level_StaticGrid_Level_Group_Level_Group_On_Btn_Select_Click = function(btn, str)
    Controller:ClickLevelBtn(tonumber(str))
  end,
  Battle_Boss_ScrollView_Select_Viewport_Content_Group_Select_Group_Level_Group_Level_Btn_Select_Click = function(btn, str)
  end,
  Battle_Boss_ScrollView_Select_Viewport_Content_Group_Select_Group_Level_StaticGrid_Level_Group_Level_Btn_Select_Click = function(btn, str)
    Controller:ClickLevelBtn(tonumber(str))
  end
}
return ViewFunction
