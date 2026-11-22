local DataModel = {
  StationId = 0,
  RankList = {},
  RankListInfo = {},
  TabTypeToIdx = {},
  TimeType = {
    daily = 1,
    weekly = 2,
    all = 3,
    localDaily = 999,
    forever = 4,
    monthly = 5
  },
  TimeTypeToStr = {
    "daily",
    "weekly",
    "",
    "forever",
    "monthly",
    [999] = "daily"
  },
  CurDetailInfo = {},
  CurShowIconPng = "",
  CurTabIndex = 0,
  CurTimeType = 0,
  CurRankLvIdx = 0,
  ImgPath = {
    "UI/RankList/first_bg",
    "UI/RankList/second_bg",
    "UI/RankList/third_bg",
    "UI/RankList/other_bg"
  },
  QuickClickTime = 0,
  QuickClickLimit = 10,
  rankElements = {},
  giveLiveC = nil,
  myRank = 0,
  RankBuffInfoList = {}
}

function DataModel.Init()
  local rankList = DataModel.RankList
  if rankList == nil or next(rankList) == nil then
    local ca = PlayerData:GetFactoryData("80305428")
    rankList = ca.investorRankList
  end
  DataModel.RankListInfo = {}
  DataModel.TabTypeToIdx = {}
  for k, v in pairs(rankList) do
    local t = {}
    local rankCA = PlayerData:GetFactoryData(v.rankId, "RankFactory")
    t.rankCA = rankCA
    t.rankLv = {}
    local isOneBased = rankCA.sectionType == "onebased"
    local minLv = 0
    local curLv = PlayerData:GetPlayerLevel()
    for k1, v1 in pairs(rankCA.gradeSectionList) do
      local tLv = {}
      if isOneBased then
        tLv.minLv = 1
      else
        tLv.minLv = minLv + 1
      end
      tLv.maxLv = v1.grade
      if t.rankLvSelfIdx == nil and curLv >= tLv.minLv and curLv <= tLv.maxLv then
        t.rankLvSelfIdx = k1
      end
      table.insert(t.rankLv, tLv)
      minLv = v1.grade
    end
    DataModel.TabTypeToIdx[rankCA.rankType] = k
    table.insert(DataModel.RankListInfo, t)
  end
end

function DataModel.CollectRankInfo()
  DataModel.RankBuffInfoList = {}
  if DataModel.CurTabIndex == 1 then
    return
  end
  local curSelectStation = DataModel.RankListInfo[DataModel.CurTabIndex].rankCA.skipStation
  local stationCfg = PlayerData:GetFactoryData(curSelectStation)
  if stationCfg == nil then
    return
  end
  local lastRankLast = 1
  for index, info in ipairs(stationCfg.investRankBuffList) do
    DataModel.RankBuffInfoList[index] = {
      startIndex = lastRankLast,
      endIndex = info.investRankNum
    }
    lastRankLast = info.investRankNum + 1
    local buffCfg = PlayerData:GetFactoryData(info.id)
    DataModel.RankBuffInfoList[index].buffValue = buffCfg.param * 100
    DataModel.RankBuffInfoList[index].buffDesc = buffCfg.desc
  end
end

return DataModel
