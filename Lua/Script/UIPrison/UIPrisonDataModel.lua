local DataModel = {}
local View = require("UIPrison/UIPrisonView")
DataModel.prisonCA = PrisonData.GetPrisonCA()
DataModel.buildList = {}
DataModel.RoomStatus = {
  FirstBuild = 0,
  Lock = 1,
  InBuild = 2,
  Normal = 3
}
DataModel.focus = false
DataModel.focusBeforePos = nil
DataModel.powerRoomPosChange = false
DataModel.selectTypeId = nil
DataModel.buildCtrList = {}
DataModel.materialRoomTypeIdList = {
  87500017,
  87500018,
  87500019,
  87500020
}
DataModel.materialWorkingList = {}
local ElevatorAnimInfo = {
  {
    {
      startPos = -225,
      anim = "ElevatorStartTop1"
    },
    {
      startPos = -744,
      anim = "ElevatorStartBottom1"
    }
  },
  {
    {
      startPos = 1135,
      anim = "ElevatorStartTop2"
    },
    {
      startPos = -744,
      anim = "ElevatorStartBottom2"
    }
  },
  {
    {
      startPos = 1135,
      anim = "ElevatorStartTop3"
    },
    {
      startPos = -1286,
      anim = "ElevatorStartBottom3"
    }
  },
  {
    {
      startPos = -225,
      anim = "ElevatorStartTop4"
    },
    {
      startPos = -744,
      anim = "ElevatorStartBottom4"
    }
  }
}

function DataModel.InitData()
  DataModel.buildCtrList = {}
  for i, v in pairs(DataModel.prisonCA.prison) do
    local buildTypeCA = PlayerData:GetFactoryData(v.id, "PrisonRoomTypeFactory")
    local ctr = View.Group_Bg.ScrollView_.Viewport.Content[buildTypeCA.prefabName]
    if ctr then
      DataModel.buildCtrList[v.id] = ctr
    end
  end
  DataModel.focus = false
  DataModel.focusBeforePos = nil
  DataModel.powerRoomPosChange = false
  DataModel.selectTypeId = nil
end

