local View = require("UIActivityWorldBoss/UIActivityWorldBossView")
local DataModel = require("UIActivityWorldBoss/UIActivityWorldBossDataModel")
local Controller = require("UIActivityWorldBoss/UIActivityWorldBossController")
local CommonBtn = require("Common/BtnItem")
local ViewFunction = {
  ActivityWorldBoss_Group_Main_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local data = DataModel.cfg.rewardPreviewList[elementIndex]
    CommonBtn:SetActivityPreviewItem(element.Group_Item, data)
    element.Group_Item.Btn_Item:SetClickParam(data.id)
  end,
  ActivityWorldBoss_Group_Main_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(tonumber(str))
  end,
  ActivityWorldBoss_Group_Main_Btn_Start_Click = function(btn, str)
    local playerLv = PlayerData:GetUserInfo().lv or 1
    if playerLv < DataModel.cfg.openLv then
      return
    end
    Net:SendProto("activity.get_boss_info", function(json)
      if json.world_bosses == nil or table.count(json.world_bosses) <= 0 then
        return
      end
      PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)] = json.activity
      PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)].world_bosses = json.world_bosses
      UIManager:Open("UI/Activity/ActivityWorldBoss/WorldBoss", Json.encode({
        activityId = DataModel.activityId
      }))
    end, DataModel.activityId, function()
    end)
  end,
  ActivityWorldBoss_Group_Cost_Btn_BG_Click = function(btn, str)
  end,
  ActivityWorldBoss_Group_Cost_Group_Middle_ScrollGrid_Dikuang_SetGrid = function(element, elementIndex)
  end,
  ActivityWorldBoss_Group_Cost_Group_Middle_ScrollGrid_Dikuang_Group_Item_Img_Dikuang_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  ActivityWorldBoss_Group_Cost_Btn_Confirm_Click = function(btn, str)
  end,
  ActivityWorldBoss_Group_Cost_Btn_Cancel_Click = function(btn, str)
  end,
  ActivityWorldBoss_Group_Main_Btn_Rank_Click = function(btn, str)
    UIManager:Open("UI/RankList/WorldBossRankList", Json.encode({
      activityId = DataModel.activityId
    }))
  end,
  ActivityWorldBoss_Group_Main_Btn_Reward_Click = function(btn, str)
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
  end
}
return ViewFunction
