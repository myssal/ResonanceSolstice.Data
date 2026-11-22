local DataModel = {
  HallOrderList = {},
  CurSelectOrderIndex = 0,
  CurrentTab = 1,
  BeingInviteList = {},
  CurOrderEndTime = -1,
  NPCHallId = 83700159,
  NPCInviteId = 83700158,
  Enum_SortType = {
    all = 1,
    clothing = 2,
    paint = 3,
    other = 4
  },
  SortTypeData = {
    [1] = {txtId = 80611973, str = nil},
    [2] = {txtId = 80611975, str = "clothing"},
    [3] = {txtId = 80611976, str = "paint"},
    [4] = {txtId = 80611977, str = "other"}
  }
}
DataModel.NPCDialogEnum = {
  enterText = "enterText",
  chooseOrderText = "chooseOrderText",
  joinOrderText = "joinOrderText",
  refreshOrderText = "refreshOrderText"
}

function DataModel.Init()
  DataModel.HallOrderList = {}
  DataModel.BeingInviteList = {}
  DataModel.CurSelectOrderIndex = 0
  DataModel.CurrentTab = 1
  DataModel.CurOrderEndTime = -1
end

function DataModel.RefreshHallOrderData()
  DataModel.HallOrderList = {}
  local serverData = PlayerData.ServerData.user_info.hall_order
  for i, v in pairs(serverData) do
    local data = {
      id = v.order_id,
      endTime = v.end_ts,
      uid = i,
      team = {}
    }
    for uid, playerData in pairs(v.deliver_queue) do
      table.insert(data.team, {
        uid = uid,
        avatar = playerData.avatar
      })
    end
    table.insert(DataModel.HallOrderList, data)
  end
end

function DataModel.RefreshBeingInviteData()
  DataModel.BeingInviteList = {}
  local serverData = PlayerData.ServerData.user_info.being_invite_data
  if not serverData or table.count(serverData) == 0 then
    return
  end
  for i, v in pairs(serverData) do
    local data = {
      uid = i,
      team = {},
      endTime = v.end_ts,
      id = v.order_id
    }
    for playerUId, playerData in pairs(v.deliver_queue) do
      table.insert(data.team, {
        uid = playerUId,
        avatar = playerData.avatar
      })
    end
    table.insert(DataModel.BeingInviteList, data)
  end
end

function DataModel.GetOrderReward(uid, id)
  local result = {}
  local orderCfg = PlayerData:GetFactoryData(id)
  local rewardList = orderCfg.rewardsList
  local factor = DataModel.GetOrderFactorValue(uid)
  local nowActivity = require("UIGroup_EventWeek/WeekActivityData").FindNowWeekActivity()
  local upOrderData = require("UIGroup_EventWeek/WeekActivityData").GetOrderData(nowActivity)
  local isUpOrder = upOrderData and upOrderData[id] ~= nil
  for i, v in ipairs(rewardList) do
    local num = v.num * factor * (isUpOrder and 1 + upOrderData[id].param or 1)
    num = math.floor(num + 0.5)
    table.insert(result, {
      id = v.id,
      num = num
    })
  end
  return result
end

function DataModel.GetOrderDeliverCount(uid)
  local result = 0
  if PlayerData.ServerData.user_info.hall_order[uid] then
    local deliverQueue = PlayerData.ServerData.user_info.hall_order[uid].deliver_queue
    for k, v in pairs(deliverQueue) do
      if v.deliver_list and 0 < table.count(v.deliver_list) then
        for index, data in ipairs(v.deliver_list) do
          result = result + data.num
        end
      end
    end
    return result
  end
  return result
end

function DataModel.GetOrderRequireCount(uid, id)
  local result = 0
  local orderCfg = PlayerData:GetFactoryData(id)
  local factor = DataModel.GetOrderFactorValue(uid)
  for i, v in ipairs(orderCfg.requireItemList) do
    result = result + v.num
  end
  return result * factor
end

function DataModel.GetOrderFactorValue(uid)
  if not uid then
    return 1
  end
  local strs = string.split(uid, "_")
  if table.count(strs) == 2 then
    local factorValue = tonumber(strs[2])
    return factorValue
  end
  return 1
end

function DataModel.IsInTeam(orderUid)
  local order = DataModel.CurrentTab == 1 and PlayerData.ServerData.user_info.hall_order[orderUid] or PlayerData.ServerData.user_info.being_invite_data[orderUid]
  if not order then
    return false
  end
  local member = order.deliver_queue
  if not member then
    return false
  end
  local uid = PlayerData.ServerData.user_info.uid
  return member[tostring(uid)] ~= nil
end

return DataModel
