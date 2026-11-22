local View = require("UIWorldBossReward/UIWorldBossRewardView")
local DataModel = require("UIWorldBossReward/UIWorldBossRewardDataModel")
local Controller = require("UIWorldBossReward/UIWorldBossRewardController")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  WorldBossReward_Group_RewardList_ScrollGrid_Level_SetGrid = function(element, elementIndex)
    local data = DataModel.rewardList[elementIndex]
    local netData = PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)]
    local curRewardCfg = PlayerData:GetFactoryData(data.id)
    element.ScrollGrid_Reward.grid.self:SetParentParam(elementIndex)
    element.ScrollGrid_Reward.grid.self:SetDataCount(#curRewardCfg.rewardList)
    element.ScrollGrid_Reward.grid.self:RefreshAllElement()
    element.Group_Btn.Btn_On:SetClickParam(data.index)
    local alreadyBeat = math.min(DataModel.curBossBeatTimes, data.bossBattleTimes)
    element.Group_Btn.Btn_On.Txt_Times:SetText(string.format(GetText(80611510), alreadyBeat, data.bossBattleTimes))
    element.Group_Btn.Btn_On.Txt_HpR:SetText(string.format(GetText(80611415), data.ratio * 100))
    element.Group_Btn.Img_Off.Txt_Times:SetText(string.format(GetText(80611510), alreadyBeat, data.bossBattleTimes))
    element.Group_Btn.Img_Off.Txt_HpR:SetText(string.format(GetText(80611415), data.ratio * 100))
    element.Group_Btn.Img_Got.Txt_Times:SetText(string.format(GetText(80611510), alreadyBeat, data.bossBattleTimes))
    element.Group_Btn.Img_Got.Txt_HpR:SetText(string.format(GetText(80611415), data.ratio * 100))
    local canRecv = DataModel.curBossHpPercent <= data.ratio and alreadyBeat >= data.bossBattleTimes
    local hasRecv = data.recv
    element.Group_Btn.Btn_On:SetActive(canRecv and not hasRecv)
    element.Group_Btn.Img_Off:SetActive(not canRecv)
    element.Group_Btn.Img_Got:SetActive(hasRecv)
    element.Img_Mask:SetActive(hasRecv)
  end,
  WorldBossReward_Group_RewardList_ScrollGrid_Level_Group_Item_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local parentData = DataModel.rewardList[tonumber(element.ParentParam)]
    local curRewardCfg = PlayerData:GetFactoryData(parentData.id)
    local data = curRewardCfg.rewardList[elementIndex]
    CommonItem:SetItem(element.Group_Item, {
      id = data.id,
      num = data.num
    })
    element.Group_Item.Btn_Item:SetClickParam(data.id)
  end,
  WorldBossReward_Group_RewardList_ScrollGrid_Level_Group_Item_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(tonumber(str))
  end,
  WorldBossReward_Group_RewardList_ScrollGrid_Level_Group_Item_Group_Btn_Btn_On_Click = function(btn, str)
    Net:SendProto("activity.recv_boss", function(json)
      if json.reward then
        CommonTips.OpenShowItem(json.reward)
      end
      table.insert(PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)].boss[tostring(DataModel.curBossId)].received, tonumber(str) - 1)
      Controller.ShowPanel(DataModel.curSelect)
      if UIManager:IsPanelOpened("UI/ActivityWorldBoss/ActivityWorldBoss") then
        require("UIActivityWorldBoss/UIActivityWorldBossController").RefreshRedDot()
      end
      if UIManager:IsPanelOpened("UI/ActivityWorldBoss/WorldBoss") then
        require("UIWorldBoss/UIWorldBossController").RefreshRedDot()
      end
    end, DataModel.activityId, DataModel.curBossId, tonumber(str) - 1)
  end,
  WorldBossReward_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  WorldBossReward_Group_BossList_Group_Boss_Btn_Boss_Click = function(btn, str)
  end,
  WorldBossReward_Group_BossList_StaticGrid_Boss_SetGrid = function(element, elementIndex)
    element.Btn_Boss.Group_On:SetActive(elementIndex == DataModel.curSelect)
    element.Btn_Boss.Group_Off:SetActive(elementIndex ~= DataModel.curSelect)
    if DataModel.onlyRefreshSelect then
      return
    end
    local netData = PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)]
    local data = DataModel.list[elementIndex]
    local cfg = PlayerData:GetFactoryData(data.id)
    local curBossHpPercent = netData.world_bosses[tostring(data.id)].hp / cfg.bossHp
    element.Btn_Boss:SetClickParam(elementIndex)
    element.Btn_Boss.Group_On.Txt_Name:SetText(cfg.name)
    element.Btn_Boss.Group_On.Txt_Hp:SetText(string.format(GetText(80611521), curBossHpPercent * 100))
    element.Btn_Boss.Group_Off.Txt_Name:SetText(cfg.name)
    element.Btn_Boss.Group_Off.Txt_Hp:SetText(string.format(GetText(80611521), curBossHpPercent * 100))
  end,
  WorldBossReward_Group_BossList_StaticGrid_Boss_Group_Boss_Btn_Boss_Click = function(btn, str)
    Controller.SelectPage(tonumber(str))
  end
}
return ViewFunction
