local DataModel = {
  roomID = {},
  roomUCid = {},
  roomSkinIds = {},
  roomData = {
    [1] = "{\"81300001\":[{\"x\":0, \"y\":0}],\"81300004\":[{\"x\":0, \"y\":0}],\"81300002\":[{\"x\":0, \"y\":0}],\"81300008\":[{\"x\":10, \"y\":10}],\"81300011\":[{\"x\":25, \"y\":0}],\"81300006\":[{\"x\":28, \"y\":3}],}",
    [2] = "{\"81300001\":[{\"x\":0, \"y\":0}],\"81300004\":[{\"x\":0, \"y\":0}],\"81300002\":[{\"x\":0, \"y\":0}],\"81300008\":[{\"x\":10, \"y\":10}],\"81300011\":[{\"x\":25, \"y\":0}],}",
    [3] = "{\"81300001\":[{\"x\":0, \"y\":0}],\"81300004\":[{\"x\":0, \"y\":0}],\"81300002\":[{\"x\":0, \"y\":0}],\"81300008\":[{\"x\":10, \"y\":10}],\"81300011\":[{\"x\":25, \"y\":0}],}"
  },
  roomFurnitureData = {}
}
local CoachBagTagToCoachBagKey = {
  [12601230] = "coach",
  [12601231] = "playground"
}
local cacheCoachBagTagId, cachePlaygroundId

function DataModel.InitCoachBagTagId(playgroundId)
  cachePlaygroundId = playgroundId
  if playgroundId == nil or playgroundId < 0 then
    cacheCoachBagTagId = 12601230
  else
    local ca = PlayerData:GetFactoryData(playgroundId)
    cacheCoachBagTagId = ca.bag
  end
end

function DataModel.GetRoomData(playgroundId, isSort)
  if playgroundId == nil then
    playgroundId = cachePlaygroundId
  end
  if playgroundId == nil or playgroundId < 0 then
    return PlayerData:GetHomeInfo().coach or {}
  else
    local playgroundInfo = PlayerData:GetHomeInfo().playground[tostring(playgroundId)]
    if playgroundInfo and playgroundInfo.block then
      if isSort then
        local t = {}
        for k, v in pairs(playgroundInfo.block) do
          local info = Clone(v)
          info.uid = k
          table.insert(t, info)
        end
        table.sort(t, function(a, b)
          if a.create_ts == nil and b.create_ts ~= nil then
            return true
          end
          if a.create_ts ~= nil and b.create_ts == nil then
            return false
          end
          if a.create_ts == nil and b.create_ts == nil then
            return false
          end
          return a.create_ts < b.create_ts
        end)
        return t
      end
      return playgroundInfo.block
    end
    return {}
  end
  return {}
end

function DataModel.RefreshData(playgroundId)
  DataModel.roomUCid = {}
  DataModel.roomID = {}
  DataModel.roomSkinIds = {}
  DataModel.roomData = {}
  DataModel.roomFurnitureData = {}
  if cacheCoachBagTagId == nil or cacheCoachBagTagId <= 0 then
    return
  end
  local data = DataModel.GetRoomData(playgroundId, true)
  if PlayerData.visitMode then
    data = PlayerData.visitInfo.coachData
  end
  for i, v in ipairs(data) do
    local coachCA = PlayerData:GetFactoryData(v.id, "HomeCoachFactory")
    local tagCA = PlayerData:GetFactoryData(coachCA.coachType)
    if not tagCA.stopCarriage then
      local uid = v.uid
      if uid == nil and type(i) == "number" then
        uid = PlayerData:GetHomeInfo().coach_template[i]
        if PlayerData.visitMode then
          uid = PlayerData.visitInfo.coach_template[i]
        end
      end
      table.insert(DataModel.roomUCid, uid)
      table.insert(DataModel.roomID, tonumber(v.id))
      local json = "{"
      local cacheUid = {}
      local furniture = {}
      local serverFurs = CommonCoachData.GetFurData(cacheCoachBagTagId)
      for i2, v2 in pairs(v.location) do
        local fur = {}
        local serverFurData = serverFurs[v2.id]
        fur.id = serverFurData.id
        fur.ufid = v2.id
        if cacheUid[v2.id] == nil then
          cacheUid[v2.id] = 1
          fur.x = v2.x
          fur.y = v2.y
          fur.z = v2.z or 0
          fur.skinId = PosClickHandler.GetFurnitureSkinId(v2.id, cacheCoachBagTagId)
          json = json .. "\"" .. i2 .. "\":[{ \"id\":" .. fur.id .. ", \"ufid\":" .. v2.id .. ", \"skinId\":" .. fur.skinId .. ", \"x\":" .. v2.x .. ",\"y\":" .. v2.y .. ",\"z\":" .. fur.z .. "}],"
          table.insert(furniture, {
            ufid = v2.id,
            id = fur.id,
            skinId = fur.skinId
          })
        end
      end
      json = json .. "}"
      table.insert(DataModel.roomData, json)
      table.insert(DataModel.roomFurnitureData, furniture)
    end
    local skinId = tonumber(v.skin)
    if skinId == nil then
      skinId = coachCA.defaultSkin
    end
    table.insert(DataModel.roomSkinIds, skinId)
  end
