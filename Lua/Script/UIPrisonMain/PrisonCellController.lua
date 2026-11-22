local Controller = {}
local this = Controller

function Controller.InitScene()
  PrisonData.curCellRoomPlaceId = 81500009
  local stationPlace = PlayerData:GetFactoryData(81500009, "HomeStationPlaceFactory")
  HomeStationStoreManager:Create(stationPlace.resId, stationPlace.id)
  local coachCA = PlayerData:GetFactoryData(stationPlace.resId, "HomeCoachFactory")
  HomeStationStoreManager:Load(coachCA.defaultTemplate)
  for i, v in pairs(stationPlace.npcList) do
    HomeStationStoreManager:CreateCustom(v.id, 0, v.isRandom, v.npcX, v.npcZ, v.tree)
  end
end

function Controller.InitRoom(cellRoomIndex, areaIndex, uiRoot)
  local cellRoomList = PrisonData.GetCellRoomList() or {}
  local roomCount = table.count(cellRoomList)
  if cellRoomIndex < 1 or cellRoomIndex > roomCount then
    return
  end
  local room = HomeManager:GetCurRoom()
  for i, placedFur in pairs(PrisonData.cellFurList) do
    room:RemoveFurniture(placedFur)
  end
  PrisonData.cellFurList = {}
  for i, character in pairs(PrisonData.cellPrisonerList) do
    if character then
      HomeStationStoreManager:RecycleCustom(character)
    end
  end
  PrisonData.cellPrisonerList = {}
  local roomData = cellRoomList[tostring(cellRoomIndex)]
  for areaId, furList in pairs(roomData) do
    this.InitPlacedFur(cellRoomIndex, areaId)
    this.InitPrisoner(cellRoomIndex, areaId)
  end
  this.InitIllBubble(cellRoomIndex, uiRoot)
  PrisonData.SetCurCellRoomIndex(cellRoomIndex)
  this.ChangeArea(areaIndex)
end

local CacheLoadBubble = {}
local IllBubblePosCfg = {
  {
    offsetX = 0,
    offsetY = 3,
    offsetZ = -1.4
  },
  {
    offsetX = 0,
    offsetY = 6,
    offsetZ = -1.4
  }
}

function Controller.InitIllBubble(cellRoomIndex, uiRoot)
  cellRoomIndex = tostring(cellRoomIndex)
  local illList = PrisonData.GetIllPrisonerInCell(cellRoomIndex)
  for i, bubble in pairs(CacheLoadBubble) do
    local go = bubble.gameObject
    if go and not go:IsNull() then
      go:SetActive(illList[i])
    end
  end
  for i, v in pairs(illList) do
    local bubble = CacheLoadBubble[i]
    local go = bubble and bubble.gameObject
    if (not go or go:IsNull()) and uiRoot then
      go = uiRoot:GetRes("UI/Prison/Main/PrisonAccomodation/Group_MedicalBtn")
      if go and not go:IsNull() then
        local canvas = go.transform:GetComponent(typeof(CS.UnityEngine.Canvas))
        canvas.worldCamera = HomeManager.cam.homeCamera
        bubble = {}
        bubble.gameObject = go
        CacheLoadBubble[i] = bubble
      end
    end
    if go and not go:IsNull() then
      local u_pid = v.u_pid
      local u_fid = v.u_fid
      local opIndex = v.opIndex
      local fur = PrisonData.cellFurList[u_fid]
      if fur then
        local posCfg = IllBubblePosCfg[opIndex + 1]
        if posCfg then
          go.transform.localScale = Vector3(0.008, 0.008, 0.008)
          local furPos = fur.view.transform.parent.localPosition
          local x = furPos.x + posCfg.offsetX
          local y = furPos.y + posCfg.offsetY
          local z = furPos.z + posCfg.offsetZ
          go.transform.localPosition = Vector3(x, y, z)
        end
      end
      this.BindClickEvent(go, u_pid)
    end
  end
end

function Controller.BindClickEvent(go, u_pid)
  local Btn_Ill = go.transform:Find("Btn_"):GetComponent(typeof(CS.Seven.UIBtn))
  
  local function BubbleIllClick()
    local function callBack()
      local character = PrisonData.cellPrisonerList[u_pid]
      
      if character then
        HomeStationStoreManager:RecycleCustom(character)
      end
      go:SetActive(false)
      PrisonData.cellPrisonerList[u_pid] = nil
      CommonTips.OpenTips(string.format(GetText(80607968), 1))
    end
    
    PrisonData.SolveIll(callBack, {u_pid})
  end
  
  Btn_Ill:SetClickFunction(BubbleIllClick)
end

