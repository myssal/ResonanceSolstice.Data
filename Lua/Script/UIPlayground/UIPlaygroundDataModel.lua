local DataModel = {
  initParams = {},
  isLoad = false,
  cacheEventList = {},
  cacheEventChaIdInfo = {},
  cacheBattleChaInfo = {},
  battleFindIdx = 1,
  maxCoachNum = 0,
  camRoom = 0,
  lastSelectIdx = 0,
  isOpenToDecorate = false,
  questList = {},
  cacheQuestIdx = {},
  cachePlotQuestIdx = {},
  cacheDebuff = 0,
  cacheClean = 0,
  helpReward = {}
}

function DataModel.InitRoomInfo()
  CommonCoachData.InitCoachBagTagId(DataModel.initParams.playgroundId)
  CommonCoachData.RefreshData()
end

function DataModel.InitQuestInfo()
  local playgroundCA = PlayerData:GetFactoryData(DataModel.initParams.playgroundId)
  DataModel.questList = {}
  DataModel.cacheQuestIdx = {}
  for idx, v in ipairs(playgroundCA.questList) do
    DataModel.questList[idx] = v.id
    DataModel.cacheQuestIdx[v.id] = idx
    local questCA = PlayerData:GetFactoryData(v.id)
    local state = PlayerData.GetQuestState(v.id)
    if questCA.IsPlotTask and state ~= EnumDefine.EQuestState.Receive then
      table.insert(DataModel.cachePlotQuestIdx, idx)
    end
  end
end

return DataModel
