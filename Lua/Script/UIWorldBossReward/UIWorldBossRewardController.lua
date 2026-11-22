local View = require("UIWorldBossReward/UIWorldBossRewardView")
local DataModel = require("UIWorldBossReward/UIWorldBossRewardDataModel")
local Controller = {}

function Controller.ShowPanel(select)
  DataModel.list = {}
  for k, v in pairs(DataModel.cfg.bossNormalList) do
    local temp = {
      id = v.id
    }
    table.insert(DataModel.list, temp)
  end
  for k, v in pairs(DataModel.cfg.bossFinalList) do
    local temp = {
      id = v.id
    }
    table.insert(DataModel.list, temp)
  end
  DataModel.curSelect = 1
  View.Group_BossList.StaticGrid_Boss.grid.self:SetDataCount(#DataModel.list)
  View.Group_BossList.StaticGrid_Boss.grid.self:RefreshAllElement()
  DataModel.curSelect = nil
  select = select or 1
  Controller.SelectPage(select)
end

function Controller.SelectPage(idx)
  if DataModel.curSelect == idx then
    return
  end
  DataModel.curSelect = idx
  DataModel.onlyRefreshSelect = true
  View.Group_BossList.StaticGrid_Boss.grid.self:RefreshAllElement()
  DataModel.onlyRefreshSelect = nil
  local data = DataModel.list[idx]
  DataModel.curBossId = data.id
  local netData = PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)]
  local cfg = PlayerData:GetFactoryData(data.id)
  local viewCfg = PlayerData:GetFactoryData(cfg.bossViewId)
  View.Group_Boss.Spine_Boss:SetData(viewCfg.resDir)
  View.Group_Boss.Spine_Boss:SetAnchoredPosition(Vector2(cfg.spineX, cfg.spineY))
  View.Group_Boss.Spine_Boss:SetLocalScale(Vector3.one * cfg.spineScale)
  DataModel.curBossHpPercent = netData.world_bosses[tostring(data.id)].hp / cfg.bossHp
  DataModel.curBossBeatTimes = netData.boss[tostring(DataModel.curBossId)].kill or 0
  local bossData = netData.boss[tostring(DataModel.curBossId)].received
  DataModel.rewardList = {}
  for k, v in pairs(cfg.bossRewardList) do
    local tempData = {}
    tempData.index = k
    tempData.recv = table.contains(bossData, k - 1)
    tempData.ratio = v.ratio
    tempData.id = v.id
    tempData.bossBattleTimes = v.bossBattleTimes
    table.insert(DataModel.rewardList, tempData)
  end
  table.sort(DataModel.rewardList, function(a, b)
    if a.recv == b.recv then
      return a.index < b.index
    else
      return not a.recv and b.recv
    end
  end)
  View.Group_RewardList.ScrollGrid_Level.grid.self:SetDataCount(#DataModel.rewardList)
  View.Group_RewardList.ScrollGrid_Level.grid.self:RefreshAllElement()
end

return Controller