function DataModel.RefreshOnShow()
  View.Group_Bg.ScrollView_.transform.localPosition = Vector3(0, 0, 0)
  View.Group_Bg.ScrollView_.Viewport.Content:SetAnchoredPosition(Vector2(0, 0))
  View.Group_Bg:SetLocalScale(1, 1, 1)
  View.Img_BGTop:SetActive(true)
  View.Group_CommonTopLeft:SetActive(true)
  View.Group_Btn:SetActive(false)
  View.Btn_FocusClose:SetActive(false)
  View.Btn_CloseTip:SetActive(false)
  for i = 1, 4 do
    local ctr = View.Group_Bg.ScrollView_.Viewport.Content["Group_Elevator" .. i]
    if ctr then
      local info = ElevatorAnimInfo[i]
      local randomIndex = math.random(1, #info)
      ctr:SetAnchoredPositionY(info[randomIndex].startPos)
      ctr:SelectPlayAnim(info[randomIndex].anim)
    end
  end
  for i, ctr in pairs(DataModel.buildCtrList) do
    if ctr.UI_Prison_BuildingLevelUp_Big then
      ctr.UI_Prison_BuildingLevelUp_Big:SetActive(false)
    end
    if ctr.UI_Prison_BuildingLevelUp_Small then
      ctr.UI_Prison_BuildingLevelUp_Small:SetActive(false)
    end
  end
  DataModel.RefreshPrisonLV()
  local curPower = PrisonData.GetCurPower()
  local usePower = PrisonData.GetUsePower()
  View.Img_BGTop.Group_Power.Group_Num.Txt_Own:SetText(usePower)
  View.Img_BGTop.Group_Power.Group_Num.Txt_Max:SetText(curPower)
  local prisonData = PrisonData.GetSeverPrisonData()
  View.Group_Bg.ScrollView_.Viewport.Content.Group_Building.Btn_Stability.Txt_:SetText(prisonData.stability)
  View.Group_Bg.ScrollView_.Viewport.Content.Group_Building.Btn_Obedience.Txt_:SetText(prisonData.obedience)
  View.Group_Bg.ScrollView_.Viewport.Content.Group_Building.Btn_Safety.Txt_:SetText(prisonData.safety)
  View.Group_Bg.ScrollView_.Viewport.Content.Group_Building.Btn_Hygiene.Txt_:SetText(prisonData.hygiene)
  View.Group_Bg.ScrollView_.Viewport.Content.Group_StabilityInfo:SetActive(false)
  View.Group_Bg.ScrollView_.Viewport.Content.Group_ObedienceInfo:SetActive(false)
  View.Group_Bg.ScrollView_.Viewport.Content.Group_SafetyInfo:SetActive(false)
  View.Group_Bg.ScrollView_.Viewport.Content.Group_HygieneInfo:SetActive(false)
  DataModel.RefreshQuestRed()
  DataModel.QuestTraceRefresh()
  DataModel.RefreshAllRoom()
  DataModel.RefreshRoomCharacterAnim()
  View.Img_BGTop.Group_Prisoner:SetActive(false)
  DataModel.RefreshLeftBtn()
end

function DataModel.RefreshLeftBtn()
  local OrderData = require("UIHYOrderStation/PrisonHyOrderData")
  View.Group_NewBtn.Btn_Order.Img_RedDot:SetActive(OrderData.GetRedPoint())
  local canGetList = PrisonData.GetAllCanStartPurchaseOrder(true)
  local canCompleteList = PrisonData.GetAllCanReceivePurchaseOrder(true)
  View.Group_NewBtn.Btn_Purchase.Img_RedDot:SetActive(table.count(canGetList) > 0 or table.count(canCompleteList) > 0)
end

function DataModel.RefreshPrisonLV()
  local prisonLv = PrisonData.GetPrisonLv()
  local exp = PrisonData.GetPrisonExp()
  local lvCfg = DataModel.prisonCA.lvList[prisonLv]
  View.Img_BGTop.Group_Level.Group_.Txt_Num:SetText(prisonLv)
  local LevelDataModel = require("UIPrisonLevel/UIPrisonLevelDataModel")
  View.Img_BGTop.Group_Level.Group_.Img_RedDot:SetActive(LevelDataModel.CheckHasRedPoint())
  View.Img_BGTop.Group_Level.Txt_Exp:SetText(string.format("%d/%d", exp, lvCfg.exp))
  View.Img_BGTop.Group_Level.Img_Bar:SetFilledImgAmount(exp / lvCfg.exp)
end

function DataModel.RefreshAllRoom()
  DataModel.buildList = {}
  for i, v in pairs(DataModel.prisonCA.prison) do
    DataModel.RefreshBuildRoomCtr(v.id)
    local remainTime = DataModel.GetRoomBuildRemainTime(v.id)
    if 0 < remainTime then
      DataModel.buildList[v.id] = {remainTime = remainTime}
    end
  end
  DataModel.RefreshMaterialProductRoom()
end

function DataModel.RefreshMaterialProductRoom()
  DataModel.materialWorkingList = {}
  for i, v in ipairs(DataModel.materialRoomTypeIdList) do
    DataModel.RefreshMaterialRoomCtr(v)
  end
end

function DataModel.RefreshBuildRoomCtr(roomTypeId)
  roomTypeId = tonumber(roomTypeId)
  local roomStatus = DataModel.GetRoomStatus(roomTypeId)
  local roomLvCfg = DataModel.GetRoomLvCfg(roomTypeId)
  local serverData = DataModel.GetRoomSeverData(roomTypeId)
  local buildTypeCA = PlayerData:GetFactoryData(roomTypeId, "PrisonRoomTypeFactory")
  local ctr = DataModel.buildCtrList[roomTypeId]
  if ctr.Txt_ then
    ctr.Txt_:SetText(buildTypeCA.roomName)
  end
  if ctr.Group_Title then
    ctr.Group_Title.Txt_:SetText(buildTypeCA.roomName)
    ctr.Group_Title.Txt_LV:SetActive(serverData)
    if ctr.Group_Title.Img_RedPoint then
      ctr.Group_Title.Img_RedPoint:SetActive(DataModel.CheckRoomRedPoint(roomTypeId))
    end
    if serverData then
      ctr.Group_Title.Txt_LV:SetText("LV" .. serverData.lv)
    end
  end
  local roomCA = PlayerData:GetFactoryData(roomLvCfg.config, "PrisonRoomFactory")
  ctr.Img_BG:SetSprite(roomCA.roomPic)
  if ctr.Img_FirstBuild then
    ctr.Img_FirstBuild:SetActive(roomStatus == DataModel.RoomStatus.FirstBuild)
    ctr.Img_FirstBuild.Txt_Name:SetText(buildTypeCA.roomName)
    local remainTime = DataModel.GetRoomBuildRemainTime(roomTypeId)
    if 0 < remainTime then
      local timeStr = DataModel.GetTimeStr(remainTime)
      ctr.Img_FirstBuild.Group_Time.Txt_Time:SetText(timeStr)
    end
  end
  if ctr.Group_Locked then
    ctr.Group_Locked:SetActive(roomStatus == DataModel.RoomStatus.Lock)
    ctr.Group_Locked.Txt_Name:SetText(buildTypeCA.roomName)
    if roomStatus == DataModel.RoomStatus.Lock then
      local lockStatus = DataModel.GetBuildLockStatus(roomTypeId, roomLvCfg.config)
      local levelCanOpen = lockStatus.levelCanOpen
      local powerCanOpen = lockStatus.powerCanOpen
      local canOpen = levelCanOpen and powerCanOpen
      ctr.Group_Locked.Img_Available:SetActive(canOpen)
      ctr.Group_Locked.Img_Unavailable:SetActive(not canOpen)
      ctr.Group_Locked.Img_Unavailable.Group_Power:SetActive(not powerCanOpen and levelCanOpen)
      local isCreateRoom = DataModel.IsCreateRoom(roomTypeId)
      if ctr.Group_Locked.Img_Unavailable.Group_LV then
        ctr.Group_Locked.Img_Unavailable.Group_LV:SetActive(not isCreateRoom and not levelCanOpen)
      end
      if ctr.Group_Locked.Img_Unavailable.Group_CreateRoomLV then
        ctr.Group_Locked.Img_Unavailable.Group_CreateRoomLV:SetActive(isCreateRoom and not levelCanOpen)
      end
      if ctr.Group_Locked.Img_Unavailable.Group_CreateRoomLV and ctr.Group_Locked.Img_Unavailable.Group_CreateRoomLV.IsActive then
        ctr.Group_Locked.Img_Unavailable.Group_CreateRoomLV.Txt_Time:SetText("LV" .. roomLvCfg.level)
      elseif ctr.Group_Locked.Img_Unavailable.Group_LV and ctr.Group_Locked.Img_Unavailable.Group_LV.IsActive then
        ctr.Group_Locked.Img_Unavailable.Group_LV.Txt_Time:SetText("LV" .. roomLvCfg.level)
      end
    end
  end
  if ctr.Group_Build then
    ctr.Group_Build:SetActive(roomStatus == DataModel.RoomStatus.InBuild)
    local remainTime = DataModel.GetRoomBuildRemainTime(roomTypeId)
    if 0 < remainTime then
      local timeStr = DataModel.GetTimeStr(remainTime)
      ctr.Group_Build.Txt_Time:SetText(timeStr)
    end
  end
  if ctr.Group_Picked then
    if PrisonData.ProductRoomTypeIdToIndexMap[roomTypeId] or PrisonData.CellRoomTypeIdToRoomIndexMap[roomTypeId] then
      ctr.Group_Picked:SetActive(false)
    else
      ctr.Group_Picked:SetActive(DataModel.selectTypeId == roomTypeId)
    end
  end
  if ctr.Group_Power then
    local occupyPower = DataModel.GetRoomOccupyPower(roomTypeId, roomLvCfg.config)
    ctr.Group_Power:SetActive(0 < occupyPower)
    ctr.Group_Power.Txt_:SetText(occupyPower)
  end
  ctr:SetClickParam(roomTypeId)
  if ctr.Group_LvAvailable then
    ctr.Group_LvAvailable:SetActive(false)
  end
end

function DataModel.RefreshMaterialRoomCtr(roomTypeId)
  roomTypeId = tonumber(roomTypeId)
  local roomStatus = DataModel.GetRoomStatus(roomTypeId)
  local ctr = DataModel.buildCtrList[roomTypeId]
  ctr.Group_Status:SetActive(roomStatus == DataModel.RoomStatus.Normal)
  if roomStatus ~= DataModel.RoomStatus.Normal then
    return
  elseif ctr.Group_Status then
    ctr.Group_Status:SetActive(false)
    local roomData = PlayerData.ServerData.user_prison_info.raw_material_workshops[tostring(roomTypeId)]
    roomData = roomData or {
      u_pid_list = {},
      start_ts = 0
    }
    if roomData ~= nil then
      ctr.Group_Status:SetActive(true)
      local isInProduct = roomData.start_ts and roomData.start_ts > 0
      local hasUnReceive = roomData.product_detail and 0 < roomData.product_detail.normal
      ctr.Group_Status.Group_Info.Txt_Prisoner:SetText(table.count(roomData.u_pid_list) or 0)
      ctr.Group_Status.Group_Working:SetActive(isInProduct)
      ctr.Group_Status.Group_WorkDone:SetActive(not isInProduct and hasUnReceive)
      ctr.Group_Status.Group_Item:SetActive(hasUnReceive or isInProduct)
      ctr.Group_Status.Btn_Get:SetActive(hasUnReceive)
      if hasUnReceive then
        local formulaCfg = PlayerData:GetFactoryData(roomData.formula_group_id)
        ctr.Group_Status.Group_Item.Img_Item:SetSprite(formulaCfg.iconPath)
        ctr.Group_Status.Group_Item.Txt_ItemNum:SetText(roomData.product_detail and 0 < roomData.product_detail.normal and string.format("%d<color=#FFB800>+%d</color>", roomData.product_detail.normal, roomData.product_detail.extra) or 0)
      end
      if isInProduct then
        local formulaCfg = PlayerData:GetFactoryData(roomData.formula_group_id)
        ctr.Group_Status.Group_Item.Img_Item:SetSprite(formulaCfg.iconPath)
        ctr.Group_Status.Group_Item.Txt_ItemNum:SetText(roomData.product_detail and 0 < roomData.product_detail.normal and string.format("%d<color=#FFB800>+%d</color>", roomData.product_detail.normal, roomData.product_detail.extra) or 0)
        local workTime = TimeUtil:GetServerTimeStamp() - roomData.st_ts + roomData.speed_ts
        if 0 < workTime then
          local timeTbl = TimeUtil:SecondToTableHMS(workTime)
          ctr.Group_Status.Group_Info.Group_Time.Txt_Time:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
          local timeCountCtr = {
            ctr = ctr.Group_Status.Group_Info.Group_Time.Txt_Time,
            startTime = roomData.st_ts,
            speedTime = roomData.speed_ts or 0
          }
          table.insert(DataModel.materialWorkingList, timeCountCtr)
        else
          ctr.Group_Status.Group_Info.Group_Time.Txt_Time:SetText("00:00:00")
        end
      else
        ctr.Group_Status.Group_Info.Group_Time.Txt_Time:SetText("00:00:00")
      end
    end
  end
end

function DataModel.OpenRoomUI(str)
  local roomTypeId = tonumber(str)
  local buildTypeCA = PlayerData:GetFactoryData(roomTypeId, "PrisonRoomTypeFactory")
  if buildTypeCA.openPrefab and buildTypeCA.openPrefab ~= "" then
    if roomTypeId == 87500005 then
      UIManager:Open(buildTypeCA.openPrefab, Json.encode({openStationTab = 2}))
    elseif roomTypeId == 87500006 then
      UIManager:Open(buildTypeCA.openPrefab, Json.encode({openStationTab = 1}))
    elseif roomTypeId == 87500009 then
      UIManager:Open(buildTypeCA.openPrefab, Json.encode({Mode = "Prison"}))
    elseif roomTypeId == 87500010 then
      local shopList = {}
      for i, v in ipairs(DataModel.prisonCA.prisonStoreList) do
        table.insert(shopList, v.id)
      end
      local shopIds = table.concat(shopList, ",")
      Net:SendProto("shop.info", function(json)
        PlayerData:RefreshShops(json.shops)
        UIManager:Open("UI/Prison/PrisonShop/PrisonShop")
      end, shopIds)
    else
      UIManager:Open(buildTypeCA.openPrefab, Json.encode({roomTypeId = str}))
    end
  end
end

function DataModel.ClickRoom(str)
  local roomTypeId = tonumber(str)
  local roomStatus = DataModel.GetRoomStatus(roomTypeId)
  local roomLvCfg = DataModel.GetRoomLvCfg(roomTypeId)
  local buildTypeCA = PlayerData:GetFactoryData(roomTypeId, "PrisonRoomTypeFactory")
  if roomStatus == DataModel.RoomStatus.Lock then
    local lockStatus = DataModel.GetBuildLockStatus(roomTypeId, roomLvCfg.config)
    if not lockStatus.levelCanOpen then
      local isCreateRoom = DataModel.IsCreateRoom(roomTypeId)
      if isCreateRoom then
        CommonTips.OpenTips(80608016)
      else
        CommonTips.OpenTips(80608009)
      end
      return
    end
  end
  if buildTypeCA.isInitial then
    DataModel.OpenRoomUI(str)
    return
  end
  local selectTypeId = DataModel.selectTypeId
  if selectTypeId == roomTypeId then
    return
  end
  local selectCtr = DataModel.buildCtrList[selectTypeId]
  if selectCtr and selectCtr.Group_Picked then
    selectCtr.Group_Picked:SetActive(false)
  end
  selectCtr = DataModel.buildCtrList[roomTypeId]
  if selectCtr and selectCtr.Group_Picked then
    selectCtr.Group_Picked:SetActive(true)
  end
  DataModel.selectTypeId = roomTypeId
  local x = -selectCtr:GetAnchoredPositionX() - View.Group_Bg.ScrollView_.Viewport.Content:GetAnchoredPositionX()
  local y = -selectCtr:GetAnchoredPositionY() - View.Group_Bg.ScrollView_.Viewport.Content:GetAnchoredPositionY()
  local scale = 1
  if buildTypeCA.sizeType == "RoomB" then
    scale = 1.8
    x = x - 226
    y = y + 9
  elseif buildTypeCA.sizeType == "RoomA" then
    scale = 2
    x = x - 204
    y = y + 9
  end
  DataModel.focusBeforePos = View.Group_Bg.ScrollView_:GetAnchoredPosition()
  DOTweenTools.DOLocalMove(View.Group_Bg.ScrollView_.transform, x, y, 0, 0.5)
  DOTweenTools.DOScaleCallback(View.Group_Bg.transform, scale, 0.5, function()
    if roomStatus == DataModel.RoomStatus.Lock then
      local function callBack()
        if roomTypeId == 87500012 then
          if not DataModel.powerRoomPosChange then
            DataModel.powerRoomPosChange = true
            
            View.Group_Btn:SetAnchoredPositionY(150)
            local anchoredPosY = View.Group_Bg.ScrollView_:GetAnchoredPositionY()
            View.Group_Bg.ScrollView_:SetAnchoredPositionY(anchoredPosY + 70)
          end
        else
          View.Group_Btn:SetAnchoredPositionY(10)
        end
        UIManager:Open("UI/Prison/PrisonBuildingUpgrade/PrisonBuildingUpgrade", Json.encode({buildType = roomTypeId}))
      end
      
      PrisonData.PrisonRefresh(callBack)
    else
      View.Group_Btn:SetActive(true)
      View.Group_Btn:SetAnchoredPositionY(10)
      DataModel.RefreshRoomFunList()
    end
    DataModel.focus = true
  end)
  View.Img_BGTop:SetActive(false)
  View.Group_CommonTopLeft:SetActive(false)
  View.Btn_FocusClose:SetActive(true)
end

function DataModel.CheckRoomRedPoint(roomTypeId)
  local roomStatus = DataModel.GetRoomStatus(roomTypeId)
  if roomStatus == DataModel.RoomStatus.Lock then
    return false
  end
  if roomTypeId == 87500015 then
    local data = PlayerData.ServerData.user_prison_info.medical_report
    if data and table.count(data) > 0 then
      for i, v in pairs(data) do
        if v == "out" then
          return true
        end
      end
    end
    return false
  elseif roomTypeId == 87500014 then
    local data = PlayerData.ServerData.user_prison_info.detention_room
    if data and table.count(data) > 0 then
      for i, v in pairs(data) do
        if v.frisk_count == 0 then
          return true
        end
      end
    end
    data = PlayerData.ServerData.user_prison_info.detention_report
    if data and table.count(data) > 0 then
      for i, v in pairs(data) do
        if v == "out" then
          return true
        end
      end
    end
    return false
  elseif roomTypeId == 87500009 then
    local backpackCount = table.count(PlayerData.ServerData.user_prison_info.carrying_backpack)
    local prisonerCount = table.count(PlayerData.ServerData.user_prison_info.prison_backpack)
    if 0 < backpackCount and prisonerCount < 168 then
      return true
    end
    return false
  elseif PrisonData.CellRoomTypeIdToRoomIndexMap[tonumber(roomTypeId)] ~= nil then
    local index = PrisonData.CellRoomTypeIdToRoomIndexMap[tonumber(roomTypeId)]
    local illList = PrisonData.GetIllPrisonerInCell(tostring(index))
    if table.count(illList) > 0 then
      return true
    end
    return false
  elseif PrisonData.ProductRoomTypeIdToIndexMap[tonumber(roomTypeId)] ~= nil then
    local index = PrisonData.ProductRoomTypeIdToIndexMap[tonumber(roomTypeId)]
    local productRoomList = PrisonData.GetProductRoomList() or {}
    local roomData = productRoomList[tostring(index)] or {}
    local tempRoomIndex = PrisonData.roomIndex
    for cellIndex, v in pairs(roomData) do
      local u_pid = productRoomList[tostring(index)][cellIndex]
      if u_pid ~= "" then
        if PrisonData.IsIllHappen(u_pid) then
          return true
        end
        if PrisonData.IsAccidentHappen(index, cellIndex) then
          return true
        end
        PrisonData.roomIndex = index
        local state = PrisonController.GetBubbleState(cellIndex)
        if state == 1 then
          return true
        end
        if state == 6 then
          PrisonData.roomIndex = tempRoomIndex
          return true
        end
        PrisonData.roomIndex = tempRoomIndex
      end
    end
    local productRedPoint = PrisonData.CheckProductRoomRedPoint(index)
    return productRedPoint
  end
  return false
end

function DataModel.RefreshRoomFunList()
  if not View.Group_Btn.IsActive or not DataModel.selectTypeId then
    return
  end
  local roomTypeId = tonumber(DataModel.selectTypeId)
  local roomStatus = DataModel.GetRoomStatus(roomTypeId)
  local remainTime = DataModel.GetRoomBuildRemainTime(roomTypeId)
  local buildTypeCA = PlayerData:GetFactoryData(roomTypeId, "PrisonRoomTypeFactory")
  View.Group_Btn.Btn_Function:SetClickParam(roomTypeId)
  local showDetailFun = roomStatus == DataModel.RoomStatus.Normal and buildTypeCA.openPrefab and buildTypeCA.openPrefab ~= "" and buildTypeCA.detailIfo ~= "MaterialWorkShop"
  View.Group_Btn.Btn_Function:SetActive(showDetailFun)
  View.Group_Btn.Btn_Acceleration:SetClickParam(roomTypeId)
  View.Group_Btn.Btn_Acceleration:SetActive(remainTime and 0 < remainTime)
  local showProductFun = roomStatus == DataModel.RoomStatus.Normal and buildTypeCA.openPrefab and buildTypeCA.openPrefab ~= "" and buildTypeCA.detailIfo == "MaterialWorkShop"
  View.Group_Btn.Btn_Production:SetActive(showProductFun)
  View.Group_Btn.Btn_Production:SetClickParam(roomTypeId)
  View.Group_Btn.Btn_Faster:SetClickParam(roomTypeId)
  View.Group_Btn.Btn_Faster:SetActive(remainTime and 0 < remainTime)
  if remainTime and 0 < remainTime then
    local immediatelyCost = 0
    for i, v in ipairs(DataModel.prisonCA.diamondFaster) do
      if remainTime <= v.timeFaster then
        immediatelyCost = v.diamondNum
        break
      end
    end
    View.Group_Btn.Btn_Faster.Group_.Txt_:SetText(immediatelyCost)
  end
  View.Group_Btn.Btn_Upgrade:SetClickParam(roomTypeId)
  View.Group_Btn.Btn_Upgrade:SetActive(not remainTime or remainTime <= 0)
end

function DataModel.OpenProductRoom(roomIndex, roomTypeId)
  roomTypeId = tonumber(roomTypeId)
  local roomLvCfg = DataModel.GetRoomLvCfg(roomTypeId)
  local roomStatus = DataModel.GetRoomStatus(roomTypeId)
  if roomStatus == DataModel.RoomStatus.Lock then
    local lockStatus = DataModel.GetBuildLockStatus(roomTypeId, roomLvCfg.config)
    if not lockStatus.levelCanOpen then
      CommonTips.OpenTips(80608009)
      return
    end
    DataModel.selectTypeId = roomTypeId
    UIManager:Open("UI/Prison/Contract/PrisonWorkshopContract")
    return
  end
  PrisonController.InitScene()
  PrisonData.SetCurRoomIndex(roomIndex)
  UIManager:Open("UI/Prison/Main/PrisonMain")
  PrisonController.InitRoom(roomIndex, require("UIPrisonMain/UIPrisonMainView").self)
end

function DataModel.OpenPrisonerRoom(roomIndex, roomTypeId)
  roomTypeId = tonumber(roomTypeId)
  local roomLvCfg = DataModel.GetRoomLvCfg(roomTypeId)
  local roomStatus = DataModel.GetRoomStatus(roomTypeId)
  if roomStatus == DataModel.RoomStatus.Lock then
    local lockStatus = DataModel.GetBuildLockStatus(roomTypeId, roomLvCfg.config)
    if not lockStatus.levelCanOpen then
      CommonTips.OpenTips(80608009)
      return
    end
    DataModel.selectTypeId = roomTypeId
    UIManager:Open("UI/Prison/Contract/PrisonAccommodationContract")
    return
  end
  PrisonCellController.InitScene(81500009)
  PrisonData.SetCurCellRoomIndex(roomIndex)
  PrisonData.SetCurCellRoomAreaIndex(1)
  UIManager:Open("UI/Prison/Main/PrisonAccomodation/PrisonAccomodation")
  PrisonCellController.InitRoom(roomIndex, 1, require("UIPrisonAccomodation/UIPrisonAccomodationView").self)
end

function DataModel.GetRoomStatus(roomTypeId)
  roomTypeId = tonumber(roomTypeId)
  local roomStatus = DataModel.RoomStatus.Lock
  local buildTypeCA = PlayerData:GetFactoryData(roomTypeId, "PrisonRoomTypeFactory")
  if buildTypeCA.isInitial then
    roomStatus = DataModel.RoomStatus.Normal
  elseif PrisonData.ProductRoomTypeIdToIndexMap[roomTypeId] then
    local roomIndex = PrisonData.ProductRoomTypeIdToIndexMap[roomTypeId]
    local productRooms = PrisonData.GetProductRoomList()
    if productRooms[tostring(roomIndex)] then
      roomStatus = DataModel.RoomStatus.Normal
    else
      roomStatus = DataModel.RoomStatus.Lock
    end
  elseif PrisonData.CellRoomTypeIdToRoomIndexMap[roomTypeId] then
    local roomIndex = PrisonData.CellRoomTypeIdToRoomIndexMap[roomTypeId]
    local cellRoomList = PrisonData.GetCellRoomList()
    if cellRoomList[tostring(roomIndex)] then
      roomStatus = DataModel.RoomStatus.Normal
    else
      roomStatus = DataModel.RoomStatus.Lock
    end
  else
    local serverData = DataModel.GetRoomSeverData(roomTypeId)
    if not serverData then
      roomStatus = DataModel.RoomStatus.Lock
    else
      local lv = serverData.lv
      local remainTime = DataModel.GetRoomBuildRemainTime(roomTypeId)
      if remainTime <= 0 then
        roomStatus = DataModel.RoomStatus.Normal
      elseif lv == 1 then
        roomStatus = DataModel.RoomStatus.FirstBuild
      elseif 1 < lv then
        roomStatus = DataModel.RoomStatus.InBuild
      end
    end
  end
  return roomStatus
end

function DataModel.GetRoomLvCfg(roomTypeId, level)
  roomTypeId = tonumber(roomTypeId)
  local buildTypeCA = PlayerData:GetFactoryData(roomTypeId, "PrisonRoomTypeFactory")
  if PrisonData.ProductRoomTypeIdToIndexMap[roomTypeId] then
    return buildTypeCA.roomList[1]
  elseif PrisonData.CellRoomTypeIdToRoomIndexMap[roomTypeId] then
    return buildTypeCA.roomList[1]
  else
    local serverData = DataModel.GetRoomSeverData(roomTypeId)
    if buildTypeCA.isInitial then
      return buildTypeCA.roomList[1]
    else
      local lv = level
      if not level then
        lv = serverData and serverData.lv or 1
      end
      local isCreateRoom = DataModel.IsCreateRoom(roomTypeId)
      if isCreateRoom then
        for _, roomInfo in ipairs(buildTypeCA.creatRoomList) do
          local roomCA = PlayerData:GetFactoryData(roomInfo.config, "PrisonRoomFactory")
          if roomCA.roomLevel == lv then
            return roomInfo
          end
        end
      else
        for _, roomInfo in ipairs(buildTypeCA.roomList) do
          local roomCA = PlayerData:GetFactoryData(roomInfo.config, "PrisonRoomFactory")
          if roomCA.roomLevel == lv then
            return roomInfo
          end
        end
      end
    end
  end
end

function DataModel.GetRoomSeverData(roomTypeId)
  roomTypeId = tostring(roomTypeId)
  local serverBuildList = PrisonData.GetBuildList() or {}
  return serverBuildList[roomTypeId]
end

function DataModel.GetRoomBuildRemainTime(roomTypeId)
  local serverData = DataModel.GetRoomSeverData(roomTypeId)
  if serverData then
    local roomLvCfg = DataModel.GetRoomLvCfg(roomTypeId)
    local roomCA = PlayerData:GetFactoryData(roomLvCfg.config, "PrisonRoomFactory")
    if serverData.start_ts then
      return serverData.start_ts + roomCA.upgradeTime - TimeUtil:GetServerTimeStamp()
    end
  end
  return 0
end

function DataModel.GetBuildLockStatus(roomTypeId, roomId)
  local lockStatus = {levelCanOpen = true, powerCanOpen = true}
  local prisonCA = DataModel.prisonCA
  local buildTypeCA = PlayerData:GetFactoryData(roomTypeId, "PrisonRoomTypeFactory")
  local isCreateRoom = DataModel.IsCreateRoom(roomTypeId)
  for i, v in pairs(buildTypeCA.roomList) do
    if v.config == roomId then
      if isCreateRoom then
        do
          local createRoomLv = 0
          local buildRoomList = PrisonData.GetBuildList()
          if buildRoomList["87500010"] then
            createRoomLv = buildRoomList["87500010"].lv
          else
            local roomTypeCA = PlayerData:GetFactoryData(87500010, "PrisonRoomTypeFactory")
            if roomTypeCA.isInitial then
              createRoomLv = 1
            end
          end
          lockStatus.levelCanOpen = createRoomLv >= v.level
        end
        break
      end
      lockStatus.levelCanOpen = PrisonData.GetPrisonLv() >= v.level
      break
    end
  end
  local occupyPower = 0
  if PrisonData.ProductRoomTypeIdToIndexMap[roomTypeId] then
    occupyPower = prisonCA.initialSpaceNum * prisonCA.workshopSpaceOccupyPower
  elseif PrisonData.CellRoomTypeIdToRoomIndexMap[roomTypeId] then
    occupyPower = prisonCA.initialRoomNum * prisonCA.cellSpaceOccupyPower
  else
    local roomCA = PlayerData:GetFactoryData(roomId, "PrisonRoomFactory")
    occupyPower = roomCA.occupyPower
  end
  lockStatus.powerCanOpen = PrisonData.GetUsePower() + occupyPower <= PrisonData.GetCurPower()
  return lockStatus
end

function DataModel.GetTimeStr(time)
  local timeTbl = TimeUtil:SecondToTableHMS(time)
  return string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second)
