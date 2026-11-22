local View = require("UIWorldBoss/UIWorldBossView")
local DataModel = require("UIWorldBoss/UIWorldBossDataModel")
local Controller = require("UIWorldBoss/UIWorldBossController")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  WorldBoss_Group_BossNormal_Btn_Detail_Click = function(btn, str)
  end,
  WorldBoss_Group_BossNormal_Btn_Boss_Click = function(btn, str)
  end,
  WorldBoss_StaticGrid_Normal_SetGrid = function(element, elementIndex)
    local data = DataModel.cfg.bossNormalList[elementIndex]
    Controller.SetBossItem(data, element)
  end,
  WorldBoss_StaticGrid_Normal_Group_BossNormal_Btn_Detail_Click = function(btn, str)
  end,
  WorldBoss_StaticGrid_Normal_Group_BossNormal_Btn_Boss_Click = function(btn, str)
    Controller.OnBossBtnClick(tonumber(str), View.Group_DetailNormal)
  end,
  WorldBoss_Group_BossFinal_Btn_Boss_Click = function(btn, str)
  end,
  WorldBoss_Group_BossFinal_Btn_Detail_Click = function(btn, str)
  end,
  WorldBoss_Group_BossFinal_Btn_Reward_Click = function(btn, str)
  end,
  WorldBoss_StaticGrid_Final_SetGrid = function(element, elementIndex)
    local data = DataModel.cfg.bossFinalList[elementIndex]
    Controller.SetBossItem(data, element)
  end,
  WorldBoss_StaticGrid_Final_Group_BossFinal_Btn_Boss_Click = function(btn, str)
    Controller.OnBossBtnClick(tonumber(str), View.Group_DetailFinal)
  end,
  WorldBoss_StaticGrid_Final_Group_BossFinal_Btn_Detail_Click = function(btn, str)
  end,
  WorldBoss_StaticGrid_Final_Group_BossFinal_Btn_Reward_Click = function(btn, str)
    Controller.GetReward(tonumber(str))
  end,
  WorldBoss_Group_DetailNormal_Btn_Close_Click = function(btn, str)
    View.Group_DetailNormal:SetActive(false)
    DataModel.curLevelList = nil
  end,
  WorldBoss_Group_DetailNormal_StaticGrid_Level_SetGrid = function(element, elementIndex)
    Controller.SetLevelItem(element, elementIndex)
  end,
  WorldBoss_Group_DetailNormal_StaticGrid_Level_Group_BtnLevel_Btn_Level_Click = function(btn, str)
    Controller.SelectLevelDiff(View.Group_DetailNormal, tonumber(str))
  end,
  WorldBoss_Group_DetailNormal_Group_BtnLevel_Btn_Level_Click = function(btn, str)
  end,
  WorldBoss_Group_DetailNormal_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local row = DataModel.ChooseRewardList[elementIndex]
    element.Group_Item.Btn_Item:SetClickParam(row.id)
    element.Group_First.self:SetActive(false)
    element.Group_Allready.self:SetActive(false)
    CommonItem:SetItem(element.Group_Item, row)
  end,
  WorldBoss_Group_DetailNormal_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(tonumber(str))
  end,
  WorldBoss_Group_DetailNormal_Btn_Fight_Click = function(btn, str)
    View.Group_DetailNormal:SetActive(false)
    Controller.TryStartBattle(tonumber(str))
  end,
  WorldBoss_Group_DetailFinal_Btn_Close_Click = function(btn, str)
    View.Group_DetailFinal:SetActive(false)
    DataModel.curLevelList = nil
  end,
  WorldBoss_Group_DetailFinal_StaticGrid_Level_SetGrid = function(element, elementIndex)
    Controller.SetLevelItem(element, elementIndex)
  end,
  WorldBoss_Group_DetailFinal_StaticGrid_Level_Group_BtnLevel_Btn_Level_Click = function(btn, str)
    Controller.SelectLevelDiff(View.Group_DetailFinal, tonumber(str))
  end,
  WorldBoss_Group_DetailFinal_Group_BtnLevel_Btn_Level_Click = function(btn, str)
  end,
  WorldBoss_Group_DetailFinal_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local row = DataModel.ChooseRewardList[elementIndex]
    element.Group_Item.Btn_Item:SetClickParam(row.id)
    element.Group_First.self:SetActive(false)
    element.Group_Allready.self:SetActive(false)
    CommonItem:SetItem(element.Group_Item, row)
  end,
  WorldBoss_Group_DetailFinal_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(tonumber(str))
  end,
  WorldBoss_Group_DetailFinal_Btn_Fight_Click = function(btn, str)
    View.Group_DetailFinal:SetActive(false)
    Controller.TryStartBattle(tonumber(str))
  end,
  WorldBoss_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if DataModel.isBattleReturn then
      UIManager:Open("UI/Activity/ActivityMain", Json.encode({
        id = DataModel.activityId,
        backToHome = true
      }))
    else
      UIManager:GoBack()
    end
  end,
  WorldBoss_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  WorldBoss_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  WorldBoss_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  WorldBoss_Btn_Reward_Click = function(btn, str)
    Net:SendProto("activity.get_boss_info", function(json)
      if json.world_bosses == nil or table.count(json.world_bosses) <= 0 then
        return
      end
      PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)] = json.activity
      PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)].world_bosses = json.world_bosses
      UIManager:Open("UI/Activity/ActivityWorldBoss/WorldBossReward", Json.encode({
        activityId = DataModel.activityId
      }))
    end, DataModel.activityId)
  end,
  WorldBoss_Group_DetailNormal_Btn_Return_Click = function(btn, str)
    View.Group_DetailNormal:SetActive(false)
  end,
  WorldBoss_Group_DetailFinal_Btn_Return_Click = function(btn, str)
    View.Group_DetailFinal:SetActive(false)
  end,
  WorldBoss_StaticGrid_Normal_Group_BossNormal_Btn_Plot_Click = function(btn, str)
    Controller.PlayBossPlot(tonumber(str))
  end,
  WorldBoss_StaticGrid_Final_Group_BossFinal_Btn_Plot_Click = function(btn, str)
    Controller.PlayBossPlot(tonumber(str))
  end,
  WorldBoss_StaticGrid_Normal_Group_BossNormal_Btn_MiniGame_Click = function(btn, str)
    Controller.OpenBossMiniGame(tonumber(str))
  end,
  WorldBoss_StaticGrid_Final_Group_BossFinal_Btn_MiniGame_Click = function(btn, str)
    Controller.OpenBossMiniGame(tonumber(str))
  end
}
return ViewFunction
