local DataModel = {}
local this = DataModel
DataModel.passengerList = {}
DataModel.orderPassengerList = {}
DataModel.enterSound = nil
DataModel.outSound = nil

function DataModel.RefreshOrderPassengerList(orderInfo)
  DataModel.orderPassengerList = {}
  for i, v in pairs(orderInfo.passengerList) do
    local info = {}
    info.passengerCA = PlayerData:GetFactoryData(v.id, "PassageFactory")
    info.num = v.num
    table.insert(DataModel.orderPassengerList, info)
  end
end

function DataModel.GetPsgFurIndex(psgUid, psgData)
  local furniture = PlayerData:GetHomeInfo().furniture[psgData.u_fid]
  for index, psgUid1 in pairs(furniture.passenger) do
    if psgUid1 ~= "" and psgUid1 == psgUid then
      return index
    end
  end
  return -1
end

function DataModel.GetPsgFurRoomIndex(u_fid)
  local furniture = PlayerData:GetHomeInfo().furniture[u_fid]
  for roomIdx, u_cid in pairs(CommonCoachData.roomUCid) do
    if u_cid == furniture.u_cid then
      return roomIdx
    end
  end
  return -1
end

function DataModel.GetPassengerList()
  local passenger = PlayerData:GetHomeInfo().passenger
  local t = {}
  local key = ""
  for endStationId, v in pairs(passenger) do
    for psgUid, psgData in pairs(v) do
      key = string.format("%s_%s_%s_%s", psgData.origin, endStationId, psgData.id, psgData.psg_tag)
      t[key] = t[key] or {}
      table.insert(t[key], {
        startStationId = tonumber(psgData.origin),
        endStationId = tonumber(endStationId),
        psgUid = psgUid,
        psgData = psgData
      })
    end
  end
  local passengerList = {}
  for _, v in pairs(t) do
    table.insert(passengerList, v)
  end
  return passengerList
end

local tagList = {}
local startStation
local minDistanceList = {}

local function AroundFind(station)
  local aroundLineList = {}
  for i, v in pairs(CacheAndGetFactory("HomeLineFactory")) do
    if v.station01 == station then
      table.insert(aroundLineList, {
        aroundId = v.station02,
        lineId = v.id,
        distance = v.distance
      })
    elseif v.station02 == station then
      table.insert(aroundLineList, {
        aroundId = v.station01,
        lineId = v.id,
        distance = v.distance
      })
    end
  end
  for i, v in pairs(aroundLineList) do
    minDistanceList[startStation][v.aroundId] = minDistanceList[startStation][v.aroundId] or {}
    local beforeLineList = minDistanceList[startStation][v.aroundId]
    if table.count(beforeLineList) > 0 then
      local beforeDistance = 0
      for i, lineId in pairs(beforeLineList) do
        beforeDistance = PlayerData:GetFactoryData(lineId, "HomeLineFactory").distance + beforeDistance
      end
      local startToParentLine = minDistanceList[startStation][station]
      local distance = this.GetLineDistance(startToParentLine)
      if beforeDistance > distance + v.distance then
        minDistanceList[startStation][v.aroundId] = {}
        for i, lineId in pairs(startToParentLine) do
          table.insert(minDistanceList[startStation][v.aroundId], lineId)
        end
        table.insert(minDistanceList[startStation][v.aroundId], v.lineId)
      end
    else
      local startToParentLine = minDistanceList[startStation][station]
      if startToParentLine then
        for i, lineId in pairs(startToParentLine) do
          table.insert(minDistanceList[startStation][v.aroundId], lineId)
        end
      end
      table.insert(minDistanceList[startStation][v.aroundId], v.lineId)
    end
  end
  return aroundLineList
end

local function InitNearestLine(station)
  if not station or tagList[station] then
    return
  end
  tagList[station] = station
  minDistanceList[startStation] = minDistanceList[startStation] or {}
  local aroundLineList = AroundFind(station)
  for i, v in pairs(aroundLineList) do
    InitNearestLine(v.aroundId)
  end
end