end

function DataModel.UpgradeBuildImmediately(roomTypeId)
  roomTypeId = tonumber(roomTypeId)
  local buildTypeCA = PlayerData:GetFactoryData(roomTypeId, "PrisonRoomTypeFactory")
  local ctr = DataModel.buildCtrList[roomTypeId]
  if ctr then
    if buildTypeCA.sizeType == "RoomA" then
      if ctr.UI_Prison_BuildingLevelUp_Small then
        ctr.UI_Prison_BuildingLevelUp_Small:SetActive(false)
        ctr.UI_Prison_BuildingLevelUp_Small:SetActive(true)
      end
    elseif buildTypeCA.sizeType == "RoomB" and ctr.UI_Prison_BuildingLevelUp_Big then
      ctr.UI_Prison_BuildingLevelUp_Big:SetActive(false)
      ctr.UI_Prison_BuildingLevelUp_Big:SetActive(true)
    end
    ctr:SelectPlayAnim("CompleteConstruction")
  end
  View.Group_Btn:SetActive(true)
  DataModel.RefreshRoomFunList()
  DataModel.RefreshAllRoom()
  local curPower = PrisonData.GetCurPower()
  local usePower = PrisonData.GetUsePower()
  View.Img_BGTop.Group_Power.Group_Num.Txt_Own:SetText(usePower)
  View.Img_BGTop.Group_Power.Group_Num.Txt_Max:SetText(curPower)
