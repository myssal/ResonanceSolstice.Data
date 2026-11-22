local View = require("UIWorldBossRankList/UIWorldBossRankListView")
local DataModel = require("UIWorldBossRankList/UIWorldBossRankListDataModel")
local Controller = require("UIWorldBossRankList/UIWorldBossRankListController")
local ViewFunction = {
  WorldBossRankList_Btn_BG_Click = function(btn, str)
    UIManager:GoBack()
  end,
  WorldBossRankList_Group_Tab_ScrollGrid_Tab_SetGrid = function(element, elementIndex)
    Controller:SetBossElement(element, elementIndex)
  end,
  WorldBossRankList_Group_Tab_ScrollGrid_Tab_Group_Item_Btn__Click = function(btn, str)
    Controller:SetTab(tonumber(str))
  end,
  WorldBossRankList_Group_Rank_Group_List_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller:SetRankElement(element, elementIndex)
  end,
  WorldBossRankList_Group_Rank_Group_List_ScrollGrid_List_Group_Item_Btn_ProfilePhoto_Click = function(btn, str)
    Controller:OpenFriends(str)
  end,
  WorldBossRankList_Group_Rank_Group_List_Group_Oneself_Btn_ProfilePhoto_Click = function(btn, str)
    Controller:OpenFriends(str)
  end,
  WorldBossRankList_Group_Reward_Group_Reward_StaticGrid_Reward_SetGrid = function(element, elementIndex)
    local rankId = DataModel.rankList[DataModel.curTab]
    if rankId == nil then
      return
    end
    local bossData = PlayerData:GetFactoryData(rankId)
    local reward = bossData.rankRewardList[elementIndex]
    local rewardListCfg = PlayerData:GetFactoryData(reward.id)
    local rewardCfg = PlayerData:GetFactoryData(rewardListCfg.rewardList[1].id)
    element.Img_Item:SetSprite(rewardCfg.tipsPath)
    if rewardCfg.mod ~= nil and rewardCfg.mod ~= "\229\159\186\231\161\128\229\164\180\229\131\143" then
      element.Txt_Num:SetText(rewardListCfg.rewardList[1].num)
    else
      element.Txt_Num:SetText("")
    end
    element.Btn_Item:SetClickParam(rewardListCfg.rewardList[1].id)
  end,
  WorldBossRankList_Group_Reward_Group_Reward_StaticGrid_Reward_Group_Reward_Btn_Item_Click = function(btn, str)
    CommonTips.OpenRewardDetail(tonumber(str))
  end
}
return ViewFunction