function DataModel.GetNearestLine(station1, station2)
  tagList = {}
  startStation = station1
  if minDistanceList[station1] and minDistanceList[station1][station2] then
    return minDistanceList[station1][station2]
  elseif minDistanceList[station2] and minDistanceList[station2][station1] then
    return minDistanceList[station2][station1]
  else
    InitNearestLine(station1)
    return minDistanceList[station1][station2]
  end
end

function DataModel.GetNearestLineDistance(station1, station2)
  station1 = tonumber(station1)
  station2 = tonumber(station2)
  if not station1 or not station2 then
    return
  end
  local lineList = this.GetNearestLine(station1, station2)
  local distance = 0
  lineList = lineList or {}
  for i, lineId in pairs(lineList) do
    distance = PlayerData:GetFactoryData(lineId, "HomeLineFactory").distance + distance
  end
  return distance
end

function DataModel.GetLineDistance(lineList)
  local distance = 0
  lineList = lineList or {}
  for i, lineId in pairs(lineList) do
    distance = PlayerData:GetFactoryData(lineId, "HomeLineFactory").distance + distance
  end
  return distance
end

local function GetPassengerStart(id)
  return PlayerData:GetFactoryData(id, "PassageFactory").star
end

function DataModel.SetPassengerListByLevel()
  local psgList = this.GetPassengerList()
  table.sort(psgList, function(a, b)
    return GetPassengerStart(a[1].psgData.id) < GetPassengerStart(b[1].psgData.id)
  end)
  this.passengerList = psgList
end

function DataModel.SetPassengerListByDistance()
  local psgList = this.GetPassengerList()
  table.sort(psgList, function(a, b)
    return this.GetNearestLineDistance(a[1].startStationId, a[1].endStationId) < this.GetNearestLineDistance(b[1].startStationId, b[1].endStationId)
  end)
  this.passengerList = psgList
end

function DataModel.GetOutPassengerList(json, length)
  local roleIds = {}
  local psgInfos = {}
  for destination, v in pairs(PlayerData:GetHomeInfo().passenger) do
    if not json.passenger[destination] then
      for uid, info in pairs(v) do
        local psgInfo = {}
        psgInfo.id = info.id
        table.insert(psgInfos, psgInfo)
      end
      break
    end
  end
  table.sort(psgInfos, function(a, b)
    local psgCA1 = PlayerData:GetFactoryData(a.id, "PassageFactory")
    local psgCA2 = PlayerData:GetFactoryData(b.id, "PassageFactory")
    if psgCA1.star == psgCA2.star then
      return tonumber(psgCA1.homePassage) < tonumber(psgCA2.homePassage)
    else
      return psgCA1.star < psgCA2.star
    end
  end)
  for k, v in ipairs(psgInfos) do
    local passengerCA = PlayerData:GetFactoryData(v.id, "PassageFactory")
    table.insert(roleIds, tonumber(passengerCA.homePassage))
    if length and length <= #roleIds then
      break
    end
  end
  return roleIds
end

function DataModel.CreateNpc(enter)
  MainSceneCharacterManager:InitNpcPos()
  local npcListCA = PlayerData:GetFactoryData(80302056, "ListFactory")
  local leftIndex = math.random(1, table.count(npcListCA.passengerAction1))
  local psgCA = PlayerData:GetFactoryData(npcListCA.passengerAction1[leftIndex].id)
  MainSceneCharacterManager:CreateNpc(psgCA.homePassage, 0, true)
  local rightIndex = math.random(1, table.count(npcListCA.passengerAction2))
  psgCA = PlayerData:GetFactoryData(npcListCA.passengerAction2[rightIndex].id)
  MainSceneCharacterManager:CreateNpc(psgCA.homePassage, 0, false)
  local runIndex = math.random(1, table.count(npcListCA.passengerAction3))
  psgCA = PlayerData:GetFactoryData(npcListCA.passengerAction3[runIndex].id)
  MainSceneCharacterManager:CreateNpc(psgCA.homePassage, 1, enter)
  local walkIndex = math.random(1, table.count(npcListCA.passengerAction4))
  psgCA = PlayerData:GetFactoryData(npcListCA.passengerAction4[walkIndex].id)
  MainSceneCharacterManager:CreateNpc(psgCA.homePassage, 2, enter)
  local idleIndex = math.random(1, table.count(npcListCA.passengerAction5))
  psgCA = PlayerData:GetFactoryData(npcListCA.passengerAction5[idleIndex].id)
  MainSceneCharacterManager:CreateNpc(psgCA.homePassage, 3, enter)
  local idleIndex2 = math.random(1, table.count(npcListCA.passengerAction6))
  psgCA = PlayerData:GetFactoryData(npcListCA.passengerAction6[idleIndex2].id)
  MainSceneCharacterManager:CreateNpc(psgCA.homePassage, 4, enter)
  if enter then
    local enterSound = SoundManager:CreateSound(30002451)
    if enterSound ~= nil then
      enterSound:Play()
    end
  else
  end
