local DataModel = require("UIWitchMain/UIWitchMainDataModel")
local Player = require("UIWitchMain/UIWitchMainPlayerController")
local View = require("UIWitchMain/UIWitchMainView")
local Float = require("UIWitchMain/UIWitchMainFloatController")
local tempGridPath = "WitchesPark/Prefab/WitchesPark_Grid"
local toWitchHouseUIPanel = "UI/Witches/Main/ToWitchHouse"
local tempFireworkFrame = 0
local tempFireworkFrameCounter = 60
local DataController = {}

local function isWitchHouseGrid(gridId)
  local parkMapCA = WitchData.GetParkMapCA()
  for _, gridInfo in ipairs(parkMapCA.toWitchHouseGridList or {}) do
    if tonumber(gridInfo.id) == tonumber(gridId) then
      return true
    end
  end
  return false
end

local function getWitchHouseId(gridId)
  local gridCA = PlayerData:GetFactoryData(gridId, "ParkGridFactory")
  local canMoveGridList = gridCA and gridCA.canMoveGridList or {}
  if table.count(canMoveGridList) == 1 then
    local nextGridId = canMoveGridList[1].id
    if isWitchHouseGrid(nextGridId) then
      return nextGridId
    end
  end
end

local function isWitchHouseCompleted()
  local playerGridId = WitchData.GetGridId()
  local parkMapCA = WitchData.GetParkMapCA()
  for _, gridInfo in ipairs(parkMapCA.toWitchHouseGridList or {}) do
    local witchHouseId = gridInfo.id
    if tonumber(playerGridId) == tonumber(witchHouseId) then
      return true
    end
    local gridData = WitchData.GetGridData(witchHouseId)
    if gridData and tonumber(gridData.com) == 1 then
      return true
    end
  end
  return false
end

local function processToWitchHouse()
  if not WitchData.inWitchMap then
    return
  end
  if DataModel.toWitchHouseCompleted == true then
    return
  end
  local playerGridId = WitchData.GetGridId()
  if getWitchHouseId(playerGridId) then
    local serverGridData = WitchData.GetGridData(WitchData.GetGridId())
    if serverGridData and tonumber(serverGridData.com) == 1 and UIManager:GetCurrentPanelURL() == DataModel.mainPanel then
      UIManager:Open(WitchData.GetUIPath(toWitchHouseUIPanel))
    end
  end
end

local function hideEventViewFloor()
  local curPlayerGrid = DataModel.gridList[WitchData.GetGridId()]
  if curPlayerGrid ~= nil then
    for _, v in pairs(DataModel.gridList) do
      if v.floor == curPlayerGrid.floor then
        if v.gridView ~= nil then
          v.gridView:SetActive(false)
        end
        if v.eventView ~= nil then
          v.eventView.gameObject:SetActive(false)
        end
        if v.listener ~= nil then
          v.listener.enabled = false
        end
      end
    end
  end
end

local function ShowNextGridTriggers(gridId, broom)
  local parkGrid = PlayerData:GetFactoryData(gridId)
  local canMoveGridList = {}
  for i, v in ipairs(parkGrid.canMoveGridList) do
    local gridData = DataModel.gridList[v.id]
    gridData.gridView.transform:Find("On/Effect_Default").gameObject:SetActive(true)
    gridData.gridView.transform:Find("On/Effect_Broom").gameObject:SetActive(false)
    table.insert(canMoveGridList, gridData)
  end
  if broom then
    for i, v in ipairs(parkGrid.canMoveExtraGridList) do
      local gridData = DataModel.gridList[v.id]
      gridData.gridView.transform:Find("On/Effect_Default").gameObject:SetActive(false)
      gridData.gridView.transform:Find("On/Effect_Broom").gameObject:SetActive(true)
      table.insert(canMoveGridList, gridData)
    end
  end
  for k, v in pairs(canMoveGridList) do
    local gridData = v
    gridData.listener.enabled = true
    gridData.gridView.transform:Find("On").gameObject:SetActive(true)
    gridData.gridView.transform:Find("Off").gameObject:SetActive(false)
  end
  hideEventViewFloor()
  return canMoveGridList