end

function DataModel.AddFurniture(idx, data)
  table.insert(DataModel.roomFurnitureData[idx], data)
end

function DataModel.RemoveFurniture(idx, ufid)
  local furAry = DataModel.roomFurnitureData[idx]
  local pos = -1
  for i, v in pairs(furAry) do
    if v.ufid == ufid then
      pos = i
      break
    end
  end
  if pos ~= -1 then
    table.remove(DataModel.roomFurnitureData[idx], pos)
  end
end

function DataModel.GetFurData(coachBagTagId)
  if PlayerData.visitMode then
    return PlayerData.visitInfo.furdata or {}
  end
  if coachBagTagId == nil or coachBagTagId <= 0 then
    coachBagTagId = cacheCoachBagTagId or 12601230
  end
  local home_Info = PlayerData:GetHomeInfo()
  local furData
  if EnumDefine.CoachBagTagToFurBagKey[coachBagTagId] then
    furData = home_Info[EnumDefine.CoachBagTagToFurBagKey[coachBagTagId]]
    local strBagId = tostring(coachBagTagId)
    if furData[strBagId] then
      furData = furData[strBagId]
    end
  else
    furData = {}
  end
  return furData
end

function DataModel.GetCurPlaygroundServerInfo(playgroundId)
  if playgroundId == nil then
    playgroundId = cachePlaygroundId
  end
  if 0 < playgroundId then
    return PlayerData:GetHomeInfo().playground[tostring(playgroundId)]
  end
  return {}
end

function DataModel.GetPlaygroundId()
  return cachePlaygroundId
end

function DataModel.GoHome()
  if MapSessionManager.currentSession then
    MapNeedleData.GoHome()
    return
  end
  local backSceneName = PlayerData.TempCache.backSceneName
  if backSceneName == nil or backSceneName == "" then
    backSceneName = "Main"
  end
  local curSceneName = MainManager.bgSceneName
  if curSceneName ~= backSceneName then
    local function cb()
      local SliceSceneManager = CBus:GetManager(CS.ManagerName.SliceSceneManager, true)
      
      if SliceSceneManager ~= nil then
        SliceSceneManager.loadedScene:Clear()
      end
      CBus:ChangeScene(backSceneName)
      GameSetting:LoadPlayerSetting()
      PlayerData:ResetCharacterFilter()
      PlayerData:ResetSuaqsFilter()
      PlayerData:ResetDepotFilter()
    end
    
    if cachePlaygroundId and 0 < cachePlaygroundId then
      local playgroundCA = PlayerData:GetFactoryData(cachePlaygroundId)
      local randomNum = math.random(1, #playgroundCA.loadingList)
      CommonTips.OpenLoading(nil, "", playgroundCA.loadingList[randomNum].imagePath, cb)
    else
      CommonTips.OpenLoading(nil, "", nil, cb)
    end
  else
    UIManager:GoHome()
  end
end

return DataModel