end

function DataModel.UpgradeBuild(roomTypeId)
  roomTypeId = tonumber(roomTypeId)
  local roomStatus = DataModel.GetRoomStatus(roomTypeId)
  local roomLvCfg = DataModel.GetRoomLvCfg(roomTypeId)
  local buildTypeCA = PlayerData:GetFactoryData(roomTypeId, "PrisonRoomTypeFactory")
  local roomCA = PlayerData:GetFactoryData(roomLvCfg.config, "PrisonRoomFactory")
  local ctr = DataModel.buildCtrList[roomTypeId]
  if roomCA.upgradeTime > 0 then
    if ctr and roomStatus == DataModel.RoomStatus.FirstBuild then
      ctr:SelectPlayAnim("Constructing")
    end
  elseif ctr then
    if buildTypeCA.sizeType == "RoomA" then
      if ctr.UI_Prison_BuildingLevelUp_Small then
        ctr.UI_Prison_BuildingLevelUp_Small:SetActive(false)
        ctr.UI_Prison_BuildingLevelUp_Small:SetActive(true)
      end
    elseif buildTypeCA.sizeType == "RoomB" and ctr.UI_Prison_BuildingLevelUp_Big then
      ctr.UI_Prison_BuildingLevelUp_Big:SetActive(false)
      ctr.UI_Prison_BuildingLevelUp_Big:SetActive(true)
    end
    ctr:SelectPlayAnim("CompleteConstruction")
  end
  DataModel.RefreshAllRoom()
  View.Group_Btn:SetActive(true)
  DataModel.RefreshRoomFunList()
  local curPower = PrisonData.GetCurPower()
  local usePower = PrisonData.GetUsePower()
  View.Img_BGTop.Group_Power.Group_Num.Txt_Own:SetText(usePower)
  View.Img_BGTop.Group_Power.Group_Num.Txt_Max:SetText(curPower)