end

function DataController.CalculateNextTriggers(eventId)
  if DataModel.triggers then
    for k, v in pairs(DataModel.triggers) do
      v.gridView.transform:Find("On").gameObject:SetActive(false)
      v.gridView.transform:Find("Off").gameObject:SetActive(true)
      v.listener.enabled = false
    end
  end
  local triggers
  if eventId then
    triggers = ShowNextGridTriggers(WitchData.GetGridId(), true)
    for k, v in pairs(triggers) do
      local gridData = DataModel.gridList[v.id]
      gridData.isBroomSelect = true
      gridData.broomEventId = eventId
    end
    Player:PlayAnim(DataModel.animData.idle_broom)
  else
    triggers = ShowNextGridTriggers(WitchData.GetGridId())
  end
  DataModel.triggers = triggers
end

function DataController.UseItemCalculateNextTriggers(itemId)
  if DataModel.triggers then
    for k, v in pairs(DataModel.triggers) do
      v.listener.enabled = false
      v.gridView.transform:Find("On").gameObject:SetActive(false)
      v.gridView.transform:Find("Off").gameObject:SetActive(true)
    end
  end
  local triggers = ShowNextGridTriggers(WitchData.GetGridId(), true)
  for k, v in pairs(triggers) do
    local gridData = DataModel.gridList[v.id]
    gridData.isBroomSelect = true
    gridData.useBroomItemId = itemId
  end
  Player:PlayAnim(DataModel.animData.idle_broom)
  DataModel.triggers = triggers
end

function DataController.DealBroomEventMove(gridData, eventId)
  DataModel.LookAt(Player.view, gridData.gridView)
  Player:PlayAnim(DataModel.animData.move_broom)
  DOTweenTools.DOLocalMoveCallback(Player.view.transform, gridData.posX, DataModel.defualtAxisY, gridData.posY, 1, function()
    Player.view_broom:SetActive(false)
    Player:PlayAnim(DataModel.animData.idle)
    DOTweenTools.DOLocalRotate(Player.view.transform, 0, 0, 0, 0.25)
    if not string.nilorempty(eventId) then
      Player.MoveEndDealEvent(eventId)
    end
    DataController.CalculateNextTriggers()
  end)
end

local function onBtnClick(eventData, gridData)
  if gridData.isBroomSelect then
    if gridData.broomEventId then
      local function cb(json)
        gridData.isBroomSelect = nil
        
        gridData.broomEventId = nil
        DataController.DealBroomEventMove(gridData, json.dialogEvent)
      end
      
      WitchData.ReqDealBroomEvent(gridData.broomEventId, gridData.id, cb)
    elseif gridData.useBroomItemId then
      local function cb(json)
        gridData.useBroomItemId = nil
        
        gridData.broomEventId = nil
        DataController.DealBroomEventMove(gridData, json.dialogEvent)
      end
      
      WitchData.ReqUseBroomItem(gridData.useBroomItemId, 1, gridData.id, cb)
    end
  else
    local function cb(json)
      local eventId = json.dialogEvent and tonumber(json.dialogEvent)
      
      local function closeSealCallBack()
        if eventId and 0 < eventId then
          Player.MoveEndDealEvent(eventId)
        end
        DataController.CalculateNextTriggers()
      end
      
      if json.reward then
        local sealId = WitchData.GetSealReward(json.reward)
        if sealId then
          WitchData.OpenShowItem(json.reward, closeSealCallBack)
        else
          CommonTips.OpenShowItem(json.reward)
          closeSealCallBack()
        end
      else
        closeSealCallBack()
      end
    end
    
    Player:ReqMove(gridData, false, cb)
  end
end

local function updateCamera()
  if DataModel.isCameraFollowPlayer == true then
    if Player.view == nil then
      return
    end
    local playerPos = Player.view.transform.localPosition
    DataModel.mainCamera.transform.localPosition = Vector3(playerPos.x, DataModel.defaultCameraHeight, playerPos.z - DataModel.defaultCameraDistance)
    DataModel.mainCamera.transform.localEulerAngles = Vector3(DataModel.defualtCameraAngleX, 0, 0)
  end