end

function DataModel.CreateHomePassenger()
  for _, passengers in pairs(PlayerData:GetHomeInfo().passenger) do
    DataModel.CreatePassengers(passengers)
  end
end

function DataModel.CreatePassengers(passengers)
  local emptyTileRoomMap = {}
  for psgUid, psgData in pairs(passengers) do
    local roomIdx = this.GetPsgFurRoomIndex(psgData.u_fid)
    if roomIdx ~= -1 then
      local emptyTileCount = emptyTileRoomMap[roomIdx]
      emptyTileCount = emptyTileCount or PosClickHandler.GetRoomEmptyTileCount(roomIdx)
      local character
      if emptyTileCount == 0 then
        character = DataModel.GetOrCreatePassenger(psgUid, psgData)
      else
        character = DataModel.GetOrCreatePassenger(psgUid, psgData, true)
        emptyTileCount = emptyTileCount - 1
      end
      if character and not character.curTile then
        local tile = character:GetTile(0, 0)
        character:SetTile(tile)
      end
      emptyTileRoomMap[roomIdx] = emptyTileCount
    end
  end
end

function DataModel.GetOrCreatePassenger(psgUid, psgData, hasEmptyTile)
  local character = HomeCharacterManager:GetPassenger(psgUid)
  if not character then
    local furIndex = this.GetPsgFurIndex(psgUid, psgData)
    local roomIdx = this.GetPsgFurRoomIndex(psgData.u_fid)
    if furIndex ~= -1 and roomIdx ~= -1 then
      local passengerCA = PlayerData:GetFactoryData(psgData.id, "PassageFactory")
      local characterId = passengerCA.homePassage
      if hasEmptyTile then
        character = HomeCharacterManager:CreatePassengerCharacter(psgUid, characterId, psgData.u_fid, furIndex - 1, roomIdx - 1)
      else
        local furniture = HomeManager:GetFurnitureByUfid(psgData.u_fid)
        if furniture then
          local tileIdx = furniture:GetTileIdx()
          character = HomeCharacterManager:CreatePassengerCharacter(psgUid, characterId, psgData.u_fid, furIndex - 1, roomIdx - 1, "", 0, tileIdx)
        end
      end
    end
  end
  if character and not character.curTile then
    local tile = character:GetTile(0, 0)
    character:SetTile(tile)
  end
  return character
end

local curPassengerSitNum = 0

