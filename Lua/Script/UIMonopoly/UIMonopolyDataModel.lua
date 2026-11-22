local View = require("UIMonopoly/UIMonopolyView")
local DataModel = {
  lastFps = 60,
  reqOutputFunc = nil,
  isBoxBossFighting = false,
  isHelpBoss = false,
  userMonopolyData = nil,
  serverMonopolyData = nil,
  interfaceData = nil,
  interfaceIsfull = 0,
  gridList = {},
  otherPlayers = {},
  refreshInterval = 20,
  isInRefreshCDing = false,
  refreshGridOutputTimerInterval = 20,
  nextRefreshTime = 0,
  buffType = {
    diceChange = "diceChange",
    back = "back",
    diceFix = "diceFix",
    diceFixPlus = "diceFixPlus",
    bossHit = "bossHit",
    investNum = "investNum",
    helpFriend = "helpFriend",
    stop = "stop",
    return_ = "return",
    go = "go",
    rpg = "RPG",
    randomArrow = "randomArrow",
    refreshBox = "refreshBox"
  },
  curSelectItemId = 0,
  curSelectItemIndex = 0,
  refreshBtnInCD = false,
  curSelectUid = "",
  buffGodInfo = {
    buffId = nil,
    belong = nil,
    uid = nil,
    getTime = nil
  },
  beforeMoveInfo = {
    gridId = 0,
    moveDir = 0,
    step = 0
  },
  godRefreshTime = nil,
  objNamePrefix = {
    ROLE = "MONOPOLY_ROLE",
    GRID = "MONOPOLY_GRID",
    BOSS = "MONOPOLY_BOX_BOSS"
  },
  useRange = {
    oneSelf = "oneself",
    otherPlayer = "otherPlayer",
    player = "player",
    grid = "grid",
    effectNow = "effectNow"
  },
  buffEffectObjs = {},
  lastMoneyNum = nil,
  autoPathIds = nil,
  moveSuccessJson = nil,
  itemEvents = {},
  mainCamera = nil,
  openSound = nil,
  roleIdleSound = nil,
  roleStopSound = nil,
  roleMoveSound = nil,
  getBuff = nil,
  getDeBuff = nil,
  getGold = nil,
  soundIds = {
    uiOpen = 30006378,
    trainIdle = 30006390,
    trainStop = 30006391,
    trainMove = 30006388,
    getBuff = 30006360,
    getDeBuff = 30006373,
    getGold = 30006361,
    useDice = 30006386
  },
  soundList = {},
  moveSound = nil,
  idleSound = nil,
  isFirstOpened = true,
  mapGridObjs = {},
  isDrag = false
}

function DataModel.FindPathBFS(startGridId, targetGridId)
  local queue = {}
  local visited = {}
  local parent = {}
  table.insert(queue, startGridId)
  visited[startGridId] = true
  while 0 < #queue do
    local currentGridId = table.remove(queue, 1)
    local currentGridInfo = PlayerData:GetFactoryData(currentGridId, "MonopolyGameGridFactory")
    if currentGridInfo then
      if currentGridId == targetGridId then
        local path = {}
        local nodeId = currentGridId
        while nodeId do
          table.insert(path, nodeId)
          nodeId = parent[nodeId]
        end
        local reversedPath = {}
        for i = #path, 1, -1 do
          table.insert(reversedPath, path[i])
        end
        return reversedPath
      end
      local upGridId = currentGridInfo.upGrid
      if upGridId and upGridId ~= -1 and not visited[upGridId] then
        visited[upGridId] = true
        parent[upGridId] = currentGridId
        table.insert(queue, upGridId)
      end
      local rightGridId = currentGridInfo.rightGrid
      if rightGridId and rightGridId ~= -1 and not visited[rightGridId] then
        visited[rightGridId] = true
        parent[rightGridId] = currentGridId
        table.insert(queue, rightGridId)
      end
      local downGridId = currentGridInfo.downGrid
      if downGridId and downGridId ~= -1 and not visited[downGridId] then
        visited[downGridId] = true
        parent[downGridId] = currentGridId
        table.insert(queue, downGridId)
      end
      local leftGridId = currentGridInfo.leftGrid
      if leftGridId and leftGridId ~= -1 and not visited[leftGridId] then
        visited[leftGridId] = true
        parent[leftGridId] = currentGridId
        table.insert(queue, leftGridId)
      end
    else
      print("***\232\183\175\229\190\132\229\135\186\233\148\153\239\188\140\230\163\128\230\159\165\230\160\188\229\173\144\233\133\141\231\189\174\239\188\154" .. tostring(currentGridId))
    end
  end
  return nil
end

function DataModel.FindPathDFS(startGridId, targetGridId)
  local visited = {}
  local path = {}
  local parent = {}
  
  local function dfs(currentGridId)
    visited[currentGridId] = true
    table.insert(path, currentGridId)
    if currentGridId == targetGridId then
      return path
    end
    local currentGridInfo = PlayerData:GetFactoryData(currentGridId)
    local neighbors = {
      currentGridInfo.upGrid,
      currentGridInfo.rightGrid,
      currentGridInfo.downGrid,
      currentGridInfo.leftGrid
    }
    for _, neighborId in ipairs(neighbors) do
      if neighborId and neighborId ~= -1 and not visited[neighborId] then
        parent[neighborId] = currentGridId
        local result = dfs(neighborId)
        if result then
          return result
        end
      end
    end
    table.remove(path)
    return nil
  end
  
  return dfs(startGridId)
end

function DataModel.GetARandomPath(gridId)
  local path = {}
  local count = math.random(1, 6)
  table.insert(path, tonumber(gridId))
  local nextId = tonumber(gridId)
  for i = 1, count do
    nextId = DataModel.GetNextGridId(nextId, path)
    table.insert(path, nextId)
  end
  return path