end

function DataController.AddEventTrigger(gridData)
  local listener = gridData.gridView:GetComponent(typeof(CS.UnityEngine.EventSystems.EventTrigger))
  local entryDown = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryDown.eventID = CS.UnityEngine.EventSystems.EventTriggerType.PointerClick
  entryDown.callback:AddListener(function(eventData)
    onBtnClick(eventData, gridData)
  end)
  listener.triggers:Add(entryDown)
  listener.enabled = false
  return listener
end

local function generateFirework(id, posX, posY, posZ)
  local sealData = PlayerData:GetFactoryData(id, "ItemFactory")
  if not sealData then
    return
  end
  local curPlaySound = SoundManager:CreateSound(sealData.fireSound)
  if curPlaySound ~= nil then
    curPlaySound:Play()
  end
  if not string.nilorempty(sealData.fireDir) then
    local firework = View.self:GetRes(sealData.fireDir)
    if firework then
      firework.transform.position = Vector3(posX, posY, posZ)
      local fireworkView = firework:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
      table.insert(DataModel.fireworkViewList, fireworkView)
    end
  end
end

function DataController.CameraMoveInForFirework()
  View.Img_FireMask:SetActive(true)
  DataModel.isCameraFollowPlayer = false
  local mapData = WitchData.GetParkMapCA()
  local cameraRotateTime = DataModel.fireworkCameraMoveTime * 0.5
  DOTweenTools.DOLocalRotate(DataModel.mainCamera.transform, mapData.fireworkCameraAngleX, 0, 0, cameraRotateTime)
  DOTweenTools.DOLocalMoveCallback(DataModel.mainCamera.transform, mapData.fireworkCameraPosX, mapData.fireworkCameraPosY, mapData.fireworkCameraPosZ, DataModel.fireworkCameraMoveTime, function()
    DataModel.isFireworkAnimPlaying = true
  end)
end

local function cameraMoveOutForFirework()
  local playerPos = Player.view.transform.localPosition
  local x = playerPos.x
  local z = playerPos.z - DataModel.defaultCameraDistance
  local cameraRotateTime = DataModel.fireworkCameraMoveTime * 0.5
  DOTweenTools.DOLocalRotate(DataModel.mainCamera.transform, DataModel.defualtCameraAngleX, 0, 0, cameraRotateTime)
  DOTweenTools.DOLocalMoveCallback(DataModel.mainCamera.transform, x, DataModel.defaultCameraHeight, z, DataModel.fireworkCameraMoveTime, function()
    View.Img_FireMask:SetActive(false)
    DataModel.isCameraFollowPlayer = true
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Event/WitchesEnemy"), Json.encode({
      eventId = DataModel.bossEventId
    }))
  end)
end

local function updateFireworkAnim()
  if DataModel.isFireworkAnimPlaying then
    local index = table.count(DataModel.fireworkViewList)
    local isAllStopped = 0 < index
    for _, v in pairs(DataModel.fireworkViewList) do
      if v.isStopped ~= true then
        isAllStopped = false
        break
      end
    end
    if isAllStopped == true then
      tempFireworkFrame = 0
      for _, v in pairs(DataModel.fireworkViewList) do
        CS.UnityEngine.GameObject.Destroy(v.gameObject)
      end
      DataModel.fireworkViewList = {}
      DataModel.isFireworkAnimPlaying = false
      cameraMoveOutForFirework()
      return
    end
    tempFireworkFrame = tempFireworkFrame + 1
    local hasNext = false
    if 0 < index then
      index = index + 1
      if index <= WitchData.GetSealCount() then
        hasNext = true
      end
    end
    if index == 0 or hasNext == true and tempFireworkFrame > tempFireworkFrameCounter then
      tempFireworkFrame = 0
      if index == 0 then
        index = 1
      end
      local sealId = WitchData.GetUserSeal(index)
      local fireworkPosList = WitchData.GetParkMapCA().fireworkPositionList
      local fireworkPos = fireworkPosList[index]
      generateFirework(sealId, fireworkPos.x, fireworkPos.y, fireworkPos.z)
    end
  end
