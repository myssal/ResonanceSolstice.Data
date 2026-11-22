local DataModel = {
  ActivityId = WitchData.GetActivityId(),
  CurTab = 1,
  CurDetailInfo = {},
  rankElements = {},
  QuickClickTime = 0,
  QuickClickLimit = 10,
  RankDailyId = WitchData.GetRankDailyId(),
  RankForeverId = WitchData.GetRankForeverId(),
  RewardPeopleCount = 0,
  RewardList = {},
  CurInfoSeal = {},
  CurTeamInfo = {}
}
DataModel.serverRankList = {}
DataModel.severSelfRank = {}
DataModel.totalServerRankNum = 0
DataModel.serveRankCacheInfo = {}
DataModel.dailyRankList = {}

function DataModel.Init()
  DataModel.CurDetailInfo = {}
  DataModel.QuickClickTime = DataModel.QuickClickLimit
  local rankingReward = WitchData.GetActivityCA(DataModel.ActivityId).rankingReward
  DataModel.RewardPeopleCount = rankingReward[1].rank
  DataModel.RewardList = Clone(PlayerData:GetFactoryData(rankingReward[1].id).rewardList)
end

function DataModel.SetJsonData(json)
  if not json then
    DataModel.ActivityId = WitchData.GetActivityId()
    return
  end
  local data = Json.decode(json)
  DataModel.ActivityId = tonumber(data.activityId) or WitchData.GetActivityId()
  DataModel.CurTab = data.tab
end

function DataModel.SimpleDamageValue(value)
  local suffixes = {
    "t",
    "b",
    "m"
  }
  local thresholds = {
    1000000000000,
    1000000000,
    1000000
  }
  for i, threshold in ipairs(thresholds) do
    if threshold <= value then
      local divided = value / threshold
      local formatted
      if 1000000 <= divided then
        formatted = tostring(math.floor(divided))
        if 6 < #formatted then
          formatted = formatted:sub(1, 6)
        end
      else
        local integerDigits = math.floor(math.log(divided, 10)) + 1
        local maxDecimalDigits = math.max(0, 5 - integerDigits)
        local multiplier = 10 ^ maxDecimalDigits
        local rounded = math.floor(divided * multiplier + 0.5) / multiplier
        if 0 < maxDecimalDigits then
          formatted = string.format("%." .. maxDecimalDigits .. "f", rounded)
          formatted = formatted:gsub("%.?0+$", "")
        else
          formatted = tostring(math.floor(rounded))
        end
      end
      return formatted .. suffixes[i]
    end
  end
  return tostring(value)
end

function DataModel.RefreshServerRankData(json)
  DataModel.serverRankList = json.rank_list
  DataModel.severSelfRank = json.my_rank
  DataModel.totalServerRankNum = json.total_members
end

function DataModel.RefreshServerRankCacheInfo(json)
  local t = {}
  t.has_more = json.has_more
  t.request_id = json.request_id
  t.next_index = json.next_index
  DataModel.serveRankCacheInfo = t
end

function DataModel.RefreshSeverRankShowLimitNum(has_more)
  local curNum = table.count(DataModel.serverRankList)
  DataModel.showLimitIndex = curNum
  if has_more then
    local remainNum = DataModel.totalServerRankNum - curNum
    local limitNum = 5 <= remainNum and 5 or remainNum
    DataModel.showLimitIndex = curNum + limitNum
  end
end

function DataModel.GetRankList()
  if DataModel.CurTab == 1 then
    return DataModel.dailyRankList
  elseif DataModel.CurTab == 2 then
    return DataModel.serverRankList
  end
end

return DataModel