end

function DataModel.GetNextGridId(curGridId, path)
  local ca = PlayerData:GetFactoryData(curGridId, "MonopolyGameGridFactory")
  if not ca then
    return nil
  end
  local grids = {}
  table.insert(grids, ca.upGrid)
  table.insert(grids, ca.rightGrid)
  table.insert(grids, ca.downGrid)
  table.insert(grids, ca.leftGrid)
  local len = #grids
  for i = len, 2, -1 do
    local j = math.random(i)
    grids[i], grids[j] = grids[j], grids[i]
  end
  for i = 1, #grids do
    if grids[i] ~= nil and grids[i] ~= -1 and not table.contains(path, grids[i]) then
      return grids[i]
    end
  end
  for i = 1, #grids do
    if grids[i] ~= nil and grids[i] ~= -1 then
      return grids[i]
    end
  end
end

function DataModel.GetIsDieRoad(tile)
  local ca = PlayerData:GetFactoryData(tile, "MonopolyGameGridFactory")
  if not ca then
    return false
  end
  local existNum = 0
  if ca.upGrid ~= -1 and ca.upGrid ~= nil then
    existNum = existNum + 1
  end
  if ca.rightGrid ~= -1 and ca.rightGrid ~= nil then
    existNum = existNum + 1
  end
  if ca.downGrid ~= -1 and ca.downGrid ~= nil then
    existNum = existNum + 1
  end
  if ca.leftGrid ~= -1 and ca.leftGrid ~= nil then
    existNum = existNum + 1
  end
  return existNum < 2
end

function DataModel.CheckDirSelect(gridId)
  local ca = PlayerData:GetFactoryData(gridId, "MonopolyGameGridFactory")
  if not ca then
    return false
  end
  local existNum = 0
  if ca.upGrid ~= -1 and ca.upGrid ~= nil then
    existNum = existNum + 1
  end
  if ca.rightGrid ~= -1 and ca.rightGrid ~= nil then
    existNum = existNum + 1
  end
  if ca.downGrid ~= -1 and ca.downGrid ~= nil then
    existNum = existNum + 1
  end
  if ca.leftGrid ~= -1 and ca.leftGrid ~= nil then
    existNum = existNum + 1
  end
  return 2 < existNum
end

function DataModel.GetADirGridByNowId(nowId)
  local ca = PlayerData:GetFactoryData(nowId, "MonopolyGameGridFactory")
  if not ca then
    return 1
  end
  if ca.upGrid ~= nil and ca.upGrid ~= -1 then
    return 1
  end
  if ca.rightGrid ~= nil and ca.rightGrid ~= -1 then
    return 2
  end
  if ca.downGrid ~= nil and ca.downGrid ~= -1 then
    return 3
  end
  if ca.leftGrid ~= nil and ca.leftGrid ~= -1 then
    return 4
  end
  return 1
end

function DataModel.GetDirByNowAndLastId(nowId, lastId)
  local ca = PlayerData:GetFactoryData(lastId, "MonopolyGameGridFactory")
  if not ca then
    return 1
  end
  if ca.upGrid ~= nil and ca.upGrid ~= -1 and ca.upGrid == nowId then
    return 1
  end
  if ca.rightGrid ~= nil and ca.rightGrid ~= -1 and ca.rightGrid == nowId then
    return 2
  end
  if ca.downGrid ~= nil and ca.downGrid ~= -1 and ca.downGrid == nowId then
    return 3
  end
  if ca.leftGrid ~= nil and ca.leftGrid ~= -1 and ca.leftGrid == nowId then
    return 4
  end
  return 1
end

function DataModel.FaceToMainCamera(mainCamera, objectTrans)
  if not mainCamera or not objectTrans then
    return Quaternion.Euler(0, 0, 0)
  end
  local direction = Vector3(mainCamera.transform.position.x - objectTrans.transform.position.x, 0, mainCamera.transform.position.z - objectTrans.transform.position.z)
  direction = direction.normalized
  local forward = Vector3(0, 0, 1)
  local dotProduct = direction.x * forward.x + direction.z * forward.z
  local crossProduct = direction.x * forward.z - direction.z * forward.x
  local angle = math.deg(math.atan(crossProduct / dotProduct))
  if dotProduct < 0 then
    angle = angle + 180
  end
  angle = angle - 90 - 90
  local rotation = Quaternion.Euler(0, angle, 0)
  objectTrans.transform.rotation = rotation
end

function DataModel.SetUserMonopolyData(data)
  DataModel.userMonopolyData = data
end

function DataModel.AddUserDiceNum(num)
  if not DataModel.userMonopolyData then
    return
  end
  DataModel.userMonopolyData.dice = DataModel.userMonopolyData.dice + num
  local limitNum = DataModel.GetNormalDiceLimitNum()
  if limitNum < DataModel.userMonopolyData.dice then
    DataModel.userMonopolyData.dice = limitNum
  end
end

function DataModel.GetNormalDiceLimitNum()
  local maxNum = 0
  local monopolyInfo = PlayerData:GetFactoryData(PlayerData.GetMonopolyControlId(), "MapControlFactory")
  if monopolyInfo then
    maxNum = monopolyInfo.diceLimit or 0
  end
  return maxNum
end

function DataModel.GetUserDiceNum()
  if not DataModel.userMonopolyData then
    return 0
  end
  return DataModel.userMonopolyData.dice or 0
end

function DataModel.GetInitStep()
  if not DataModel.userMonopolyData then
    return 0
  end
  return DataModel.userMonopolyData.step
end