end

function DataModel.UpgradeBuildFaster(roomTypeId)
  roomTypeId = tonumber(roomTypeId)
  local buildTypeCA = PlayerData:GetFactoryData(roomTypeId, "PrisonRoomTypeFactory")
  local remainTime = DataModel.GetRoomBuildRemainTime(roomTypeId)
  if remainTime <= 0 then
    local ctr = DataModel.buildCtrList[roomTypeId]
    if ctr then
      if buildTypeCA.sizeType == "RoomA" then
        if ctr.UI_Prison_BuildingLevelUp_Small then
          ctr.UI_Prison_BuildingLevelUp_Small:SetActive(false)
          ctr.UI_Prison_BuildingLevelUp_Small:SetActive(true)
        end
      elseif buildTypeCA.sizeType == "RoomB" and ctr.UI_Prison_BuildingLevelUp_Big then
        ctr.UI_Prison_BuildingLevelUp_Big:SetActive(false)
        ctr.UI_Prison_BuildingLevelUp_Big:SetActive(true)
      end
      ctr:SelectPlayAnim("CompleteConstruction")
    end
  end
  DataModel.RefreshAllRoom()
  View.Group_Btn:SetActive(true)
  DataModel.RefreshRoomFunList()
end

function DataModel.UnLockProductRoom()
  local roomTypeId = tonumber(DataModel.selectTypeId)
  local buildTypeCA = PlayerData:GetFactoryData(roomTypeId, "PrisonRoomTypeFactory")
  local ctr = DataModel.buildCtrList[roomTypeId]
  if ctr then
    if buildTypeCA.sizeType == "RoomA" then
      if ctr.UI_Prison_BuildingLevelUp_Small then
        ctr.UI_Prison_BuildingLevelUp_Small:SetActive(false)
        ctr.UI_Prison_BuildingLevelUp_Small:SetActive(true)
      end
    elseif buildTypeCA.sizeType == "RoomB" and ctr.UI_Prison_BuildingLevelUp_Big then
      ctr.UI_Prison_BuildingLevelUp_Big:SetActive(false)
      ctr.UI_Prison_BuildingLevelUp_Big:SetActive(true)
    end
    ctr:SelectPlayAnim("CompleteConstruction")
  end
  DataModel.RefreshAllRoom()
  local curPower = PrisonData.GetCurPower()
  local usePower = PrisonData.GetUsePower()
  View.Img_BGTop.Group_Power.Group_Num.Txt_Own:SetText(usePower)
  View.Img_BGTop.Group_Power.Group_Num.Txt_Max:SetText(curPower)
