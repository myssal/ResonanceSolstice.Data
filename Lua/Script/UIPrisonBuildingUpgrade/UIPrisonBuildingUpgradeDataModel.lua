local View = require("UIPrisonBuildingUpgrade/UIPrisonBuildingUpgradeView")
local DataModel = {}
DataModel.UpgradeState = {
  CanUpgrade = 1,
  CantUpgrade = 2,
  Upgraded = 3
}
DataModel.serverRoomData = nil
DataModel.curRoomId = nil
DataModel.buildType = nil
DataModel.selectRoomId = nil
DataModel.levelElementList = {}

function DataModel.SetJsonData(json)
  if json then
    local data = Json.decode(json)
    DataModel.buildType = tonumber(data.buildType)
  end
end

function DataModel.InitData()
  DataModel.serverRoomData = nil
  local typeId = DataModel.buildType
  if typeId then
    local isCreateRoom = DataModel.IsCreateRoom(DataModel.buildType)
    local roomTypeCA = PlayerData:GetFactoryData(typeId, "PrisonRoomTypeFactory")
    local serverBuildList = PrisonData.GetBuildList()
    local serverData = serverBuildList[tostring(typeId)]
    if not serverData then
      if isCreateRoom then
        local roomId = roomTypeCA.creatRoomList[1].config
        DataModel.curRoomId = roomId
      else
        local roomId = roomTypeCA.roomList[1].config
        DataModel.curRoomId = roomId
      end
    else
      DataModel.serverRoomData = serverData
      if isCreateRoom then
        for i, v in ipairs(roomTypeCA.creatRoomList) do
          local roomCA = PlayerData:GetFactoryData(v.config, "PrisonRoomFactory")
          if serverData.lv == roomCA.roomLevel then
            DataModel.curRoomId = v.config
            break
          end
        end
      else
        for i, v in ipairs(roomTypeCA.roomList) do
          local roomCA = PlayerData:GetFactoryData(v.config, "PrisonRoomFactory")
          if serverData.lv == roomCA.roomLevel then
            DataModel.curRoomId = v.config
            break
          end
        end
      end
    end
  end
  DataModel.selectRoomId = nil
end