function DataModel.MinusOneStep()
  if not DataModel.userMonopolyData then
    return
  end
  DataModel.userMonopolyData.step = DataModel.userMonopolyData.step - 1
  DataModel.userMonopolyData.step = DataModel.userMonopolyData.step < 0 and 0 or DataModel.userMonopolyData.step
end

function DataModel.SetGridCompleteState(gridId, state)
  if not DataModel.userMonopolyData or not DataModel.userMonopolyData.map then
    return
  end
  if not DataModel.userMonopolyData.map[gridId] then
    return
  end
  DataModel.userMonopolyData.map[gridId].com = state
end

function DataModel.GetGridCompleteState(gridId)
  if not DataModel.userMonopolyData or not DataModel.userMonopolyData.map then
    return 0
  end
  if not DataModel.userMonopolyData.map[gridId] then
    return 0
  end
  return DataModel.userMonopolyData.map[gridId].com
end

function DataModel.GetGridInvestNum(gridId)
  if not DataModel.userMonopolyData or not DataModel.userMonopolyData.map then
    return 0
  end
  if not DataModel.userMonopolyData.map[gridId] then
    return 0
  end
  if not DataModel.userMonopolyData.map[gridId].out_info then
    return 0
  end
  return DataModel.userMonopolyData.map[gridId].out_info.invest_time or 0
end

function DataModel.ResetGridInvestNum(gridId)
  if not DataModel.userMonopolyData or not DataModel.userMonopolyData.map then
    return
  end
  if not DataModel.userMonopolyData.map[gridId] then
    return
  end
  if not DataModel.userMonopolyData.map[gridId].out_info then
    return
  end
  DataModel.userMonopolyData.map[gridId].out_info.invest_time = 0
end

function DataModel.AddGridInvestNum(gridId)
  if not (DataModel.userMonopolyData and DataModel.userMonopolyData.map and DataModel.userMonopolyData.map[gridId]) or not DataModel.userMonopolyData.map[gridId].out_info then
    return
  end
  DataModel.userMonopolyData.map[gridId].out_info.invest_time = DataModel.userMonopolyData.map[gridId].out_info.invest_time or 0
  DataModel.userMonopolyData.map[gridId].out_info.invest_time = DataModel.userMonopolyData.map[gridId].out_info.invest_time + 1
end

function DataModel.GetGridInvestMoney(gridId)
  if not DataModel.userMonopolyData or not DataModel.userMonopolyData.map then
    return 0
  end
  if not DataModel.userMonopolyData.map[gridId] or not DataModel.userMonopolyData.map[gridId].out_info then
    return 0
  end
  return DataModel.userMonopolyData.map[gridId].out_info.coin
end

function DataModel.AddGridInvestMoney(gridId, money)
  if not DataModel.userMonopolyData or not DataModel.userMonopolyData.map then
    return
  end
  if not DataModel.userMonopolyData.map[gridId] or not DataModel.userMonopolyData.map[gridId].out_info then
    return
  end
  DataModel.userMonopolyData.map[gridId].out_info.coin = DataModel.userMonopolyData.map[gridId].out_info.coin or 0
  DataModel.userMonopolyData.map[gridId].out_info.coin = DataModel.userMonopolyData.map[gridId].out_info.coin + money
end

function DataModel.GetTelecontrolDiceNum()
  if not DataModel.userMonopolyData then
    return 0
  end
  return DataModel.userMonopolyData.telecontrol
end

function DataModel.AddTelecontrolDiceNum(num)
  if not DataModel.userMonopolyData then
    return
  end
  DataModel.userMonopolyData.telecontrol = DataModel.userMonopolyData.telecontrol or 0
  DataModel.userMonopolyData.telecontrol = DataModel.userMonopolyData.telecontrol + num
end

function DataModel.GetGetBtnStateTypeByTime(index, startTime, endTime)
  if not DataModel.userMonopolyData then
    return 2
  end
  if DataModel.userMonopolyData.daily_subsidy and table.contains(DataModel.userMonopolyData.daily_subsidy, index) then
    return 1
  end
  local lgTimeTable = TimeUtil:GetLogicServerDayTable()
  local hour = lgTimeTable.hour
  local min = lgTimeTable.minute
  local startHour = tonumber(string.sub(startTime, 1, 2))
  local startMin = tonumber(string.sub(startTime, 4, 5))
  local endHour = tonumber(string.sub(endTime, 1, 2))
  local endMin = tonumber(string.sub(endTime, 4, 5))
  if hour < startHour or hour == startHour and min < startMin then
    return 2
  end
  if hour > endHour or hour == endHour and min > endMin then
    return 3
  end
  return 4
end

function DataModel.GetSmallBoxDifficulty()
  if not DataModel.userMonopolyData then
    return 0
  end
  return DataModel.userMonopolyData.box_difficulty or 0
end

function DataModel.SetSmallBoxDifficulty(difficulty)
  if not DataModel.userMonopolyData then
    return
  end
  DataModel.userMonopolyData.box_difficulty = difficulty
end

function DataModel.GetSmallBoxFightNum()
  if not DataModel.userMonopolyData then
    return
  end
  return DataModel.userMonopolyData.attach_box_num or 0
end

function DataModel.SetSmallBoxFightNum(num)
  if not DataModel.userMonopolyData then
    return
  end
  DataModel.userMonopolyData.attach_box_num = num
end

function DataModel.GetFightNumIsEnough()
  if not DataModel.userMonopolyData or not DataModel.userMonopolyData.monopoly_id then
    return false
  end
  local mp = PlayerData:GetFactoryData(DataModel.userMonopolyData.monopoly_id, "MonopolyGameMapFactory")
  if not mp then
    return false
  end
  local hasFightNum = DataModel.GetSmallBoxFightNum() or 0
  local limitNum = mp.boxFightLimit or 0
  return hasFightNum < limitNum