end

function DataModel.UnLockPrisonerRoom()
  local roomTypeId = tonumber(DataModel.selectTypeId)
  local buildTypeCA = PlayerData:GetFactoryData(roomTypeId, "PrisonRoomTypeFactory")
  local ctr = DataModel.buildCtrList[roomTypeId]
  if ctr then
    if buildTypeCA.sizeType == "RoomA" then
      if ctr.UI_Prison_BuildingLevelUp_Small then
        ctr.UI_Prison_BuildingLevelUp_Small:SetActive(false)
        ctr.UI_Prison_BuildingLevelUp_Small:SetActive(true)
      end
    elseif buildTypeCA.sizeType == "RoomB" and ctr.UI_Prison_BuildingLevelUp_Big then
      ctr.UI_Prison_BuildingLevelUp_Big:SetActive(false)
      ctr.UI_Prison_BuildingLevelUp_Big:SetActive(true)
    end
    ctr:SelectPlayAnim("CompleteConstruction")
  end
  DataModel.RefreshAllRoom()
  local curPower = PrisonData.GetCurPower()
  local usePower = PrisonData.GetUsePower()
  View.Img_BGTop.Group_Power.Group_Num.Txt_Own:SetText(usePower)
  View.Img_BGTop.Group_Power.Group_Num.Txt_Max:SetText(curPower)