end

function DataController.GenerateGO(prefabPath, parent, gridId, localPos, rotation, scale)
  if string.nilorempty(prefabPath) == true then
    return nil
  end
  local obj = View.self:GetRes(prefabPath, parent)
  if 0 < gridId then
    obj.gameObject.name = "Grid|" .. gridId
  else
    obj.gameObject.name = "View"
  end
  obj.transform.localPosition = localPos
  obj.transform.eulerAngles = rotation
  obj.transform.localScale = scale
  return obj
end

function DataController:InitMap(mapData)
  DataModel.mainCamera = CS.UnityEngine.GameObject.Find("Main Camera")
  local gridPar = CS.UnityEngine.GameObject.Find("GRIDS_PAR")
  local playerGrid = PlayerData:GetFactoryData(WitchData.GetGridId(), "ParkGridFactory")
  local curFloor = playerGrid.floor
  if mapData then
    for k, v in pairs(mapData) do
      local parkGrid = PlayerData:GetFactoryData(k, "ParkGridFactory")
      local prefabPath = parkGrid.particlePath
      if string.nilorempty(prefabPath) == true then
        prefabPath = tempGridPath
      end
      local gridObj = self.GenerateGO(prefabPath, gridPar.transform, parkGrid.id, Vector3(parkGrid.x, DataModel.defualtAxisY, parkGrid.y), Vector3.zero, Vector3(parkGrid.clickX, parkGrid.clickY, parkGrid.clickZ))
      local gridData = {}
      gridData.id = parkGrid.id
      gridData.floor = parkGrid.floor
      gridData.posX = parkGrid.x
      gridData.posY = parkGrid.y
      gridData.gridView = gridObj
      if parkGrid.floor > 0 and curFloor < parkGrid.floor then
        local eventId = v.event and tonumber(v.event)
        if eventId then
          local eventData = PlayerData:GetFactoryData(eventId)
          gridData.eventId = eventId
          gridData.eventView = self.GenerateGO(eventData.resPath, gridObj.transform, 0, Vector3(0, 0.5, 0), Vector3.zero, Vector3(1, 1, 1))
        end
        gridData.listener = self.AddEventTrigger(gridData)
      else
        gridData.gridView:SetActive(false)
      end
      DataModel.gridList[parkGrid.id] = gridData
    end
  end
end

function DataController:ReqMap()
  local function cbSuccess(json)
    if json then
      WitchData.InitData(json)
      
      WitchData.SetGridId(json.user_loc)
      local server_map = json.map
      self:InitMap(server_map)
      Player:InitPlayer()
      Float:Init()
      local mapData = WitchData.GetParkMapCA()
      DataModel.float_moveNum = mapData.carMoveNum
      DataModel.move_consume = mapData.moveEnergy
      DataModel.animData.idle_broom = string.nilorempty(mapData.animBroomStand) and "stand_broom" or mapData.animBroomStand
      DataModel.animData.move_broom = string.nilorempty(mapData.animBroomWalk) and "walk_broom" or mapData.animBroomWalk
      DataModel.animData.move = mapData.animMove
      DataModel.animData.idle = mapData.animInitialStand
      for _, v in pairs(mapData.animStand) do
        table.insert(DataModel.animData.standList, v.name)
      end
      DataController.CalculateNextTriggers()
      DataModel.isInited = true
      local sealId = json.other_seal and json.other_seal[1]
      if sealId then
        UIManager:Open(WitchData.GetUIPath("UI/Witches/Main/Seal"), nil, function()
          DataController.DealEventAfterInMap(json.user_loc)
        end)
      else
        DataController.DealEventAfterInMap(json.user_loc)
      end
      local selectInfo = json.temp_select and json.temp_select.item_guka
      if selectInfo and 0 < #selectInfo then
        UIManager:Open(WitchData.GetUIPath("UI/Witches/Guka/GuKaChoose"), Json.encode({rewardType = "item_guka"}))
      end
      DataModel.RefreshOnShow()
      DataModel.toWitchHouseCompleted = isWitchHouseCompleted()
    end
  end
  
  local function cbFail(json)
  end
  
  Net:SendProto("activity.witches_info", cbSuccess, cbFail, WitchData.GetActivityId())