end

function DataModel.SetFightNumIsMax()
  if not DataModel.userMonopolyData or not DataModel.userMonopolyData.monopoly_id then
    return
  end
  local mp = PlayerData:GetFactoryData(DataModel.userMonopolyData.monopoly_id, "MonopolyGameMapFactory")
  if not mp then
    return
  end
  DataModel.userMonopolyData.attach_box_num = mp.boxFightLimit or 0
end

function DataModel.GetBackItemsDic()
  DataModel.userMonopolyData = DataModel.userMonopolyData or {}
  return DataModel.userMonopolyData.mpy_items
end

function DataModel.GetBackItemsList()
  local list = {}
  DataModel.userMonopolyData = DataModel.userMonopolyData or {}
  if DataModel.userMonopolyData.mpy_items then
    for id, v in pairs(DataModel.userMonopolyData.mpy_items) do
      if v and v.num > 0 then
        local t = {}
        t.id = id
        t.num = v.num
        table.insert(list, t)
      end
    end
  end
  table.sort(list, function(a, b)
    return a.id < b.id
  end)
  return list
end

function DataModel.GetAllItemsCount()
  local count = 0
  DataModel.userMonopolyData = DataModel.userMonopolyData or {}
  if DataModel.userMonopolyData.mpy_items then
    for id, v in pairs(DataModel.userMonopolyData.mpy_items) do
      if v and 0 < v.num then
        count = count + v.num
      end
    end
  end
  return count
end

function DataModel.GetItemHasLimitCount()
  local monopolyInfo = PlayerData:GetFactoryData(PlayerData.GetMonopolyControlId(), "MapControlFactory")
  if not monopolyInfo then
    return 0
  end
  return monopolyInfo.itemLimit or 0
end

function DataModel.EditBackItemNum(itemId, num)
  if not DataModel.userMonopolyData or not DataModel.userMonopolyData.mpy_items then
    return
  end
  if not DataModel.userMonopolyData.mpy_items[itemId] then
    return
  end
  DataModel.userMonopolyData.mpy_items[itemId].num = DataModel.userMonopolyData.mpy_items[itemId].num + num
end

function DataModel.AddBackItemNum(itemId, num)
  DataModel.userMonopolyData = DataModel.userMonopolyData or {}
  DataModel.userMonopolyData.mpy_items = DataModel.userMonopolyData.mpy_items or {}
  local isItemExits = false
  if table.count(DataModel.userMonopolyData.mpy_items) > 0 then
    for id, v in pairs(DataModel.userMonopolyData.mpy_items) do
      if tostring(id) == tostring(itemId) then
        v.num = v.num + num
        isItemExits = true
        break
      end
    end
  end
  if not isItemExits then
    DataModel.userMonopolyData.mpy_items[tostring(itemId)] = {num = num}
  end
end

function DataModel.GetItemUseRemainTime()
  if not DataModel.userMonopolyData then
    return 0
  end
  DataModel.userMonopolyData.item_time = DataModel.userMonopolyData.item_time or 0
  local monopolyInfo = PlayerData:GetFactoryData(PlayerData.GetMonopolyControlId(), "MapControlFactory")
  if not monopolyInfo then
    return 0
  end
  local limitTime = monopolyInfo.itemUseLimit or 0
  local remainTime = limitTime - DataModel.userMonopolyData.item_time
  return 0 <= remainTime and remainTime or 0
end

function DataModel.GetItemUseLimitTime()
  if not DataModel.userMonopolyData then
    return 0
  end
  local monopolyInfo = PlayerData:GetFactoryData(PlayerData.GetMonopolyControlId(), "MapControlFactory")
  if not monopolyInfo then
    return 0
  end
  return monopolyInfo.itemUseLimit or 0
end

function DataModel.GetItemUsedTime()
  if not DataModel.userMonopolyData then
    return 0
  end
  return DataModel.userMonopolyData.item_time or 0
end

function DataModel.AddItemUseTime()
  if not DataModel.userMonopolyData then
    return
  end
  DataModel.userMonopolyData.item_time = DataModel.userMonopolyData.item_time or 0
  DataModel.userMonopolyData.item_time = DataModel.userMonopolyData.item_time + 1
end

function DataModel.ResetItemUseTime()
  if not DataModel.userMonopolyData then
    return
  end
  DataModel.userMonopolyData.item_time = 0
end

function DataModel.GetBuffList()
  local list = {}
  if DataModel.userMonopolyData and DataModel.userMonopolyData.effect_items then
    for typeStr, itemDic in pairs(DataModel.userMonopolyData.effect_items) do
      if itemDic then
        for itemId, v in pairs(itemDic) do
          if v.time > 0 then
            local t = {}
            t.itemId = itemId
            t.time = v.time
            table.insert(list, t)
          end
        end
      end
    end
  end
  return list
end

function DataModel.MinusABuffTime(typeStr)
  if not DataModel.userMonopolyData or not DataModel.userMonopolyData.effect_items then
    return false
  end
  local needRefresh = false
  if DataModel.userMonopolyData.effect_items[typeStr] then
    for itemId, v in pairs(DataModel.userMonopolyData.effect_items[typeStr]) do
      if v and v.time > 0 then
        v.time = v.time - 1
        needRefresh = true
      end
    end
  end
  return needRefresh
end

function DataModel.GetIsHasBuffItemByType(typeStr)
  if not DataModel.userMonopolyData or not DataModel.userMonopolyData.effect_items then
    return false
  end
  if DataModel.userMonopolyData.effect_items[typeStr] then
    for itemId, v in pairs(DataModel.userMonopolyData.effect_items[typeStr]) do
      if v and v.time > 0 then
        return true
      end
    end
  end
  return false