end

function DataModel.GetRoomOccupyPower(roomTypeId, roomId)
  local prisonCA = DataModel.prisonCA
  local roomCA = PlayerData:GetFactoryData(roomId, "PrisonRoomFactory")
  local occupyPower = 0
  if PrisonData.ProductRoomTypeIdToIndexMap[roomTypeId] then
    local productRoomList = PrisonData.GetProductRoomList() or {}
    local roomData = productRoomList[tostring(PrisonData.ProductRoomTypeIdToIndexMap[roomTypeId])] or {}
    occupyPower = math.floor(table.count(roomData) // 3) * prisonCA.workshopSpaceOccupyPower
  elseif PrisonData.CellRoomTypeIdToRoomIndexMap[roomTypeId] then
    local cellRoomList = PrisonData.GetCellRoomList() or {}
    local roomData = cellRoomList[tostring(PrisonData.CellRoomTypeIdToRoomIndexMap[roomTypeId])] or {}
    occupyPower = table.count(roomData) * prisonCA.cellSpaceOccupyPower
  else
    occupyPower = roomCA.occupyPower
  end
  return occupyPower
end

function DataModel.RefreshQuestRed()
  View.Group_Navigation.Img_RedPoint:SetActive(PrisonData.IsHaveCanReceiveQuest())
end

function DataModel.QuestTraceRefresh()
  local questId = PlayerData:GetPlayerPrefs("int", "PrisonQuestTrace")
  View.Group_Navigation.Btn_Navigation.Txt_Target:SetActive(questId ~= 0)
  if questId ~= 0 then
    local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
    View.Group_Navigation.Btn_Navigation.Txt_Target:SetText(questCA.describe)
  end
end

function DataModel.RefreshRoomCharacterAnim()
  for _, roomCfg in pairs(DataModel.prisonCA.prison) do
    local buildTypeCA = PlayerData:GetFactoryData(roomCfg.id, "PrisonRoomTypeFactory")
    local roomCtr = View.Group_Bg.ScrollView_.Viewport.Content[buildTypeCA.prefabName]
    if roomCtr then
      local animCtr = roomCtr.Group_Anim
      if animCtr then
        local roomStatus = DataModel.GetRoomStatus(roomCfg.id)
        local showAnimCtr = roomStatus == DataModel.RoomStatus.Normal and (#buildTypeCA.npcAnimList > 0 or 0 < #buildTypeCA.prisonerAnimList)
        if showAnimCtr then
          local roomLvCfg = DataModel.GetRoomLvCfg(roomCfg.id)
          if #buildTypeCA.npcAnimList > 0 then
            local num = roomLvCfg.npcNum
            for i = 1, num do
              local animCfg = buildTypeCA.npcAnimList[i]
              if animCfg then
                local uiCtr = animCtr[animCfg.generatePrefab]
                if uiCtr and animCfg.uiAnim and animCfg.uiAnim ~= "" then
                  View.self:SelectPlayAnim(uiCtr.self, animCfg.uiAnim)
                end
                local spineCtr = uiCtr and uiCtr.SpineAnimation_
                if spineCtr then
                  local characterCA = PlayerData:GetFactoryData(animCfg.npc, "HomeCharacterFactory")
                  spineCtr:SetData(characterCA.resDir)
                  spineCtr:SetActionWithoutMix(animCfg.spineAnim, true, true)
                end
              end
            end
          elseif 0 < #buildTypeCA.prisonerAnimList then
            local prisonerList = PrisonData.GetPrisonPrisoners()
            local allLivePrisoner = {}
            for u_pid, v in pairs(prisonerList) do
              if v.bed_id and v.bed_id ~= "" and not PrisonData.IsPrisonerInMedicalRoom(u_pid) and not PrisonData.IsPrisonerInProductRoom(u_pid) and not PrisonData.IsPrisonerInDetentionRoom(u_pid) and not PrisonData.IsPrisonerInMaterialRoom() then
                table.insert(allLivePrisoner, u_pid)
              end
            end
            if 0 < #allLivePrisoner and 0 < roomLvCfg.prisonerNum then
              local num = roomLvCfg.prisonerNum
              for i = 1, num do
                local animCfg = buildTypeCA.prisonerAnimList[i]
                if animCfg then
                  local random = math.random(1, #allLivePrisoner)
                  local u_pid = allLivePrisoner[random]
                  local prisonData = PrisonData.GetPrisoner(u_pid)
                  local prisonerCA = PlayerData:GetFactoryData(prisonData.prisoner_id, "PrisonerFactory")
                  local characterId = prisonerCA.PrisonerAnimation
                  local uiCtr = animCtr[animCfg.generatePrefab]
                  if uiCtr and animCfg.uiAnim and animCfg.uiAnim ~= "" then
                    View.self:SelectPlayAnim(uiCtr.self, animCfg.uiAnim)
                  end
                  local spineCtr = uiCtr and uiCtr.SpineAnimation_
                  if spineCtr then
                    local characterCA = PlayerData:GetFactoryData(characterId, "HomeCharacterFactory")
                    spineCtr:SetData(characterCA.resDir)
                    spineCtr:SetActionWithoutMix(animCfg.spineAnim, true, true)
                  end
                  allLivePrisoner[random] = nil
                end
              end
            else
              showAnimCtr = false
            end
          end
        end
        animCtr:SetActive(showAnimCtr)
      end
    end
  end
end

function DataModel.IsCreateRoom(roomTypeId)
  roomTypeId = tonumber(roomTypeId)
  return roomTypeId == 87500017 or roomTypeId == 87500018 or roomTypeId == 87500019 or roomTypeId == 87500020
end

function DataModel.IsRoomCanUpgrade(roomTypeId)
  local buildTypeCA = PlayerData:GetFactoryData(roomTypeId, "PrisonRoomTypeFactory")
  if PrisonData.ProductRoomTypeIdToIndexMap[roomTypeId] then
    return false
  elseif PrisonData.CellRoomTypeIdToRoomIndexMap[roomTypeId] then
    return false
  elseif buildTypeCA.isInitial then
    return false
  else
    local state = DataModel.GetRoomStatus(roomTypeId)
    if state ~= DataModel.RoomStatus.Normal then
      return false
    end
    local serverData = DataModel.GetRoomSeverData(roomTypeId)
    local level = serverData and serverData.lv or 0
    local nextRoomLvCfg = DataModel.GetRoomLvCfg(roomTypeId, level + 1)
    if not nextRoomLvCfg then
      return false
    end
    local nextRoomCA = PlayerData:GetFactoryData(nextRoomLvCfg.config, "PrisonRoomFactory")
    local powerEnough = true
    if level == 0 then
      powerEnough = PrisonData.GetUsePower() + nextRoomCA.occupyPower <= PrisonData.GetCurPower()
    else
      local roomLvCfg = DataModel.GetRoomLvCfg(roomTypeId)
      local roomCA = PlayerData:GetFactoryData(roomLvCfg.config, "PrisonRoomFactory")
      powerEnough = PrisonData.GetUsePower() + nextRoomCA.occupyPower - roomCA.occupyPower <= PrisonData.GetCurPower()
    end
    if not powerEnough then
      return false
    end
    local isCreateRoom = DataModel.IsCreateRoom(roomTypeId)
    if isCreateRoom then
      local createRoomLv = 0
      local buildRoomList = PrisonData.GetBuildList()
      if buildRoomList["87500010"] then
        createRoomLv = buildRoomList["87500010"].lv
      end
      if createRoomLv < nextRoomLvCfg.level then
        return false
      end
    else
      local prisonLv = PrisonData.GetPrisonLv()
      if prisonLv < nextRoomLvCfg.level then
        return false
      end
    end
    for i, v in pairs(nextRoomCA.lvUpCost) do
      if PlayerData:GetGoodsById(v.id).num < v.num then
        return false
      end
    end
  end
  return true
end

function DataModel.IsAutoOpenMarginTip()
  if PrisonData.GetMargin() <= 0 then
    UIManager:Open("UI/Prison/Contract/PrisonContractManage/PrisonContractManage", Json.encode({autoOpen = true}))
  end
end

function DataModel.AutoSetMargin()
  local marginSwitchOn = PrisonData.GetMarginSwitch() == 1
  if marginSwitchOn then
    local prisonCA = PrisonData.GetPrisonCA()
    local marginMax = 0
    for _, v in pairs(prisonCA.prisonCostPrice) do
      if v.id == 11400001 then
        marginMax = v.num
      end
    end
    local margin = PrisonData.GetMargin()
    local autoLimitMargin = math.floor(marginMax * 0.8)
    if margin < autoLimitMargin then
      local needAddNum = marginMax - margin
      local haveNum = PlayerData:GetGoodsById(11400001).num
      if 0 < haveNum then
        local addNum = needAddNum <= haveNum and needAddNum or haveNum
        PrisonData.SetMargin(nil, addNum, 1)
      else
        DataModel.IsAutoOpenMarginTip()
      end
    end
  else
    DataModel.IsAutoOpenMarginTip()
  end
end

function DataModel.PrisonerRelease()
  local function callBack(json)
    if json.release_prisoner and table.count(json.release_prisoner) > 0 then
      local function callBack()
        if json.reward then
          CommonTips.OpenShowItem(json.reward, DataModel.PrisonerEscape)
        else
          DataModel.PrisonerEscape()
        end
      end
      
      UIManager:Open("UI/Prison/PrisonerList/PrisonerRelease/PrisonerRelease", Json.encode(json), callBack)
    else
      DataModel.PrisonerEscape()
    end
    View.Img_RayCastMask:SetActive(false)
  end
  
  PrisonData.ReleasePrisoner(callBack)
end

function DataModel.PrisonerEscape()
  local function callBack(json)
    local escapeSuccessPrisoners = json.release_prisoner or {}
    
    local escapeFailPrisoners = json.fail_release_prisoner or {}
    if table.count(escapeSuccessPrisoners) > 0 or table.count(escapeFailPrisoners) > 0 then
      UIManager:Open("UI/Prison/PrisonerList/PrisonerEscape/PrisonerEscape", Json.encode({escapeSuccessPrisoners = escapeSuccessPrisoners, escapeFailPrisoners = escapeFailPrisoners}), DataModel.AutoSetMargin)
    else
      DataModel.AutoSetMargin()
    end
    View.Img_BGTop.Group_Prisoner:SetActive(true)
    DataModel.RefreshPrisonerNum()
  end
  
  PrisonData.EscapePrisoner(callBack)
end

function DataModel.RefreshPrisonerNum()
  local cellRoomList = PrisonData.GetCellRoomList()
  local curLiveNum = 0
  for roomIndex, roomData in pairs(cellRoomList) do
    for areaId, v in pairs(roomData) do
      curLiveNum = curLiveNum + table.count(PrisonData.GetLivePrisonerList(roomIndex, areaId))
    end
  end
  local totalNum = 0
  for i, v in pairs(cellRoomList) do
    totalNum = totalNum + table.count(v) * DataModel.prisonCA.roomPrisonerNum
  end
  View.Img_BGTop.Group_Prisoner.Group_Num.Txt_Own:SetText(curLiveNum)
  View.Img_BGTop.Group_Prisoner.Group_Num.Txt_Max:SetText(totalNum)
  local backpackCount = table.count(PlayerData.ServerData.user_prison_info.carrying_backpack)
  local prisonerCount = table.count(PlayerData.ServerData.user_prison_info.prison_backpack)
  View.Img_BGTop.Group_Prisoner.Btn_.Img_RedPoint:SetActive(0 < backpackCount and prisonerCount < 168)
end

return DataModel