function DataModel.InitPassengerSit(reshow)
  if reshow then
    for _, passengers in pairs(PlayerData:GetHomeInfo().passenger) do
      for psgUid, psgData in pairs(passengers) do
        local roomIdx = this.GetPsgFurRoomIndex(psgData.u_fid)
        if roomIdx ~= -1 then
          DataModel.GetOrCreatePassenger(psgUid, psgData)
        end
      end
    end
  end
  local passengerNum = 0
  for _, passengers in pairs(PlayerData:GetHomeInfo().passenger) do
    passengerNum = passengerNum + table.count(passengers)
  end
  local maxStandNum = passengerNum < 4 and 0 or math.floor(passengerNum * 0.3)
  local needSitNum = passengerNum - maxStandNum
  HomeCharacterManager:SetSitNum(needSitNum)
  local remainPassenger = {}
  local sitList = {}
  local sitNum = 0
  for _, passengers in pairs(PlayerData:GetHomeInfo().passenger) do
    for psgUid, psgData in pairs(passengers) do
      local furIndex = this.GetPsgFurIndex(psgUid, psgData)
      local roomIdx = this.GetPsgFurRoomIndex(psgData.u_fid)
      if furIndex ~= -1 and roomIdx ~= -1 then
        local character = HomeCharacterManager:GetPassenger(psgUid)
        if character then
          if not character.curTile:isEmpty() then
            sitNum = sitNum + 1
            sitList[psgUid] = {
              psgData = psgData,
              furIndex = furIndex,
              roomIdx = roomIdx,
              character = character
            }
          else
            remainPassenger[psgUid] = {
              psgData = psgData,
              furIndex = furIndex,
              roomIdx = roomIdx,
              character = character
            }
          end
        end
      end
    end
  end
  local standNum = 0
  for psgUid, v in pairs(remainPassenger) do
    if needSitNum > sitNum then
      sitNum = sitNum + 1
      sitList[psgUid] = v
    else
      v.character:ResetAIPart()
      standNum = standNum + 1
    end
  end
  HomeCharacterManager:ResetCurSitNum()
  for psgUid, v in pairs(sitList) do
    local psgData = v.psgData
    local furniture = HomeManager:GetFurnitureByUfid(psgData.u_fid)
    if furniture then
      local passengerCA = PlayerData:GetFactoryData(psgData.id, "PassageFactory")
      local characterId = passengerCA.homePassage
      local characterCA = PlayerData:GetFactoryData(characterId, "HomeCharacterFactory")
      local time = 0 < characterCA.maxTime and math.random(characterCA.minTime, characterCA.maxTime) or math.random(characterCA.minTime, 15)
      HomeCharacterManager:InitContinuousOp(v.character, psgData.u_fid, v.furIndex - 1, time)
    end
  end
  if not reshow then
    curPassengerSitNum = HomeCharacterManager.curPassengerSitNum
  else
    HomeCharacterManager.curPassengerSitNum = curPassengerSitNum + standNum
  end
end

function DataModel.RefreshPassenger(newPsgData, newFurnitureData)
  if newFurnitureData then
    for i, furData in pairs(newFurnitureData) do
      local oldFurData = PlayerData.ServerData.user_home_info.furniture[i]
      if oldFurData then
        oldFurData.passenger = furData.passenger
      end
    end
  end
  if newPsgData then
    local mainUIDataModel = require("UIMainUI/UIMainUIDataModel")
    if MainManager.bgSceneName == mainUIDataModel.SceneNameEnum.Home then
      local addPsg = {}
      local reducePsg = {}
      for stationId, v in pairs(newPsgData) do
        if not PlayerData:GetHomeInfo().passenger[stationId] then
          for psgUid, psgData in pairs(v) do
            addPsg[psgUid] = psgData
          end
        else
          for psgUid, psgData in pairs(v) do
            if not PlayerData:GetHomeInfo().passenger[stationId][psgUid] then
              addPsg[psgUid] = psgData
            end
          end
        end
      end
      for stationId, v in pairs(PlayerData:GetHomeInfo().passenger) do
        if not newPsgData[stationId] then
          for psgUid, psgData in pairs(v) do
            reducePsg[psgUid] = psgData
          end
        else
          for psgUid, psgData in pairs(v) do
            if not newPsgData[stationId][psgUid] then
              reducePsg[psgUid] = psgData
            end
          end
        end
      end
      local curNum = 0
      for _, v in pairs(newPsgData) do
        curNum = curNum + table.count(v)
      end
      for psgUid, v in pairs(reducePsg) do
        HomeCharacterManager:RecyclePassenger(psgUid)
      end
      DataModel.CreatePassengers(addPsg)
      DataModel.InitPassengerSit()
    end
    PlayerData:GetHomeInfo().passenger = newPsgData
  end
end

return DataModel