end

function DataModel.SetServerMonopolyData(data)
  DataModel.serverMonopolyData = data
end

function DataModel.GetPlayerList()
  local list = {}
  local my = {}
  my.uid = PlayerData:GetUserInfo().uid
  my.avatar = PlayerData:GetUserInfo().avatar
  my.lv = PlayerData:GetUserInfo().lv
  my.role_name = PlayerData:GetUserInfo().role_name
  table.insert(list, my)
  if DataModel.serverMonopolyData and DataModel.serverMonopolyData.user then
    for uid, v in pairs(DataModel.serverMonopolyData.user) do
      local t = {}
      t.uid = uid
      t.avatar = v.avatar
      t.lv = v.lv
      t.role_name = v.role_name
      table.insert(list, t)
    end
  end
  return list
end

function DataModel.SetInterfaceData(data)
  DataModel.interfaceData = data
end

function DataModel.GetCityGridOutputNum(gridId)
  if not DataModel.interfaceData or not DataModel.interfaceData[gridId] then
    return 0
  end
  local num = DataModel.interfaceData[gridId].num or 0
  return 0 < num and num or 0
end

function DataModel.SetCityGridOutputNum(gridId, num)
  if not DataModel.interfaceData and DataModel.interfaceData[gridId] then
    return
  end
  DataModel.interfaceData[gridId].num = num
end

function DataModel.GetInterfaceIsfull()
  return DataModel.interfaceIsfull
end

function DataModel.SetInterfaceIsfull(isfull)
  DataModel.interfaceIsfull = isfull
end

function DataModel.GetGridList()
  return DataModel.gridList
end

function DataModel.SetGridList(gridList)
  DataModel.gridList = gridList
end

function DataModel.GetMapGridInfo(id)
  DataModel.gridList = DataModel.gridList or {}
  for i, v in pairs(DataModel.gridList) do
    if v.id == id then
      return v
    end
  end
  return nil
end

function DataModel.SetOtherPlayers(data)
  DataModel.otherPlayers = data
end

function DataModel.DestroyAllOtherPlayers()
  if DataModel.otherPlayers then
    for _, v in pairs(DataModel.otherPlayers) do
      if v.roleGO then
        Object.Destroy(v.roleGO)
      end
      if v.headInfo and v.headInfo.headObj then
        Object.Destroy(v.headInfo.headObj)
      end
    end
    DataModel.otherPlayers = {}
  end
end

function DataModel.MoveByPathId(playerId, pathId, lastPathId)
  DataModel.otherPlayers = DataModel.otherPlayers or {}
  local otherPlayer = DataModel.otherPlayers[playerId]
  if not otherPlayer then
    return
  end
  local gridInfo = DataModel.GetMapGridInfo(pathId)
  if not gridInfo then
    return
  end
  otherPlayer.curGridId = pathId
  local dir = lastPathId == 0 and DataModel.GetADirGridByNowId(pathId) or DataModel.GetDirByNowAndLastId(pathId, lastPathId)
  otherPlayer.roleGO.transform.localEulerAngles = Vector3(0, (dir - 1) * 90, 0)
  local buffGodPar = otherPlayer.roleGO.transform:Find("BuffGodPar").transform
  if otherPlayer.headInfo and otherPlayer.headInfo.headObj then
    DataModel.SetObjRotationByDir(otherPlayer.headInfo.headObj, dir)
    DataModel.SetObjRotationByDir(buffGodPar, dir)
  end
  otherPlayer.targetPos = Vector3(gridInfo.x, 0, gridInfo.y)
  otherPlayer.moveDir = (otherPlayer.targetPos - otherPlayer.roleGO.transform.position).normalized
  otherPlayer.roleAni:Play("move")
  otherPlayer.roleStatus = 1
end

function DataModel.MoveArrived(playerId)
  local otherPlayer = DataModel.otherPlayers[playerId]
  if not otherPlayer then
    return
  end
  otherPlayer.roleStatus = 0
  local temp = otherPlayer.pathIds[1]
  local lastId = temp
  table.remove(otherPlayer.pathIds, 1)
  otherPlayer.curGridId = lastId
  if #otherPlayer.pathIds == 0 then
    otherPlayer.roleAni:Play("cease")
  else
    DataModel.MoveByPathId(playerId, otherPlayer.pathIds[1], lastId)
  end
end

function DataModel.OtherPlayerUpdate()
  if not DataModel.otherPlayers or table.count(DataModel.otherPlayers) == 0 then
    return
  end
  for id, value in pairs(DataModel.otherPlayers) do
    if value.roleGO ~= nil and value.roleStatus == 1 then
      value.roleGO.transform.localPosition = value.roleGO.transform.localPosition + value.moveDir * 0.1
      if 0.1 > (value.targetPos - value.roleGO.transform.localPosition).sqrMagnitude then
        value.roleStatus = 0
        value.roleGO.transform.localPosition = value.targetPos
        DataModel.MoveArrived(id)
      end
    end
  end
end

function DataModel.InitDayRefreshTime()
  local defaultConfig = PlayerData:GetFactoryData(99900001, "ConfigFactory")
  local h = tonumber(string.sub(defaultConfig.dailyRefreshTime, 1, 2))
  local m = tonumber(string.sub(defaultConfig.dailyRefreshTime, 4, 5))
  local s = tonumber(string.sub(defaultConfig.dailyRefreshTime, 7, 8))
  local targetTime = TimeUtil:GetNextSpecialTimeStamp(h, m, s)
  DataModel.nextRefreshTime = targetTime
end