function Controller.ChangeRoom(roomIndex, areaIndex, uiRoot)
  roomIndex = tonumber(roomIndex)
  if roomIndex == PrisonData.cellRoomIndex then
    return
  end
  local cellRoomList = PrisonData.GetCellRoomList()
  local roomCount = table.count(cellRoomList)
  if roomIndex < 1 or roomIndex > roomCount then
    return
  end
  MainManager:SetTrainViewFilter(30, false)
  Controller.InitRoom(roomIndex, areaIndex, uiRoot)
end

function Controller.InitPlacedFur(roomIndex, areaId)
  local room = HomeManager:GetCurRoom()
  local cellRoomList = PrisonData.GetCellRoomList() or {}
  local roomData = cellRoomList[tostring(roomIndex)] or {}
  local furList = roomData[tostring(areaId)] or {}
  for _, v in pairs(furList) do
    local furData = PrisonData.GetFurniture(v.u_fid)
    if furData then
      local placedFur = room:FirstInitFurniture(tonumber(furData.id), v.x, v.y, 0, v.u_fid)
      if placedFur then
        PrisonData.cellFurList[v.u_fid] = placedFur
      end
    end
  end
end

function Controller.InitPrisoner(roomIndex, areaId)
  local prisonerList = PrisonData.GetLivePrisonerList(roomIndex, areaId)
  local initPosList = PlayerData:GetFactoryData(areaId, "ListFactory").prisonPrisonerPosition
  for u_pid, v in pairs(prisonerList) do
    if PrisonData.IsPrisonerShowInCell(u_pid) then
      local prisonerData = PrisonData.GetPrisoner(u_pid)
      if prisonerData then
        local prisonerCA = PlayerData:GetFactoryData(prisonerData.prisoner_id, "PrisonerFactory")
        local characterId = prisonerCA.PrisonerAnimation
        if 0 < characterId then
          local initPos = initPosList[math.random(1, #initPosList)]
          local character = HomeStationStoreManager:CreateCustom(characterId, 0, false, initPos.x, initPos.y, "Prisoner:PrisonerCellRoom")
          if character then
            if PrisonData.IsIllHappen(u_pid) then
              HomeCharacterManager:InitContinuousOp(character, v.u_fid, v.opIndex, -1)
            end
            PrisonData.cellPrisonerList[u_pid] = character
          end
        end
      end
    end
  end
end

function Controller.ChangeArea(areaIndex)
  areaIndex = tonumber(areaIndex)
  local prisonCA = PrisonData.GetPrisonCA()
  local areaCount = table.count(prisonCA.prisonRoomPosition)
  if areaIndex < 1 or areaIndex > areaCount then
    return
  end
  if areaIndex == PrisonData.cellRoomAreaIndex then
    return
  end
  local camPos = HomeManager.cam.transform.localPosition
  local stationPlaceCA = PlayerData:GetFactoryData(81500009, "HomeStationFactory")
  local x = stationPlaceCA.cameraLeft + (stationPlaceCA.cameraRight - stationPlaceCA.cameraLeft) / (areaCount - 1) * (areaIndex - 1)
  HomeManager.cam.transform.localPosition = Vector3(x, camPos.y, camPos.z)
  MainManager:SetTrainViewFilter(30, false)
  PrisonData.SetCurCellRoomAreaIndex(areaIndex)
end

function Controller.MedicalAll(u_pidList)
  for i, u_pid in pairs(u_pidList) do
    local character = PrisonData.cellPrisonerList[u_pid]
    if character then
      HomeStationStoreManager:RecycleCustom(character)
      PrisonData.cellPrisonerList[u_pid] = nil
    end
  end
  for i, bubble in pairs(CacheLoadBubble) do
    local go = bubble.gameObject
    if go and not go:IsNull() then
      go:SetActive(false)
    end
  end
end

function Controller.CloseRoom()
  if not PrisonData.curCellRoomPlaceId or PrisonData.curCellRoomPlaceId ~= 81500009 then
    return
  end
  if HomeStationStoreManager:GetCurStationPlace() <= 0 then
    return
  end
  HomeStationStoreManager:QuitStationStore()
  local MainUIDataModel = require("UIMainUI/UIMainUIDataModel")
  if MainManager.bgSceneName == MainUIDataModel.SceneNameEnum.Home then
    local HomeController = require("UIHome/UIHomeController")
    local HomeCoachDataModel = require("UIHomeCoach/UIHomeCoachDataModel")
    local HomeCoachController = require("UIHomeCoach/UIHomeCoachController")
    HomeController:RefreshTrains()
    HomeCoachController:InitEnvironment()
    HomeCharacterManager:CreateAll(HomeCoachDataModel.characterData, HomeCoachDataModel.petData)
    HomeCharacterManager:ReShowAll()
  end
  PrisonData.CloseCellRoom()
  for i, bubble in pairs(CacheLoadBubble) do
    local go = bubble.gameObject
    if go and not go:IsNull() then
      Object.Destroy(go)
    end
  end
  CacheLoadBubble = {}
end

return Controller
