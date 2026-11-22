local DataModel = {
  ServerData = {},
  FriendList = {},
  LogList = {},
  TabIndex = 1,
  TodayLookCount = 0,
  TotalLookCount = 0,
  friendsCnt = 0,
  stealNum = 0,
  onePageNum = 30
}

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.friendsCnt = data.friend_cnt
  DataModel.InitFriend(data.friends)
  DataModel.TodayLookCount = data.coach_look_cnt_today or 0
  DataModel.TotalLookCount = data.coach_look_cnt_forever or 0
end

function DataModel.Init()
  DataModel.IsGoingHome = false
  DataModel.TabIndex = 1
  local ca = PlayerData:GetFactoryData(99900192)
  DataModel.stealNum = ca.stealNum
end

function DataModel.InitFriend(friends)
  DataModel.FriendList = {}
  for i, v in pairs(friends) do
    v.uid = i
    table.insert(DataModel.FriendList, v)
  end
  DataModel.SortFriends()
end

function DataModel.AddFriends(friends)
  for i, v in pairs(friends) do
    v.uid = i
    table.insert(DataModel.FriendList, v)
  end
  DataModel.SortFriends()
end

function DataModel.InitLog(logs)
  DataModel.LogList = {}
  for i, v in pairs(logs) do
    v.uid = i
    table.insert(DataModel.LogList, v)
  end
  table.sort(DataModel.LogList, function(a, b)
    return a.steal_ts > b.steal_ts
  end)
end

function DataModel.SortFriends()
  local function GetStealSortIndex(data)
    local ca = PlayerData:GetFactoryData(99900192, "ConfigFactory")
    
    local stealNum = ca.stealNum
    if data.steal_ss == 1 and stealNum > data.stolen_cnt then
      return 1
    end
    return 2
  end
  
  local function GetCitySortIndex(data)
    local CurStayCity = require("UIHome/UIHomeTradeDataModel").CurStayCity or 0
    if tostring(CurStayCity) == data.position then
      return 1
    end
    return 2
  end
  
  table.sort(DataModel.FriendList, function(a, b)
    if GetStealSortIndex(a) ~= GetStealSortIndex(b) then
      return GetStealSortIndex(a) < GetStealSortIndex(b)
    elseif GetCitySortIndex(a) ~= GetCitySortIndex(b) then
      return GetCitySortIndex(a) < GetCitySortIndex(b)
    else
      return a.uid > b.uid
    end
  end)
end

return DataModel