function DataModel.SetBuffGodInfo(buffId, belong, uid, getTime)
  DataModel.buffGodInfo = {}
  DataModel.buffGodInfo.buffId = buffId
  DataModel.buffGodInfo.belong = belong
  DataModel.buffGodInfo.uid = uid
  DataModel.buffGodInfo.getTime = getTime
end

function DataModel.GetDiceDayRedDotState()
  local info = PlayerData:GetFactoryData(PlayerData.GetMonopolyControlId(), "MapControlFactory")
  if info then
    local timeList
    if PlayerData.AdministrationsAddictionHolidays == true then
      timeList = info.diceTimeWeekendNum
    else
      timeList = info.diceTimeNum
    end
    if timeList then
      for i = 1, #timeList do
        local t = timeList[i]
        local diceType = DataModel.GetGetBtnStateTypeByTime(i - 1, t.startTime, t.endTime)
        if diceType == 4 then
          return true
        end
      end
    end
  end
  return false
end

function DataModel.CheckItemUseRangeIsValid(itemId, uid, prefix)
  local ca = PlayerData:GetFactoryData(itemId, "ItemFactory")
  if not ca then
    return false
  end
  if ca.useRange == DataModel.useRange.effectNow then
    if ca.playerItemType == DataModel.buffType.bossHit then
      if prefix == DataModel.objNamePrefix.BOSS then
        return true
      else
        return false
      end
    else
      return tostring(uid) == PlayerData:GetUserInfo().uid
    end
  end
  local isPlayer = DataModel.CheckUnitIsPlayer(uid)
  if not isPlayer then
    return false
  end
  if ca.useRange == DataModel.useRange.player then
    return true
  end
  if ca.useRange == DataModel.useRange.oneSelf then
    return tostring(uid) == PlayerData:GetUserInfo().uid
  end
  if ca.useRange == DataModel.useRange.otherPlayer then
    if tostring(uid) == PlayerData:GetUserInfo().uid then
      return false
    end
    return true
  end
  if ca.useRange == DataModel.useRange.grid then
    local isValid = false
    if DataModel.userMonopolyData then
      local curGridId = DataModel.userMonopolyData.loc
      local gridCA = PlayerData:GetFactoryData(curGridId, "MonopolyGameGridFactory")
      if gridCA and not gridCA.isRank and tostring(uid) == PlayerData:GetUserInfo().uid then
        isValid = true
      end
    end
    return isValid
  end
  return false
end

function DataModel.CheckUnitIsPlayer(id)
  if tostring(id) == PlayerData:GetUserInfo().uid then
    return true
  end
  if not DataModel.serverMonopolyData or not DataModel.serverMonopolyData.user then
    return false
  end
  for uid, _ in pairs(DataModel.serverMonopolyData.user) do
    if tostring(uid) == tostring(id) then
      return true
    end
  end
  return false
end

function DataModel.GetInvestMaxTime()
  if not DataModel.userMonopolyData or not DataModel.userMonopolyData.monopoly_id then
    return 0
  end
  local mp = PlayerData:GetFactoryData(DataModel.userMonopolyData.monopoly_id, "MonopolyGameMapFactory")
  if not mp then
    return 0
  end
  local baseNum = mp.investLimit or 0
  local addNum = 0
  if DataModel.userMonopolyData and DataModel.userMonopolyData.effect_items and DataModel.userMonopolyData.effect_items[DataModel.buffType.investNum] then
    for itemId, v in pairs(DataModel.userMonopolyData.effect_items[DataModel.buffType.investNum]) do
      if v and 0 < v.time then
        local ca = PlayerData:GetFactoryData(itemId, "ItemFactory")
        if ca then
          addNum = ca.playerItemValue or 0
        end
      end
    end
  end
  return baseNum + addNum
end

function DataModel.MinusBuffTrapTime(gridId)
  DataModel.buffEffectObjs = DataModel.buffEffectObjs or {}
  if not DataModel.buffEffectObjs[gridId] then
    return
  end
  DataModel.buffEffectObjs[gridId].time = DataModel.buffEffectObjs[gridId].time - 1
  if DataModel.buffEffectObjs[gridId].time <= 0 then
    DataModel.RemoveMapBuffEffectObj(gridId)
  end
end

function DataModel.CreateMapBuffEffectObj(gridId, itemId, time)
  if not (gridId and itemId) or not time then
    return
  end
  DataModel.mapGridObjs = DataModel.mapGridObjs or {}
  local par = DataModel.mapGridObjs[gridId]
  if not par then
    return
  end
  DataModel.buffEffectObjs = DataModel.buffEffectObjs or {}
  if DataModel.buffEffectObjs[gridId] then
    return
  end
  local prefabPath = "UI/Monopoly/monopolyTrap_Test"
  local ca = PlayerData:GetFactoryData(itemId, "ItemFactory")
  if ca and not string.nilorempty(ca.mapShow) then
    prefabPath = ca.mapShow
  end
  local obj = View.self:GetRes(prefabPath, par.transform)
  if obj then
    local t = {}
    t.obj = obj
    t.gridId = gridId
    t.itemId = itemId
    t.time = time
    DataModel.buffEffectObjs[gridId] = t
  end
end

function DataModel.RemoveMapBuffEffectObj(gridId)
  DataModel.buffEffectObjs = DataModel.buffEffectObjs or {}
  if not DataModel.buffEffectObjs[gridId] then
    return
  end
  local obj = DataModel.buffEffectObjs[gridId].obj
  if obj then
    Object.Destroy(obj)
  end
  DataModel.buffEffectObjs[gridId] = nil
end

