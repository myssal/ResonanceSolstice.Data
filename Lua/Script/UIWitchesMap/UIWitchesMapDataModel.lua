local DataModel = {
  floatPath = {},
  arriverGridList = {},
  parkGridList = {},
  parkGridIndexList = {},
  startGridList = {},
  startList = {},
  startGapCount = 0,
  startBranchGridIndices = {},
  floatPathHave = {},
  startIndex = nil,
  isStartPlayer = false,
  sealList = {},
  arrivedList = {},
  eventIconList = {}
}
local floatDirectionConfig = {
  [1] = 0,
  [-1] = 180,
  [2] = 90,
  [-2] = 270
}

function DataModel:GetRounds()
  local effect_items = WitchData.GetWitchesData().effect_items or {}
  if table.count(effect_items) == 0 then
    return false, 0
  end
  for k, v in pairs(effect_items) do
    if k == "floatInquiry" and 0 < v.rounds then
      return true, v.rounds
    end
  end
  return false, 0
end

function DataModel:RefreshFloatInquiryRounds()
  local state = DataModel:GetRounds()
  if state == false then
    return
  end
  if WitchData.GetWitchesData().effect_items.floatInquiry == nil then
    return
  end
  WitchData.GetWitchesData().effect_items.floatInquiry.rounds = WitchData.GetWitchesData().effect_items.floatInquiry.rounds - 1 < 0 and 0 or WitchData.GetWitchesData().effect_items.floatInquiry.rounds - 1
end

function DataModel:Init()
  local user_witches = WitchData.GetWitchesData()
  local serverMap = user_witches.map or {}
  local user_loc = WitchData.GetGridId()
  local float_loc = tonumber(user_witches.float_loc)
  local direction = user_witches.direction or 1
  local parkCA = PlayerData:GetFactoryData(user_loc)
  if user_loc == nil or parkCA == nil then
    error(user_loc .. "\231\142\169\229\174\182\230\160\188\229\173\144\230\151\160\230\149\176\230\141\174")
    return
  end
  local carRoute = PlayerData:GetFactoryData(user_witches.float_route)
  if carRoute == nil then
    error(user_witches.float_route .. "\232\138\177\232\189\166\232\183\175\229\190\132\230\151\160\230\149\176\230\141\174")
    return
  end
  local carRouteList = carRoute.carRouteList
  DataModel.floatPath = {}
  DataModel.arriverGridList = {}
  DataModel.parkGridList = {}
  DataModel.parkGridIndexList = {}
  DataModel.eventIconList = {}
  DataModel.floatPathHave = {}
  DataModel.sealList = {}
  DataModel.arrivedList = {}
  DataModel.startIndex = nil
  DataModel.isStartPlayer = false
  DataModel.startBranchGridIndices = {}
  local state, num = DataModel:GetRounds()
  DataModel.isShowFloat = state
  DataModel.floatNum = num
  DataModel.carLengthNum = WitchData.GetParkMapCA().carLengthNum
  for k, v in pairs(carRouteList) do
    DataModel.floatPath[v.id] = {}
    DataModel.floatPath[v.id].key = k
    DataModel.floatPath[v.id].index = nil
  end
  DataModel.startList = WitchData.GetParkMapCA().startList or {}
  DataModel.startGapCount = math.max(#DataModel.startList - 1, 0)
  for k, v in ipairs(DataModel.startList) do
    if serverMap[tostring(v.id)] and serverMap[tostring(v.id)].com == 1 then
      DataModel.startIndex = k
      if v.id == user_loc then
        DataModel.isStartPlayer = true
      end
      break
    end
  end
  local gridList = WitchData.GetParkMapCA().gridList
  local startBranchGridCount = 3
  for k, v in ipairs(gridList) do
    local parkCA = PlayerData:GetFactoryData(v.id)
    local sever = serverMap[tostring(v.id)]
    local addNum = math.min(math.floor((k - 1) / startBranchGridCount), DataModel.startGapCount)
    local displayIndex = k + addNum
    DataModel.parkGridIndexList[v.id] = displayIndex
    if k <= #DataModel.startList * startBranchGridCount then
      local startListIndex = math.floor((k - 1) / startBranchGridCount) + 1
      DataModel.startBranchGridIndices[startListIndex] = DataModel.startBranchGridIndices[startListIndex] or {}
      table.insert(DataModel.startBranchGridIndices[startListIndex], displayIndex)
    end
    local eventCA = sever and PlayerData:GetFactoryData(sever.event)
    if eventCA then
      DataModel.eventIconList[displayIndex] = eventCA.EventMapIcon
    end
    if DataModel.floatPath[v.id] and DataModel.isShowFloat then
      DataModel.floatPathHave[displayIndex] = {}
      DataModel.floatPathHave[displayIndex].isActive = true
      DataModel.floatPathHave[displayIndex].isCar = false
      DataModel.floatPath[v.id].index = displayIndex
    end
    if sever and sever.com == 1 and sever.id ~= user_loc then
      DataModel.arrivedList[k + addNum] = true
    end
    DataModel.parkGridList[displayIndex] = {
      id = v.id,
      sever = sever,
      index = k,
      isShow = true
    }
    if parkCA.name ~= "" then
      local num = string.match(parkCA.prefabName, "%d+")
      if num then
        DataModel.sealList[tonumber(num)] = {
          id = v.id,
          displayIndex = displayIndex,
          eventMapIcon = eventCA and eventCA.EventMapIcon,
          seal = sever and sever.seal,
          name = parkCA.name,
          pic = parkCA.pic,
          des = parkCA.des,
          gridSealList = parkCA.gridSealList
        }
      end
    end
  end
  DataModel.currentUserIndex = DataModel.parkGridIndexList[user_loc]
  DataModel.currentFloatIndex = DataModel.parkGridIndexList[float_loc]
  local currentFloatPath = DataModel.floatPath[float_loc]
  local currentFloatPathIndex = currentFloatPath and currentFloatPath.key
  if currentFloatPathIndex and DataModel.currentFloatIndex then
    local currentDirection = 1
    local next
    if carRouteList[currentFloatPathIndex + 1] then
      next = DataModel.parkGridIndexList[carRouteList[currentFloatPathIndex + 1].id]
    else
      next = DataModel.parkGridIndexList[carRouteList[1].id]
    end
    if next then
      if next - DataModel.currentFloatIndex == 1 then
        currentDirection = -2
      elseif 1 < next - DataModel.currentFloatIndex then
        currentDirection = 1
      elseif next - DataModel.currentFloatIndex == -1 then
        currentDirection = 2
      elseif next - DataModel.currentFloatIndex < -1 then
        currentDirection = -1
      end
      DataModel.currentFloatDirection = floatDirectionConfig[currentDirection * direction]
    end
  else
    DataModel.isShowFloat = false
  end
  if DataModel.isShowFloat and currentFloatPathIndex then
    DataModel:SetSegment(currentFloatPathIndex, DataModel.carLengthNum, table.count(carRouteList), -direction)
  end
  DataModel.startGridList = {}
  for k, v in ipairs(DataModel.startList) do
    DataModel.startGridList[v.id] = k
  end
end

function DataModel:SetSegment(startIndex, length, maxValue, direction)
  local result = {}
  for i = 0, length - 1 do
    local index = (startIndex + i * direction - 1) % maxValue + 1
    result[index] = true
  end
  for k, v in pairs(DataModel.floatPath) do
    if result[v.key] and v.index and DataModel.floatPathHave[v.index] then
      DataModel.floatPathHave[v.index].isCar = true
    end
  end
end

return DataModel