function DataModel.RefreshOnShow()
  local roomCA = PlayerData:GetFactoryData(DataModel.curRoomId, "PrisonRoomFactory")
  local roomTypeCA = PlayerData:GetFactoryData(DataModel.buildType, "PrisonRoomTypeFactory")
  local lv = DataModel.serverRoomData and DataModel.serverRoomData.lv or 1
  View.Group_Left.Group_CurrentLV.Txt_CurrentLV:SetText("LV" .. lv)
  local prisonLv = PrisonData.GetPrisonLv()
  local prisonData = PrisonData.GetSeverPrisonData()
  View.Group_Left.Group_Room.Group_Big:SetActive(roomTypeCA.sizeType == "RoomB")
  View.Group_Left.Group_Room.Group_Small:SetActive(roomTypeCA.sizeType == "RoomA")
  View.Group_Left.Group_Room.Group_Big.Btn_RoomB.Img_BG:SetSprite(roomCA.roomPic)
  View.Group_Left.Group_Room.Group_Big.Img_RoomBG.UI_Prison_BuildingLevelUp_Big:SetActive(false)
  View.Group_Left.Group_Room.Group_Small.Btn_RoomA.Img_BG:SetSprite(roomCA.roomPic)
  View.Group_Left.Group_Room.Group_Small.Img_RoomBG.UI_Prison_BuildingLevelUp_Small:SetActive(false)
  DataModel.levelElementList = {}
  DataModel.roomLvData = {}
  table.insert(DataModel.roomLvData, {})
  table.insert(DataModel.roomLvData, {})
  local isCreateRoom = DataModel.buildType == 87500017 or DataModel.buildType == 87500018 or DataModel.buildType == 87500019 or DataModel.buildType == 87500020
  if isCreateRoom then
    for i, v in ipairs(roomTypeCA.creatRoomList) do
      table.insert(DataModel.roomLvData, v)
    end
  else
    for i, v in ipairs(roomTypeCA.roomList) do
      table.insert(DataModel.roomLvData, v)
    end
  end
  table.insert(DataModel.roomLvData, {})
  table.insert(DataModel.roomLvData, {})
  local curLevelIndex = lv + 2
  local selectLevelIndex = curLevelIndex
  if curLevelIndex < #DataModel.roomLvData - 2 then
    local nextLevelIndex = curLevelIndex + 1
    if DataModel.GetUpgradeState(nextLevelIndex) == DataModel.UpgradeState.CanUpgrade then
      selectLevelIndex = nextLevelIndex
    end
  end
  DataModel.ClickLevel(selectLevelIndex)
  View.Group_Right.Group_Upgrade.ScrollGrid_Level.grid.self:SetDataCount(#DataModel.roomLvData)
  View.Group_Right.Group_Upgrade.ScrollGrid_Level.grid.self:RefreshAllElement()
  View.Group_Right.Group_Upgrade.ScrollGrid_Level.grid.self:MoveToPos(selectLevelIndex - 2)
  local isPowerRoom = DataModel.IsPowerRoom(DataModel.buildType)
  View.Group_Left.Group_OtherRoomLeft:SetActive(not isPowerRoom)
  View.Group_Left.Group_PowerRoomLeft:SetActive(isPowerRoom)
  View.Group_Right.Group_Btn:SetActive(isPowerRoom)
  View.Group_Right.Txt_Title:SetActive(not isPowerRoom)
  View.Group_Right.Group_Upgrade:SetActive(true)
  View.Group_Right.Group_CC:SetActive(false)
  local anchoredPosY = isPowerRoom and 133 or 0
  View.Group_Left.Group_Room:SetAnchoredPositionY(anchoredPosY)
  View.Group_Left.Group_CurrentLV:SetAnchoredPositionY(anchoredPosY)
  View.Group_Left.Group_RoomDetail:SetAnchoredPositionY(anchoredPosY)
  if isPowerRoom then
    DataModel.RefreshPowerRoomPower()
    View.Group_Left.Group_PowerRoomLeft.Group_PrisonDetails.Group_PrisonLV.Txt_LV:SetText(prisonLv)
    local maxCount = 0
    local powerRoomTypeCA = PlayerData:GetFactoryData(87500012, "PrisonRoomTypeFactory")
    if #powerRoomTypeCA.roomList > 0 then
      local maxLvRoomId = powerRoomTypeCA.roomList[#powerRoomTypeCA.roomList].config
      maxCount = PlayerData:GetFactoryData(maxLvRoomId, "PrisonRoomFactory").slotNum
    end
    View.Group_Right.Group_Btn.Group_Machine.Btn_:SetActive(true)
    View.Group_Right.Group_Btn.Group_Machine.Group_:SetActive(false)
    View.Group_Right.Group_Btn.Group_RoomUp.Btn_:SetActive(true)
    View.Group_Right.Group_Btn.Group_RoomUp.Group_:SetActive(true)
    local installedNum = PrisonData.GetSeverPrisonData().power_socket_num
    View.Group_Right.Group_Btn.Group_Machine.Btn_.Txt_:SetText(string.format(GetText(80608469), installedNum, maxCount))
    View.Group_Right.Group_Btn.Group_Machine.Group_.Txt_:SetText(string.format(GetText(80608469), installedNum, maxCount))
  else
    View.Group_Right.Txt_Title:SetText(string.format(GetText(80607612), roomTypeCA.roomName))
    View.Group_Left.Group_OtherRoomLeft.Group_PrisonDetails.Group_TotalPower.Txt_:SetText(PrisonData.GetUsePower() .. "/" .. PrisonData.GetCurPower())
    View.Group_Left.Group_OtherRoomLeft.Group_Power:SetActive(0 < roomCA.occupyPower)
    View.Group_Left.Group_OtherRoomLeft.Group_Power.Txt_:SetText(roomCA.occupyPower)
    View.Group_Left.Group_OtherRoomLeft.Group_PrisonDetails.Group_PrisonLV.Txt_LV:SetText(prisonLv)
    View.Group_Left.Group_OtherRoomLeft.Group_PrisonDetails.Group_Safety.Txt_SafetyNum:SetText(prisonData.safety)
    View.Group_Left.Group_OtherRoomLeft.Group_PrisonDetails.Group_Stability.Txt_StabilityNum:SetText(prisonData.stability)
    View.Group_Left.Group_OtherRoomLeft.Group_PrisonDetails.Group_Obedience.Txt_ObedienceNum:SetText(prisonData.obedience)
    View.Group_Left.Group_OtherRoomLeft.Group_PrisonDetails.Group_Hygiene.Txt_HygieneNum:SetText(prisonData.hygiene)
  end
  View.Group_Right.Group_Upgrade.Group_CanBuild.Btn_Build:SetBtnInteractable(true)
end

function DataModel.IsCreateRoom(typeId)
  typeId = tonumber(typeId)
  return typeId == 87500017 or typeId == 87500018 or typeId == 87500019 or typeId == 87500020
end

function DataModel.IsPowerRoom(typeId)
  typeId = tonumber(typeId)
  return typeId == 87500012
end

function DataModel.RefreshPowerRoomPower()
  local curPower = PrisonData.GetCurPower()
  View.Group_Left.Group_PowerRoomLeft.Group_Power.Group_Total.Txt_Num:SetText(curPower)
  local usePower = PrisonData.GetUsePower()
  View.Group_Left.Group_PowerRoomLeft.Group_Power.Group_Current.Txt_Num:SetText(usePower)
  local extraPower = PrisonData.GetPowerSocketPower()
  View.Group_Left.Group_PowerRoomLeft.Group_Power.Group_Extra.Txt_Num:SetText(extraPower)
  local productUsePower = PrisonData.GetProductUsePower()
  local materialUsePower = PrisonData.GetMaterialProductUsePower()
  local productMachineUsePower = PrisonData.GetProductMachineUsePower()
  local normalMachineUsePower = PrisonData.GetNormalMachineUsePower()
  View.Group_Left.Group_PowerRoomLeft.Group_Power.Group_Condition.Group_CommonWorkshop.Group_Power.Txt_Num:SetText(productUsePower)
  View.Group_Left.Group_PowerRoomLeft.Group_Power.Group_Condition.Group_MaterialWorkshop.Group_Power.Txt_Num:SetText(materialUsePower)
  View.Group_Left.Group_PowerRoomLeft.Group_Power.Group_Condition.Group_Facility.Group_Power.Txt_Num:SetText(productMachineUsePower)
  View.Group_Left.Group_PowerRoomLeft.Group_Power.Group_Condition.Group_Other.Group_Power.Txt_Num:SetText(normalMachineUsePower)
  View.Group_Left.Group_PowerRoomLeft.Group_Power.Group_Condition.Group_Circle.Img_CircleCommonWorkshop:SetFilledImgAmount(0 < productUsePower and 1 or 0)
  View.Group_Left.Group_PowerRoomLeft.Group_Power.Group_Condition.Group_Circle.Img_CircleMaterialWorkshop:SetFilledImgAmount((materialUsePower + productMachineUsePower + normalMachineUsePower) / usePower)
  View.Group_Left.Group_PowerRoomLeft.Group_Power.Group_Condition.Group_Circle.Img_CircleFacility:SetFilledImgAmount((productMachineUsePower + normalMachineUsePower) / usePower)
  View.Group_Left.Group_PowerRoomLeft.Group_Power.Group_Condition.Group_Circle.Img_CircleOther:SetFilledImgAmount(normalMachineUsePower / usePower)
  local maxCount = 0
  local powerRoomTypeCA = PlayerData:GetFactoryData(87500012, "PrisonRoomTypeFactory")
  if 0 < #powerRoomTypeCA.roomList then
    local maxLvRoomId = powerRoomTypeCA.roomList[#powerRoomTypeCA.roomList].config
    maxCount = PlayerData:GetFactoryData(maxLvRoomId, "PrisonRoomFactory").slotNum
  end
  View.Group_Right.Group_Btn.Group_Machine.Btn_:SetActive(true)
  View.Group_Right.Group_Btn.Group_RoomUp.Btn_:SetActive(true)
  local installedNum = PrisonData.GetSeverPrisonData().power_socket_num
  View.Group_Right.Group_Btn.Group_Machine.Btn_.Txt_:SetText(string.format(GetText(80608469), installedNum, maxCount))
  View.Group_Right.Group_Btn.Group_Machine.Group_.Txt_:SetText(string.format(GetText(80608469), installedNum, maxCount))
end

function DataModel.RefreshPowerRoomPowerSocket()
  local curRoomCA = PlayerData:GetFactoryData(DataModel.curRoomId, "PrisonRoomFactory")
  local curMaxCount = curRoomCA.slotNum
  local maxCount = 0
  local powerRoomTypeCA = PlayerData:GetFactoryData(87500012, "PrisonRoomTypeFactory")
  if 0 < #powerRoomTypeCA.roomList then
    local maxLvRoomId = powerRoomTypeCA.roomList[#powerRoomTypeCA.roomList].config
    maxCount = PlayerData:GetFactoryData(maxLvRoomId, "PrisonRoomFactory").slotNum
  end
  local installedNum = PrisonData.GetSeverPrisonData().power_socket_num
  local reachMax = installedNum == maxCount
  View.Group_Right.Group_CC.Btn_NotInstall:SetActive(installedNum == maxCount)
  View.Group_Right.Group_CC.Btn_Install:SetActive(not reachMax and curMaxCount > installedNum)
  View.Group_Right.Group_CC.Btn_Not:SetActive(not reachMax and curMaxCount <= installedNum)
  View.Group_Right.Group_CC.StaticGrid_MK.grid.self:RefreshAllElement()
end

function DataModel.GetUpgradeState(lvCfgIndex)
  local lvCfg = DataModel.roomLvData[lvCfgIndex]
  local roomCA = PlayerData:GetFactoryData(lvCfg.config, "PrisonRoomFactory")
  local serverData = DataModel.serverRoomData
  local serverLv = serverData and serverData.lv or 0
  if serverLv >= roomCA.roomLevel then
    return DataModel.UpgradeState.Upgraded
  end
  if roomCA.roomLevel > 1 and serverLv < roomCA.roomLevel - 1 then
    return DataModel.UpgradeState.CantUpgrade
  end
  local curRoomCA = PlayerData:GetFactoryData(DataModel.curRoomId, "PrisonRoomFactory")
  if PrisonData.GetUsePower() + roomCA.occupyPower - curRoomCA.occupyPower > PrisonData.GetCurPower() then
    return DataModel.UpgradeState.CantUpgrade
  end
  local isCreateRoom = DataModel.IsCreateRoom(DataModel.buildType)
  if isCreateRoom then
    local buildRoomList = PrisonData.GetBuildList()
    local createRoomLv = buildRoomList["87500010"] and buildRoomList["87500010"].lv or 0
    if createRoomLv < lvCfg.level then
      return DataModel.UpgradeState.CantUpgrade
    end
  else
    local prisonLv = PrisonData.GetPrisonLv()
    if prisonLv < lvCfg.level then
      return DataModel.UpgradeState.CantUpgrade
    end
  end
  for i, v in pairs(roomCA.lvUpCost) do
    if PlayerData:GetGoodsById(v.id).num < v.num then
      return DataModel.UpgradeState.CantUpgrade
    end
  end
  return DataModel.UpgradeState.CanUpgrade
end

function DataModel.ClickLevel(lvCfgIndex)
  local prisonCA = PrisonData.GetPrisonCA()
  local roomTypeCA = PlayerData:GetFactoryData(DataModel.buildType, "PrisonRoomTypeFactory")
  local lvCfg = DataModel.roomLvData[lvCfgIndex]
  if DataModel.selectRoomId == lvCfg.config then
    return
  end
  if DataModel.selectRoomId then
    local ctr = DataModel.levelElementList[DataModel.selectRoomId]
    if ctr then
      if ctr.Group_Builded.IsActive then
        ctr.Group_Builded.Group_Choose:SetActive(false)
      elseif ctr.Group_Current.IsActive then
        ctr.Group_Current.Group_Choose:SetActive(false)
      elseif ctr.Group_LockCanBuild.IsActive then
        ctr.Group_LockCanBuild.Group_Choose:SetActive(false)
      elseif ctr.Group_Lock.IsActive then
        ctr.Group_Lock.Group_Choose:SetActive(false)
      end
    end
  end
  local ctr = DataModel.levelElementList[lvCfg.config]
  if ctr then
    if ctr.Group_Builded.IsActive then
      ctr.Group_Builded.Group_Choose:SetActive(true)
    elseif ctr.Group_Current.IsActive then
      ctr.Group_Current.Group_Choose:SetActive(true)
    elseif ctr.Group_LockCanBuild.IsActive then
      ctr.Group_LockCanBuild.Group_Choose:SetActive(true)
    elseif ctr.Group_Lock.IsActive then
      ctr.Group_Lock.Group_Choose:SetActive(true)
    end
  end
  DataModel.selectRoomId = lvCfg.config
  local roomCA = PlayerData:GetFactoryData(lvCfg.config, "PrisonRoomFactory")
  local state = DataModel.GetUpgradeState(lvCfgIndex)
  local prisonLv = PrisonData.GetPrisonLv()
  if View.Group_Left.Group_Room.Group_Big.IsActive then
    View.Group_Left.Group_Room.Group_Big.Btn_RoomB.Img_BG:SetSprite(roomCA.roomPic)
  elseif View.Group_Left.Group_Room.Group_Small.IsActive then
    View.Group_Left.Group_Room.Group_Small.Btn_RoomA.Img_BG:SetSprite(roomCA.roomPic)
  end
  View.Group_Left.Group_RoomDetail.Txt_:SetText(roomCA.roomDesc)
  View.Group_Left.Group_OtherRoomLeft.Txt_Des:SetText(roomCA.detailDesc)
  local isCreateRoom = DataModel.IsCreateRoom(DataModel.buildType)
  View.Group_Right.Group_Upgrade.Group_UpgradeCondition.Group_CreatLV:SetActive(isCreateRoom)
  View.Group_Right.Group_Upgrade.Group_UpgradeCondition.Group_PrisonLV:SetActive(not isCreateRoom)
  local buildRoomList = PrisonData.GetBuildList()
  local createRoomLv = buildRoomList["87500010"] and buildRoomList["87500010"].lv or 0
  if isCreateRoom then
    View.Group_Right.Group_Upgrade.Group_UpgradeCondition.Group_CreatLV.Txt_CreatLV:SetActive(createRoomLv >= lvCfg.level)
    View.Group_Right.Group_Upgrade.Group_UpgradeCondition.Group_CreatLV.Txt_CreatLVNUm:SetActive(createRoomLv >= lvCfg.level)
    View.Group_Right.Group_Upgrade.Group_UpgradeCondition.Group_CreatLV.Txt_CreatLVNUm:SetText(lvCfg.level)
    View.Group_Right.Group_Upgrade.Group_UpgradeCondition.Group_CreatLV.Txt_CreatLVLock:SetActive(createRoomLv < lvCfg.level)
    View.Group_Right.Group_Upgrade.Group_UpgradeCondition.Group_CreatLV.Txt_CreatLVLockNum:SetActive(createRoomLv < lvCfg.level)
    View.Group_Right.Group_Upgrade.Group_UpgradeCondition.Group_CreatLV.Txt_CreatLVLockNum:SetText(lvCfg.level)
  else
    View.Group_Right.Group_Upgrade.Group_UpgradeCondition.Group_PrisonLV.Txt_PrisonLV:SetActive(prisonLv >= lvCfg.level)
    View.Group_Right.Group_Upgrade.Group_UpgradeCondition.Group_PrisonLV.Txt_PrisonLVNUm:SetActive(prisonLv >= lvCfg.level)
    View.Group_Right.Group_Upgrade.Group_UpgradeCondition.Group_PrisonLV.Txt_PrisonLVNUm:SetText(lvCfg.level)
    View.Group_Right.Group_Upgrade.Group_UpgradeCondition.Group_PrisonLV.Txt_PrisonLVLock:SetActive(prisonLv < lvCfg.level)
    View.Group_Right.Group_Upgrade.Group_UpgradeCondition.Group_PrisonLV.Txt_PrisonLVLockNum:SetActive(prisonLv < lvCfg.level)
    View.Group_Right.Group_Upgrade.Group_UpgradeCondition.Group_PrisonLV.Txt_PrisonLVLockNum:SetText(lvCfg.level)
  end
  View.Group_Right.Group_Upgrade.Group_Builded:SetActive(state == DataModel.UpgradeState.Upgraded)
  View.Group_Right.Group_Upgrade.Group_CanBuild:SetActive(state == DataModel.UpgradeState.CanUpgrade)
  View.Group_Right.Group_Upgrade.Group_CanBuild.Btn_Build:SetClickParam(lvCfgIndex)
  View.Group_Right.Group_Upgrade.Group_CanBuild.Btn_Complete:SetClickParam(lvCfgIndex)
  View.Group_Right.Group_Upgrade.Group_CannotBuild:SetActive(state == DataModel.UpgradeState.CantUpgrade)
  if state == DataModel.UpgradeState.CantUpgrade then
    local serverLv = DataModel.serverRoomData and DataModel.serverRoomData.lv or 0
    local showBeforeLvCondition = roomCA.roomLevel > 1 and serverLv < roomCA.roomLevel - 1
    local showCondition = showBeforeLvCondition
    local showPrisonLvCondition = not showCondition and not isCreateRoom and prisonLv < lvCfg.level
    showCondition = showPrisonLvCondition and true or showCondition
    local showCreteRoomLvCondition = not showCondition and isCreateRoom and createRoomLv < lvCfg.level
    showCondition = showCreteRoomLvCondition and true or showCondition
    local curRoomCA = PlayerData:GetFactoryData(DataModel.curRoomId, "PrisonRoomFactory")
    local showPowerCondition = not showCondition and PrisonData.GetUsePower() + roomCA.occupyPower - curRoomCA.occupyPower > PrisonData.GetCurPower()
    showCondition = showPowerCondition and true or showCondition
    local costEnough = true
    for i, v in pairs(roomCA.lvUpCost) do
      if PlayerData:GetGoodsById(v.id).num < v.num then
        costEnough = false
        break
      end
    end
    local showCostCondition = not showCondition and not costEnough
    View.Group_Right.Group_Upgrade.Group_CannotBuild.Txt_NoLevel:SetActive(showBeforeLvCondition)
    View.Group_Right.Group_Upgrade.Group_CannotBuild.Txt_NoPrisonLevel:SetActive(showPrisonLvCondition)
    View.Group_Right.Group_Upgrade.Group_CannotBuild.Btn_CreateRoom:SetActive(showCreteRoomLvCondition)
    View.Group_Right.Group_Upgrade.Group_CannotBuild.Btn_Power:SetActive(showPowerCondition)
    View.Group_Right.Group_Upgrade.Group_CannotBuild.Txt_NoCondition:SetActive(showCostCondition)
  end
  local remainTime = roomCA.upgradeTime
  View.Group_Right.Group_Upgrade.Group_CanBuild.Group_Time:SetActive(0 < remainTime)
  View.Group_Right.Group_Upgrade.Group_CanBuild.Btn_Complete:SetActive(0 < remainTime)
  View.Group_Right.Group_Upgrade.Group_CanBuild.Group_Cost:SetActive(0 < remainTime)
  if 0 < remainTime then
    local timeTbl = TimeUtil:SecondToTableHMS(remainTime)
    View.Group_Right.Group_Upgrade.Group_CanBuild.Group_Time.Txt_Num:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
    for i, v in ipairs(prisonCA.diamondFaster) do
      if v.timeFaster >= roomCA.upgradeTime then
        local itemCA = PlayerData:GetFactoryData(v.diamond)
        View.Group_Right.Group_Upgrade.Group_CanBuild.Group_Cost.Img_Money:SetSprite(itemCA.buyPath)
        View.Group_Right.Group_Upgrade.Group_CanBuild.Group_Cost.Txt_Num:SetText(v.diamondNum)
        break
      end
    end
  end
  local count = table.count(roomCA.lvUpCost) < 5 and 5 or table.count(roomCA.lvUpCost)
  View.Group_Right.Group_Upgrade.Group_Material.Group_Required.ScrollGrid_Required.grid.self:SetDataCount(count)
  View.Group_Right.Group_Upgrade.Group_Material.Group_Required.ScrollGrid_Required.grid.self:RefreshAllElement()
  local curRoomCA = PlayerData:GetFactoryData(DataModel.curRoomId, "PrisonRoomFactory")
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Safety:SetActive(roomCA.roomSafety ~= 0)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Safety.Txt_SafetyNum:SetText(roomCA.roomSafety)
  local safeChange = roomCA.roomSafety - curRoomCA.roomSafety
  if state == DataModel.UpgradeState.Upgraded then
    safeChange = 0
  end
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Safety.Img_Up:SetActive(0 < safeChange)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Safety.Img_Down:SetActive(false)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Safety.Txt_SafetyChange:SetActive(safeChange ~= 0)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Safety.Txt_SafetyChange:SetText(math.abs(safeChange))
  local stabilityChange = roomCA.roomStability - curRoomCA.roomStability
  if state == DataModel.UpgradeState.Upgraded then
    stabilityChange = 0
  end
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Stability:SetActive(roomCA.roomStability ~= 0)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Stability.Txt_StabilityNum:SetText(roomCA.roomStability)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Stability.Img_Up:SetActive(0 < stabilityChange)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Stability.Img_Down:SetActive(false)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Stability.Txt_StabilityChange:SetActive(stabilityChange ~= 0)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Stability.Txt_StabilityChange:SetText(math.abs(stabilityChange))
  local obedienceChange = roomCA.roomObedience - curRoomCA.roomObedience
  if state == DataModel.UpgradeState.Upgraded then
    obedienceChange = 0
  end
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Obedience:SetActive(roomCA.roomObedience ~= 0)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Obedience.Txt_ObedienceNum:SetText(roomCA.roomObedience)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Obedience.Img_Up:SetActive(0 < obedienceChange)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Obedience.Img_Down:SetActive(false)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Obedience.Txt_ObedienceChange:SetActive(obedienceChange ~= 0)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Obedience.Txt_ObedienceChange:SetText(math.abs(obedienceChange))
  local hygieneChange = roomCA.roomHygiene - curRoomCA.roomHygiene
  if state == DataModel.UpgradeState.Upgraded then
    hygieneChange = 0
  end
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Hygiene:SetActive(roomCA.roomHygiene ~= 0)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Hygiene.Txt_HygieneNum:SetText(roomCA.roomHygiene)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Hygiene.Img_Up:SetActive(0 < hygieneChange)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Hygiene.Img_Down:SetActive(false)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Hygiene.Txt_HygieneChange:SetActive(hygieneChange ~= 0)
  View.Group_Right.Group_Upgrade.Group_DU.Group_DU.Group_Hygiene.Txt_HygieneChange:SetText(math.abs(hygieneChange))
  View.Group_Right.Group_Upgrade.Group_Attribute.Group_CommonRoom:SetActive(roomTypeCA.detailIfo == "CommonRoom")
  View.Group_Right.Group_Upgrade.Group_Attribute.Group_MedicalRoom:SetActive(roomTypeCA.detailIfo == "MedicalRoom")
  View.Group_Right.Group_Upgrade.Group_Attribute.Group_PunishmentRoom:SetActive(roomTypeCA.detailIfo == "PunishmentRoom")
  View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter:SetActive(roomTypeCA.detailIfo == "TransitCenter")
  View.Group_Right.Group_Upgrade.Group_Attribute.Group_ParoleRoom:SetActive(roomTypeCA.detailIfo == "ParoleRoom")
  View.Group_Right.Group_Upgrade.Group_Attribute.Group_PowerRoom:SetActive(roomTypeCA.detailIfo == "PowerRoom")
  View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop:SetActive(roomTypeCA.detailIfo == "MaterialWorkShop")
  View.Group_Right.Group_Upgrade.Group_Attribute.Group_CreatRoom:SetActive(roomTypeCA.detailIfo == "CreateRoom")
  if roomTypeCA.detailIfo == "MedicalRoom" then
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MedicalRoom.Group_Bed.Txt_Bed:SetText(GetText(80608188))
    local bedNumChange = roomCA.bedNum - curRoomCA.bedNum
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MedicalRoom.Group_Bed.Txt_BedNum:SetText(roomCA.bedNum)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MedicalRoom.Group_Bed.Img_Up:SetActive(0 < bedNumChange)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MedicalRoom.Group_Bed.Img_Down:SetActive(bedNumChange < 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MedicalRoom.Group_Bed.Txt_BedChange:SetActive(bedNumChange ~= 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MedicalRoom.Group_Bed.Txt_BedChange:SetText(math.abs(bedNumChange))
    local nameList = {
      80608189,
      80608190,
      80608191,
      80608182,
      80608183
    }
    for i = 1, 5 do
      local cur = curRoomCA.cureTimeList[i]
      local show = roomCA.cureTimeList[i]
      local changeTime = show.cureTime - cur.cureTime
      local attributeCtr = View.Group_Right.Group_Upgrade.Group_Attribute.Group_MedicalRoom["Group_Cure" .. i]
      if attributeCtr then
        attributeCtr.Txt_Name:SetText(GetText(nameList[i]))
        attributeCtr.Txt_Time:SetText(show.cureTime .. "s")
        attributeCtr.Img_Up:SetActive(0 < changeTime)
        attributeCtr.Img_Down:SetActive(changeTime < 0)
        attributeCtr.Txt_TimeChange:SetActive(changeTime ~= 0)
        attributeCtr.Txt_TimeChange:SetText(math.abs(changeTime) .. "s")
      end
    end
  elseif roomTypeCA.detailIfo == "PunishmentRoom" then
    local nameList = {
      80608187,
      80608192,
      80608193,
      80608194,
      80608195
    }
    for i = 1, 5 do
      local cur = curRoomCA.timeBrig[i]
      local show = roomCA.timeBrig[i]
      local changeTime = show.time - cur.time
      local attributeCtr = View.Group_Right.Group_Upgrade.Group_Attribute.Group_PunishmentRoom["Group_Punish" .. i]
      if attributeCtr then
        attributeCtr.Txt_Name:SetText(GetText(nameList[i]))
        attributeCtr.Txt_Time:SetText(show.time .. "s")
        attributeCtr.Img_Up:SetActive(0 < changeTime)
        attributeCtr.Img_Down:SetActive(changeTime < 0)
        attributeCtr.Txt_TimeChange:SetActive(changeTime ~= 0)
        attributeCtr.Txt_TimeChange:SetText(math.abs(changeTime) .. "s")
      end
    end
  elseif roomTypeCA.detailIfo == "TransitCenter" then
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Time.Txt_Name:SetText(GetText(80608196))
    local transitTimeChange = roomCA.transitTime - curRoomCA.transitTime
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Time.Txt_Time:SetText(roomCA.transitTime .. "s")
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Time.Img_Up:SetActive(0 < transitTimeChange)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Time.Img_Down:SetActive(transitTimeChange < 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Time.Txt_TimeChange:SetActive(transitTimeChange ~= 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Time.Txt_TimeChange:SetText(math.abs(transitTimeChange) .. "s")
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Num1.Txt_Name:SetText(GetText(80608199))
    local lineNumChange = roomCA.routeLimited - curRoomCA.routeLimited
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Num1.Txt_Time:SetText(roomCA.routeLimited)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Num1.Img_Up:SetActive(0 < lineNumChange)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Num1.Img_Down:SetActive(lineNumChange < 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Num1.Txt_TimeChange:SetActive(lineNumChange ~= 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Num1.Txt_TimeChange:SetText(math.abs(lineNumChange))
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Money1.Txt_Name:SetText(GetText(80608197))
    local goodShowNum = roomCA.transitGoodsCostList[1] and roomCA.transitGoodsCostList[1].num or 0
    local goodCurNum = curRoomCA.transitGoodsCostList[1] and curRoomCA.transitGoodsCostList[1].num or 0
    local goodNumChange = goodShowNum - goodCurNum
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Money1.Txt_Time:SetText(goodShowNum)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Money1.Img_Up:SetActive(0 < goodNumChange)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Money1.Img_Down:SetActive(goodNumChange < 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Money1.Txt_TimeChange:SetActive(goodNumChange ~= 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Money1.Txt_TimeChange:SetText(math.abs(goodNumChange))
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Num2.Txt_Name:SetText(GetText(80608200))
    local teamNumChange = roomCA.fleetLimited - curRoomCA.fleetLimited
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Num2.Txt_Time:SetText(roomCA.fleetLimited)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Num2.Img_Up:SetActive(0 < teamNumChange)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Num2.Img_Down:SetActive(teamNumChange < 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Num2.Txt_TimeChange:SetActive(teamNumChange ~= 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Num2.Txt_TimeChange:SetText(math.abs(teamNumChange))
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Money2.Txt_Name:SetText(GetText(80608198))
    local prisonerShowNum = roomCA.transitPrisonerCostList[1] and roomCA.transitPrisonerCostList[1].num or 0
    local prisonerCurNum = curRoomCA.transitPrisonerCostList[1] and curRoomCA.transitPrisonerCostList[1].num or 0
    local prisonerNumChange = prisonerShowNum - prisonerCurNum
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Money2.Txt_Time:SetText(prisonerShowNum)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Money2.Img_Up:SetActive(0 < prisonerNumChange)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Money2.Img_Down:SetActive(prisonerNumChange < 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Money2.Txt_TimeChange:SetActive(prisonerNumChange ~= 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_TransitCenter.Group_Money2.Txt_TimeChange:SetText(math.abs(prisonerNumChange))
  elseif roomTypeCA.detailIfo == "ParoleRoom" then
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_ParoleRoom.Group_Score.Txt_Name:SetText(GetText(80608201))
    local scoreNumChange = roomCA.lowestScore - curRoomCA.lowestScore
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_ParoleRoom.Group_Score.Txt_Time:SetText(roomCA.lowestScore)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_ParoleRoom.Group_Score.Img_Up:SetActive(0 < scoreNumChange)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_ParoleRoom.Group_Score.Img_Down:SetActive(scoreNumChange < 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_ParoleRoom.Group_Score.Txt_PunishChange:SetActive(scoreNumChange ~= 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_ParoleRoom.Group_Score.Txt_PunishChange:SetText(math.abs(scoreNumChange))
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_ParoleRoom.Group_Ratio.Txt_Name:SetText(GetText(80608202))
    local ratioNumChange = roomCA.parolePayParam - curRoomCA.parolePayParam
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_ParoleRoom.Group_Ratio.Txt_Time:SetText(roomCA.parolePayParam)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_ParoleRoom.Group_Ratio.Img_Up:SetActive(0 < ratioNumChange)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_ParoleRoom.Group_Ratio.Img_Down:SetActive(ratioNumChange < 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_ParoleRoom.Group_Ratio.Txt_TimeChange:SetActive(ratioNumChange ~= 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_ParoleRoom.Group_Ratio.Txt_TimeChange:SetText(math.abs(ratioNumChange))
  elseif roomTypeCA.detailIfo == "PowerRoom" then
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_PowerRoom.Group_Power.Txt_Name:SetText(GetText(80608203))
    local powerNumChange = roomCA.prisonPower - curRoomCA.prisonPower
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_PowerRoom.Group_Power.Txt_Power:SetText(roomCA.prisonPower)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_PowerRoom.Group_Power.Img_Up:SetActive(0 < powerNumChange)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_PowerRoom.Group_Power.Img_Down:SetActive(powerNumChange < 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_PowerRoom.Group_Power.Txt_PowerChange:SetActive(powerNumChange ~= 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_PowerRoom.Group_Power.Txt_PowerChange:SetText(math.abs(powerNumChange))
  elseif roomTypeCA.detailIfo == "MaterialWorkShop" then
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_PrisonerNum.Txt_Name:SetText(GetText(80608118))
    local prisonerNumChange = roomCA.prisonerNum - curRoomCA.prisonerNum
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_PrisonerNum.Txt_Num:SetText(roomCA.prisonerNum)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_PrisonerNum.Img_Up:SetActive(0 < prisonerNumChange)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_PrisonerNum.Img_Down:SetActive(prisonerNumChange < 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_PrisonerNum.Txt_PrisonerChange:SetActive(prisonerNumChange ~= 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_PrisonerNum.Txt_PrisonerChange:SetText(math.abs(prisonerNumChange))
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_ExtraProduction.Txt_Name:SetText(GetText(80608823))
    local extraProduct = roomCA.extraOutput - curRoomCA.extraOutput
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_ExtraProduction.Txt_Num:SetText(ClearFollowZero(roomCA.extraOutput * 100) .. "%")
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_ExtraProduction.Img_Up:SetActive(0 < extraProduct)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_ExtraProduction.Img_Down:SetActive(extraProduct < 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_ExtraProduction.Txt_ExtraProChange:SetActive(extraProduct ~= 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_ExtraProduction.Txt_ExtraProChange:SetText(ClearFollowZero(math.abs(extraProduct) * 100) .. "%")
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_PrisonerBackupNum.Txt_Name:SetText(GetText(80609057))
    local replacePrisonerNum = roomCA.prisonerBackupNum - curRoomCA.prisonerBackupNum
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_PrisonerBackupNum.Txt_Num:SetText(roomCA.prisonerBackupNum)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_PrisonerBackupNum.Img_Up:SetActive(0 < replacePrisonerNum)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_PrisonerBackupNum.Img_Down:SetActive(replacePrisonerNum < 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_PrisonerBackupNum.Txt_PrisonerChange:SetActive(replacePrisonerNum ~= 0)
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_MaterialWorkShop.Group_PrisonerBackupNum.Txt_PrisonerChange:SetText(math.abs(replacePrisonerNum))
  elseif roomTypeCA.detailIfo == "CreateRoom" then
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_CreatRoom.Group_MachineLV.Txt_Name:SetText(GetText(80607989))
    local furLv = 0
    if roomCA.unlockMachineList and roomCA.unlockMachineList[1] then
      furLv = PlayerData:GetFactoryData(roomCA.unlockMachineList[1].id, "HomeFurnitureFactory").Level
    end
    if furLv ~= 0 then
      View.Group_Right.Group_Upgrade.Group_Attribute.Group_CreatRoom.Group_MachineLV.Txt_Num:SetText(math.abs(furLv))
    end
    View.Group_Right.Group_Upgrade.Group_Attribute.Group_CreatRoom.Group_ProductionFactory.Txt_Name:SetText(GetText(80608119))
    local newFormula = roomCA.unlockFormulaList and roomCA.unlockFormulaList[#roomCA.unlockFormulaList]
    if newFormula then
      local formulaCA = PlayerData:GetFactoryData(newFormula.id, "FormulaFactory")
      View.Group_Right.Group_Upgrade.Group_Attribute.Group_CreatRoom.Group_ProductionFactory.Txt_Num:SetText(formulaCA.name)
    end
  end
end

return DataModel