function DataModel.CheckIsTrapTrigger_Stop(gridId)
  if not DataModel.buffEffectObjs then
    return false
  end
  if not DataModel.buffEffectObjs[gridId] then
    return false
  end
  local itemId = DataModel.buffEffectObjs[gridId].itemId
  if not itemId then
    return false
  end
  local ca = PlayerData:GetFactoryData(itemId, "ItemFactory")
  if not ca then
    return false
  end
  if ca.playerItemType == DataModel.buffType.stop then
    return true
  end
  return false
end

function DataModel.CheckIsTrapTrigger_Return(gridId)
  if not DataModel.buffEffectObjs then
    return false
  end
  if not DataModel.buffEffectObjs[gridId] then
    return false
  end
  local itemId = DataModel.buffEffectObjs[gridId].itemId
  if not itemId then
    return false
  end
  local ca = PlayerData:GetFactoryData(itemId, "ItemFactory")
  if not ca then
    return false
  end
  if ca.playerItemType == DataModel.buffType.return_ then
    return true
  end
  return false
end

function DataModel.CheckIsTrapTrigger_Go(gridId)
  if not DataModel.buffEffectObjs then
    return false
  end
  if not DataModel.buffEffectObjs[gridId] then
    return false
  end
  local itemId = DataModel.buffEffectObjs[gridId].itemId
  if not itemId then
    return false
  end
  local ca = PlayerData:GetFactoryData(itemId, "ItemFactory")
  if not ca then
    return false
  end
  if ca.playerItemType == DataModel.buffType.go then
    return true
  end
  return false
end

function DataModel.GetMousePos()
  local minScale = math.min(GameSetting.scaleWidth, GameSetting.scaleHeight)
  local position = Input.mousePosition
  position = Vector3((position.x - Screen.width * 0.5) / minScale, (position.y - Screen.height * 0.5) / minScale, position.z)
  return position
end

function DataModel.RemoveAMovePathId()
  if DataModel.autoPathIds and #DataModel.autoPathIds > 0 then
    table.remove(DataModel.autoPathIds, 1)
  end
end

function DataModel.GetPlayerTypeByUid(uid)
  local isPlayer = DataModel.CheckUnitIsPlayer(uid)
  if not isPlayer then
    return 0
  end
  if uid == PlayerData:GetUserInfo().uid then
    return 1
  end
  return 2
end

function DataModel.ShowPlayerSelectEffect(obj, id)
  if not obj or not id then
    return
  end
  local blue = obj.transform:Find("M_Monopoly_Train_WYH_01_animation/M_Monopoly_Train_WYH_Dummy02/UI_Ring_blue_01")
  local pink = obj.transform:Find("M_Monopoly_Train_WYH_01_animation/M_Monopoly_Train_WYH_Dummy02/UI_Ring_pink_01")
  if blue and pink then
    local playerType = DataModel.GetPlayerTypeByUid(id)
    if playerType ~= 0 then
      if playerType == 1 then
        blue.gameObject:SetActive(true)
        pink.gameObject:SetActive(false)
      else
        blue.gameObject:SetActive(false)
        pink.gameObject:SetActive(true)
      end
    end
  end
  obj.transform.localScale = Vector3(1.1, 1.1, 1.1)
end

function DataModel.ResetPlayerSelectEffect(obj)
  if not obj then
    return
  end
  local blue = obj.transform:Find("M_Monopoly_Train_WYH_01_animation/M_Monopoly_Train_WYH_Dummy02/UI_Ring_blue_01")
  local pink = obj.transform:Find("M_Monopoly_Train_WYH_01_animation/M_Monopoly_Train_WYH_Dummy02/UI_Ring_pink_01")
  if blue and pink then
    blue.gameObject:SetActive(false)
    pink.gameObject:SetActive(false)
  end
  obj.transform.localScale = Vector3(0.9, 0.9, 0.9)
end

function DataModel.GetBoxBossServerInfo()
  if not DataModel.serverMonopolyData or not DataModel.serverMonopolyData.boss then
    return nil
  end
  local t = {}
  for bossId, v in pairs(DataModel.serverMonopolyData.boss) do
    if v then
      t.bossId = bossId
      t.hp = v.hp
      t.time = v.time
      break
    end
  end
  return t
end

function DataModel.SetBoxBossServerInfo(bossId, hp, time)
  if not DataModel.serverMonopolyData or not DataModel.serverMonopolyData.boss then
    return nil
  end
  if DataModel.serverMonopolyData.boss[bossId] then
    if hp then
      DataModel.serverMonopolyData.boss[bossId].hp = hp
    end
    if time then
      DataModel.serverMonopolyData.boss[bossId].time = time
    end
  end
end

function DataModel.GetBossMaxHp()
  if not DataModel.userMonopolyData or not DataModel.userMonopolyData.monopoly_id then
    return 0
  end
  local mp = PlayerData:GetFactoryData(DataModel.userMonopolyData.monopoly_id, "MonopolyGameMapFactory") or {}
  return mp.bossHP or 0
end

function DataModel.RefreshMapGradeInfo()
  local lv = PlayerData.GetUserMonopolyLv() or 1
  local exp = PlayerData.GetUserMonopolyExp() or 0
  local mapId = PlayerData.GetUserMonopolyId()
  local ca = PlayerData:GetFactoryData(mapId, "MonopolyGameMapFactory")
  if not ca then
    return
  end
  local gameGradeList = ca.gameGradeList or {}
  local count = #gameGradeList
  if count > lv + 1 then
    for i = lv + 1, count do
      if exp >= gameGradeList[i].exp then
        exp = exp - gameGradeList[i].exp
        if 0 <= exp then
          lv = lv + 1
        end
      else
        break
      end
    end
  end
  lv = count < lv and count or lv
  PlayerData.SetUserMonopolyLv(lv)
  PlayerData.SetUserMonopolyExp(exp)
end