end

function DataController.DealEventAfterInMap(gridId)
  local gridData = WitchData.GetGridData(gridId)
  local com = gridData and gridData.com
  if com and tonumber(com) == 1 then
    local gridCA = PlayerData:GetFactoryData(WitchData.GetGridId(), "ParkGridFactory")
    if gridCA.FerrisWheel and gridCA.FerrisWheel > 0 then
      local activityId = PlayerData:GetFactoryData(gridCA.FerrisWheel).ferrisWheelEntrance
      UIManager:Open("UI/Activity/ActivitySignBattle/ActivitySignBattleLevelWensheng", Json.encode({activityId = activityId}))
    end
    return
  end
  local witchesData = WitchData.GetWitchesData()
  local eventStrInfo
  if witchesData.end_events and 0 < table.count(witchesData.end_events) then
    eventStrInfo = witchesData.end_events[table.count(witchesData.end_events)]
  else
    eventStrInfo = witchesData.start_id
  end
  if not string.nilorempty(eventStrInfo) then
    local parkMapCA = WitchData.GetParkMapCA()
    local splitT = string.split(eventStrInfo, ":")
    local eventId = splitT[1]
    if #splitT == 2 then
      local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
      if eventCA.battleType ~= "Boss" then
        local battleResult = splitT[2]
        if battleResult == "win" and 0 < eventCA.sucid then
          eventId = eventCA.sucid
        elseif battleResult == "lose" and 0 < eventCA.failid then
          eventId = eventCA.failid
        end
      end
    elseif #splitT == 3 then
      local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
      local battleResult = splitT[3]
      if battleResult == "win" then
        local levelIndex = tonumber(splitT[2]) + 1
        if levelIndex == #eventCA.levelIDList and 0 < eventCA.sucid then
          eventId = eventCA.sucid
        end
      elseif battleResult == "lose" and 0 < eventCA.failid then
        eventId = eventCA.failid
      end
    end
    if eventId then
      local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
      local mod = eventCA.mod
      if mod == "\233\173\148\229\165\179\229\175\185\232\175\157" then
        local gridCA = PlayerData:GetFactoryData(WitchData.GetGridId(), "ParkGridFactory")
        if gridCA.FerrisWheel and gridCA.FerrisWheel > 0 and PlayerData:GetPlayerPrefs("int", "WitchWheelDialog") == 1 then
          local activityId = PlayerData:GetFactoryData(PlayerData:GetFactoryData(gridId).FerrisWheel).ferrisWheelEntrance
          UIManager:Open("UI/Activity/ActivitySignBattle/ActivitySignBattleLevelWensheng", Json.encode({eventId = eventId, activityId = activityId}))
          return
        end
      end
      Player.DealEvent(eventId)
    end
  end
end

function DataController:ReqMoveForWitchHouse()
  local witchHouseId = getWitchHouseId(WitchData.GetGridId())
  local gridData = witchHouseId and DataModel.gridList[witchHouseId]
  if gridData ~= nil then
    DataModel.toWitchHouseCompleted = true
    onBtnClick(nil, gridData)
  end
end

function DataController:SetCameraActive(isActive)
  if MainManager.bgSceneName == WitchData.GetSceneName() and DataModel.mainCamera then
    DataModel.mainCamera:GetComponent(typeof(CS.UnityEngine.Camera)).enabled = isActive
  end
end

function DataController:Init()
  self:ReqMap()
end

function DataController:OnUpdate()
  updateCamera()
  Player:OnUpdate()
  Float:OnUpdate()
  processToWitchHouse()
  updateFireworkAnim()
end

function DataController:Clear()
  if DataModel.isInited == true then
    DataModel:Clear()
    Player:Clear()
    Float:Clear()
  end
  DataModel.isInited = false
  WitchData.ClearData()
end

return DataController