function DataModel.SetObjRotationByDir(obj, dir)
  if not obj or not dir then
    return
  end
  if dir == 1 then
    obj.transform.localEulerAngles = Vector3(0, 0, 0)
  elseif dir == 2 then
    obj.transform.localEulerAngles = Vector3(0, -90, 0)
  elseif dir == 3 then
    obj.transform.localEulerAngles = Vector3(0, -180, 0)
  elseif dir == 4 then
    obj.transform.localEulerAngles = Vector3(0, 90, 0)
  end
end

function DataModel.PlaySound(id, isLoop)
  if not id then
    return
  end
  local sound = SoundManager:CreateSound(id)
  if sound then
    if isLoop then
      sound:SetIsLoop(true)
    end
    sound:Play()
  end
end

function DataModel.PlayTrainMoveSound()
  DataModel.StopIdleSound()
  if not DataModel.moveSound then
    DataModel.moveSound = SoundManager:CreateSound(DataModel.soundIds.trainMove)
  end
  if DataModel.moveSound then
    DataModel.moveSound:SetIsLoop(true)
    DataModel.moveSound:Play()
  end
end

function DataModel.PlayTrainIdleSound()
  DataModel.StopMoveSound()
  if not DataModel.idleSound then
    DataModel.idleSound = SoundManager:CreateSound(DataModel.soundIds.trainIdle)
  end
  if DataModel.idleSound then
    DataModel.idleSound:SetIsLoop(true)
    DataModel.idleSound:Play()
  end
end

function DataModel.StopMoveSound()
  if DataModel.moveSound then
    DataModel.moveSound:Stop()
    DataModel.moveSound = nil
  end
end

function DataModel.StopIdleSound()
  if DataModel.idleSound then
    DataModel.idleSound:Stop()
    DataModel.idleSound = nil
  end
end

function DataModel.ReleaseSound()
  DataModel.StopIdleSound()
  DataModel.StopMoveSound()
end

function DataModel.GetNegaDirNum(dir)
  if dir < 2 then
    return dir + 2
  end
  return dir - 2
end

function DataModel.CheckTimeIsOverAndBack()
  local ca = PlayerData:GetFactoryData(PlayerData.GetUserMonopolyId(), "MonopolyGameMapFactory")
  if not ca then
    return
  end
  local signEndTime = TimeUtil:TimeStamp(PlayerData.GetMonopolySignEnd()) or 0
  local nowTime = TimeUtil:GetServerTimeStamp() or 0
  local mpyEndTime = TimeUtil:TimeStamp(ca.endTime) or 0
  if nowTime >= mpyEndTime then
    CommonTips.OpenLoading(function()
      CBus:ChangeScene("Main")
    end)
  elseif signEndTime <= nowTime then
    CommonTips.OpenLoading(function()
      CBus:ChangeScene("Main")
    end)
  end
end

function DataModel.GetBuffGodTipsContent()
  local content = ""
  if not DataModel.buffGodInfo or not DataModel.buffGodInfo.buffId then
    return content
  end
  local eventInfo = PlayerData:GetFactoryData(DataModel.buffGodInfo.buffId, "MonopolyEventFactory")
  if not eventInfo then
    return content
  end
  if not string.nilorempty(DataModel.buffGodInfo.belong) then
    content = string.format(GetText(80609952), DataModel.buffGodInfo.belong, eventInfo.name)
  else
    content = string.format(GetText(80609951), eventInfo.name)
  end
  return content
end

function DataModel.GetGridEventInfo(girdId)
  if not DataModel.serverMonopolyData or not DataModel.serverMonopolyData.map then
    return nil, nil, nil, nil
  end
  local serverGrid = DataModel.serverMonopolyData.map[girdId]
  if not serverGrid then
    return nil, nil, nil, nil
  end
  local eventInfo = PlayerData:GetFactoryData(tonumber(serverGrid.event), "MonopolyEventFactory")
  return eventInfo, serverGrid.buffGod, serverGrid.boss, serverGrid.boxGw, serverGrid.trap
end

function DataModel.GetARandomDir(realDirTb)
  if not realDirTb then
    return nil
  end
  local tb = {}
  for dir, active in pairs(realDirTb) do
    if active then
      table.insert(tb, dir)
    end
  end
  local randomIndex = math.random(1, #tb)
  return tb[randomIndex]
end

function DataModel.ShowDragBuffInfo()
  if DataModel.curSelectItemId == nil then
    return
  end
  local ca = PlayerData:GetFactoryData(DataModel.curSelectItemId, "ItemFactory")
  if not ca then
    return
  end
  View.Group_ItemTest.Group_Drag.Group_BuffInfo:SetActive(true)
  View.Group_ItemTest.Group_Drag.Group_BuffInfo.Txt_Name:SetText(ca.name)
  View.Group_ItemTest.Group_Drag.Group_BuffInfo.Txt_Info:SetText(ca.des)
end

function DataModel.OpenDiceDayPanel()
  if not DataModel.userMonopolyData then
    return
  end
  UIManager:Open("UI/Monopoly/UI/Dice/DiceDay", Json.encode({
    subsidy = DataModel.userMonopolyData.daily_subsidy
  }))
end

function DataModel.OpenDiceRewardPanel(diceNum, itemId)
  UIManager:Open("UI/Monopoly/UI/Dice/DiceReward", Json.encode({diceNum = diceNum, itemId = itemId}))
end

function DataModel.GetBoxEnemyLimitExistCount()
  local limitCount = 0
  if DataModel.userMonopolyData then
    local mp = PlayerData:GetFactoryData(DataModel.userMonopolyData.monopoly_id, "MonopolyGameMapFactory")
    if mp then
      limitCount = mp.boxLimit or 0
    end
  end
  return limitCount
end

return DataModel
