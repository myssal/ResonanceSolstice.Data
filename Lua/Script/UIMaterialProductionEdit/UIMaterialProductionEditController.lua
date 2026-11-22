local DataModel = require("UIMaterialProductionEdit/UIMaterialProductionEditDataModel")
local View = require("UIMaterialProductionEdit/UIMaterialProductionEditView")
local CommonItem = require("Common/BtnItem")
local Controller = {}
local filterData = {}

local function ControllerFilterBtn()
  local characterData = filterData[View.PrisonerListManage.Group_Screen.Group_Career.name]
  local specialData = filterData[View.PrisonerListManage.Group_Screen.Group_Group.name]
  local qualityData = filterData[View.PrisonerListManage.Group_Screen.Group_Rarity.name]
  View.PrisonerListManage.Group_TopRightPrison.Btn_Screen.Img_P:SetActive(characterData ~= nil and characterData.count ~= 0 and (specialData == nil or specialData.count == 0) and (qualityData == nil or qualityData.count == 0))
end

local function SetFilterView(Type)
  local data = filterData[Type.name]
  for k, v in pairs(Type) do
    if k == "self" or k == "Txt_" then
    elseif data[k] ~= nil then
      v.Img_Select:SetActive(true)
    elseif v ~= nil then
      v.Img_Select:SetActive(false)
    end
  end
end

local function IsMeetFilter(data, property)
  local isMeet = false
  for k, v in pairs(data) do
    if k ~= "count" and k ~= "length" and k ~= "property" and (v == 0 or v == property) then
      isMeet = true
      break
    end
  end
  return isMeet
end

local function InitFilterRolesData(Type, property)
  local name = Type.name
  if type(filterData[name]) == "nil" then
    local length = 0
    if name == "Group_Career" then
      length = 0
      local config = PlayerData:GetFactoryData(99900017).prisonPersonalityNameList
      for i = 1, table.count(config) do
        local btn = "Btn_C0" .. i
        if 10 <= i then
          btn = "Btn_C" .. i
        end
        if Type[btn] then
          Type[btn].self:SetActive(true)
          Type[btn].Txt_:SetText(PlayerData:GetFactoryData(config[i].id).prisonerPersonalityName)
          length = length + 1
        end
      end
    end
    if name == "Group_Group" then
      length = 0
      local config = PlayerData:GetFactoryData(99900017).prisonSpecialityList
      for i = 1, table.count(config) do
        local btn = "Btn_G0" .. i
        if Type[btn] then
          Type[btn].self:SetActive(true)
          Type[btn].Txt_:SetText(PlayerData:GetFactoryData(config[i].id).prisonerSpeciality)
          length = length + 1
        end
      end
    end
    if name == "Group_Rarity" then
      length = 0
      local config = {
        [1] = {id = 12601046},
        [2] = {id = 12601047},
        [3] = {id = 12601048}
      }
      for k, v in pairs(config) do
        local btn = "Btn_R0" .. k
        if btn == "Btn_R04" then
          Type[btn].self:SetActive(false)
        else
          local row = PlayerData:GetFactoryData(v.id)
          if Type[btn] then
            Type[btn].self:SetActive(true)
            Type[btn].Txt_:SetText(row.enemyTypeName)
            length = length + 1
          end
        end
      end
    end
    filterData[name] = {}
    filterData[name].length = length
    filterData[name].property = property
  end
  local data = {}
  data.length = filterData[name].length
  data.property = filterData[name].property
  data[Type.Btn_All.name] = 0
  data.count = 0
  filterData[name] = data
  SetFilterView(Type)
  ControllerFilterBtn()
end

function Controller:Init()
  DataModel.InitData()
  Controller:InitFilter()
  Controller:RefreshFormulaList()
  Controller:RefreshPlacedPrisonerList()
  Controller:RefreshOnProductSateChange()
  Controller:ShowTips()
  View.PrisonerListManage:SetActive(false)
  View.BuyTips:SetActive(false)
  Controller:Reset(View.PrisonerListManage.Group_TopRightPrison.Btn_Level)
  View.Group_Left.Group_Product.Group_ExtraOutput.Txt_NumData:SetText(math.floor(DataModel.RoomLevelCfg.extraOutput * 100) .. "%")
end

function Controller:ShowTips(isAfterSet)
  local roomData = DataModel.GetRoomData()
  if roomData and roomData.u_pid_list then
    local leaveCount = roomData.leave and table.count(roomData.leave) or 0
    local subLeaveCount = roomData.sub_leave and table.count(roomData.sub_leave) or 0
    local replaceCount = roomData.replace and table.count(roomData.replace) or 0
    if leaveCount == 0 and replaceCount == 0 and subLeaveCount == 0 then
      return
    end
    local str = ""
    if not isAfterSet then
      if replaceCount == 0 or not DataModel.IsInProduct then
        str = string.format(GetText(80608951), leaveCount + subLeaveCount)
      else
        str = string.format(GetText(80608950), leaveCount + subLeaveCount, replaceCount)
      end
    elseif 0 < replaceCount and DataModel.IsInProduct then
      str = string.format(GetText(80608952), replaceCount)
    end
    if not string.nilorempty(str) then
      CommonTips.OpenTips(str, true)
    end
  end
end

function Controller:RefreshTop()
  Controller:RefreshPower()
  View.Group_Top.Txt_Workshop:SetText(DataModel.RoomTypeCfg.roomName)
  View.Group_Top.Txt_Lv:SetText("Lv" .. DataModel.RoomLevel)
  View.Group_Left.Img_Machine:SetSprite(DataModel.RoomTypeCfg.materialPic)
  local curWarehouse = PrisonData.GetRawMaterialWarehouseCapacity()
  local maxWarehouse = PrisonData.GetRawMaterialWarehouseMaxCapacity()
  View.Group_Warehouse.Group_Num.Txt_Own:SetText(curWarehouse)
  View.Group_Warehouse.Group_Num.Txt_Max:SetText(maxWarehouse)
  View.Group_Warehouse.Img_Bar.Img_Fill:SetFilledImgAmount(curWarehouse / maxWarehouse)
end

function Controller:RefreshLeft()
  local formulaCfg = PlayerData:GetFactoryData(DataModel.SelectFormulaId)
  local productCfg = PlayerData:GetFactoryData(formulaCfg.product)
  DataModel.TimeCount = {}
  View.Group_Left.Group_Info.Group_Power.Txt_Title:SetText(GetText(80608491))
  View.Group_Left.Group_Info.Group_Speed.Txt_Title:SetText(GetText(80608492))
  View.Group_Left.Group_Info.Group_Cost.Txt_Title:SetText(GetText(80608494))
  local roomData = DataModel.GetRoomData()
  if not roomData then
    roomData = {start_ts = 0, formula_group_id = ""}
    DataModel.IsInProduct = false
  else
    DataModel.CheckProductState()
  end
  View.Group_Left.Group_Producing:SetActive(DataModel.IsInProduct)
  View.Group_Left.Group_Prepare:SetActive(not DataModel.IsInProduct)
  View.Group_Left.Group_Cost.Btn_Deposit:SetActive(not DataModel.IsInProduct)
  View.Group_Left.Group_Product.Img_Pic:SetSprite(productCfg.imagePath)
  View.Group_Left.Group_Product.Btn_Get:SetActive(roomData.product_detail and 0 < roomData.product_detail.normal)
  View.Group_Left.Group_Product.Txt_:SetText(roomData.product_detail and 0 < roomData.product_detail.normal and string.format("%d<color=#FFB800>+%d</color>", roomData.product_detail.normal, roomData.product_detail.extra) or 0)
  if not DataModel.IsInProduct then
    View.Group_Left.Group_Info.Group_Output.Txt_Title:SetText(GetText(80608496))
    View.Group_Left.Group_Info.Group_Time.Txt_Title:SetText(GetText(80608497))
    View.Group_Left.Group_Prepare.Btn_Start:SetActive(false)
    View.Group_Left.Group_Prepare.Btn_CantStart:SetActive(true)
    local prisonerCount = table.count(DataModel.PlacedPrisonerList)
    View.Group_Left.Group_Info.Group_Power.Txt_Num:SetText(formulaCfg.electricityOccupation * prisonerCount)
    View.Group_Left.Group_Info.Group_Speed.Txt_Num:SetText(string.format(GetText(80608493), formulaCfg.perNum * prisonerCount, formulaCfg.perTime // 60))
    View.Group_Left.Group_Info.Group_Cost.Txt_Num:SetText(string.format(GetText(80608495), "Gold", DataModel.CalPrisonerCost()))
    local count, time = DataModel.CalExpectProductCountAndTime()
    local timeTable = TimeUtil:SecondToTableHMS(time)
    View.Group_Left.Group_Info.Group_Output.Txt_Num:SetText(count)
    View.Group_Left.Group_Info.Group_Time.Txt_Num:SetText(string.format("%02d:%02d:%02d", timeTable.hour, timeTable.minute, timeTable.second))
    View.Group_Left.Group_Prepare.Btn_Start:SetActive(0 < count)
    View.Group_Left.Group_Prepare.Btn_CantStart:SetActive(count <= 0)
  else
    local prisonerCount = table.count(DataModel.PlacedPrisonerList)
    View.Group_Left.Group_Info.Group_Power.Txt_Num:SetText(formulaCfg.electricityOccupation * prisonerCount)
    View.Group_Left.Group_Info.Group_Speed.Txt_Num:SetText(string.format(GetText(80608493), formulaCfg.perNum * prisonerCount, formulaCfg.perTime // 60))
    View.Group_Left.Group_Info.Group_Cost.Txt_Num:SetText(string.format(GetText(80608495), "Gold", DataModel.CalPrisonerCost()))
    View.Group_Left.Group_Info.Group_Output.Txt_Title:SetText(GetText(80608499))
    View.Group_Left.Group_Info.Group_Output.Txt_Num:SetText(roomData.product_detail and roomData.product_detail.normal + roomData.product_detail.extra or 0)
    View.Group_Left.Group_Info.Group_Time.Txt_Title:SetText(GetText(80608500))
    local speedTime = roomData.speed_ts or 0
    local productTime = TimeUtil:GetServerTimeStamp() - roomData.st_ts + speedTime
    productTime = productTime < 0 and 0 or productTime
    local timeTable = TimeUtil:SecondToTableHMS(productTime)
    View.Group_Left.Group_Info.Group_Time.Txt_Num:SetText(string.format("%02d:%02d:%02d", timeTable.hour, timeTable.minute, timeTable.second))
    local row = {
      ctr = View.Group_Left.Group_Info.Group_Time.Txt_Num,
      startTime = roomData.st_ts,
      speedTime = speedTime
    }
    table.insert(DataModel.TimeCount, row)
  end
end

function Controller:RefreshCoin()
  View.Group_Left.Group_Cost.Txt_Prisoner:SetText(GetText(80608216))
  View.Group_Left.Group_Cost.Txt_:SetText(string.format(GetText(80608495), "Gold", DataModel.GetStorageCoin()))
end

function Controller:RefreshPower()
  View.Group_Power.Group_Num.Txt_Own:SetText(PrisonData.GetUsePower())
  View.Group_Power.Group_Num.Txt_Max:SetText(DataModel.MaxPower)
end

function Controller:RefreshOnProductSateChange()
  DataModel.CheckProductState()
  Controller:RefreshCoin()
  Controller:RefreshTop()
  Controller:RefreshLeft()
  Controller:RefreshBottom()
end

function Controller:OpenBatchPanel()
  View.BuyTips:SetActive(true)
  local maxNum, minNum
  maxNum = PrisonData.GetPrisonCA().prestoreCost[1].num - DataModel.GetStorageCoin()
  if maxNum <= 0 then
    View.BuyTips:SetActive(false)
    CommonTips.OpenTips(GetText(80608650))
    return
  end
  minNum = maxNum <= 0 and 0 or 1
  local itemId = 11400001
  CommonItem:SetItem(View.BuyTips.Group_Item, {id = itemId})
  View.BuyTips.Txt_Name:SetText(PlayerData:GetFactoryData(itemId).name)
  View.BuyTips.Img_Furniture:SetActive(false)
  View.BuyTips.Group_Slider.Slider_Value.self:SetMinAndMaxValue(minNum, maxNum, true)
  View.BuyTips.Group_Slider.Slider_Value.self:SetSliderValue(minNum)
  View.BuyTips.Group_Slider.Group_Num.Txt_Select:SetText(minNum)
  View.BuyTips.Group_Slider.Group_Num.Txt_Possess:SetText(maxNum)
  DataModel.BatchNum = minNum
end

function Controller:SetFormulaElement(element, elementIndex)
  local row = DataModel.FormulaList[elementIndex]
  if row then
    local cfg = PlayerData:GetFactoryData(row.id)
    element.Btn_Choose.Group_Name.Txt_Name:SetText(cfg.name)
    element.Btn_Choose.Img_Item:SetSprite(cfg.iconPath)
    element.Btn_Choose.Img_Select:SetActive(row.id == DataModel.SelectFormulaId)
    element.Btn_Choose.Txt_Num:SetText(cfg.electricityOccupation)
    element.Group_Lock:SetActive(not row.unlock)
    element.Group_Lock.Btn_Getway:SetClickParam(elementIndex)
    element.Btn_Choose:SetClickParam(elementIndex)
  end
end

function Controller:RefreshFormulaList()
  View.Group_Right.Img_Top.ScrollGrid_Toplist.grid.self:SetDataCount(table.count(DataModel.FormulaList))
  View.Group_Right.Img_Top.ScrollGrid_Toplist.grid.self:RefreshAllElement()
end

function Controller:SetPlacedPrisonerElement(element, elementIndex)
  if elementIndex == (DataModel.PrisonerTab == 1 and DataModel.RoomLevelCfg.prisonerNum + 1 or DataModel.RoomLevelCfg.prisonerBackupNum + 1) then
    element.Group_Locked:SetActive(true)
    element.Group_Unlocked:SetActive(false)
    element.Group_Locked.Txt_:SetText("Lv" .. DataModel.GetNextUnlockPrisonerLevel())
  else
    local elementPrisonerData
    if DataModel.PrisonerTab == 1 then
      elementPrisonerData = DataModel.PlacedPrisonerList[elementIndex]
    else
      elementPrisonerData = DataModel.BackupPrisonerList[elementIndex]
    end
    element.Group_Locked:SetActive(false)
    element.Group_Unlocked:SetActive(true)
    local isEmpty
    if DataModel.PrisonerTab == 1 then
      isEmpty = elementPrisonerData == nil
    else
      isEmpty = elementPrisonerData == nil
    end
    element.Group_Unlocked.Group_Prisoner:SetActive(not isEmpty)
    if not isEmpty then
      local u_pid = elementPrisonerData.u_pid
      local prisonerData = DataModel.allPrisoner[u_pid]
      local prisonerCfg = PlayerData:GetFactoryData(prisonerData.prisoner_id)
      element.Group_Unlocked.Group_Prisoner.Img_Mask.Img_Member:SetSprite(prisonerCfg.prisonerIconPath)
      element.Group_Unlocked.Group_Prisoner.Group_Extra.Txt_:SetText(math.floor(prisonerCfg.extraOutputProbability * 100) .. "%")
    end
  end
end

function Controller:RefreshPlacedPrisonerList()
  View.Group_Right.Group_PrisonerNum:SetActive(not DataModel.IsInProduct or DataModel.PrisonerTab == 2)
  DataModel.PlacedPrisonerList = {}
  DataModel.BackupPrisonerList = {}
  local roomData = PlayerData.ServerData.user_prison_info.raw_material_workshops[tostring(DataModel.RoomTypeId)]
  if roomData and roomData.u_pid_list then
    local serverPlaced = PlayerData.ServerData.user_prison_info.raw_material_workshops[tostring(DataModel.RoomTypeId)].u_pid_list
    for i, v in pairs(serverPlaced) do
      local pData = DataModel.allPrisoner[v]
      table.insert(DataModel.PlacedPrisonerList, pData)
    end
  end
  if roomData and roomData.pre_u_pid_list then
    local serverPlaced = PlayerData.ServerData.user_prison_info.raw_material_workshops[tostring(DataModel.RoomTypeId)].pre_u_pid_list or {}
    for i, v in pairs(serverPlaced) do
      local pData = DataModel.allPrisoner[v]
      table.insert(DataModel.BackupPrisonerList, pData)
    end
  end
  if DataModel.RoomLevel == #DataModel.RoomTypeCfg.roomList then
    View.Group_Right.Group_PrisonerManage.ScrollGrid_PrisonerManageList.grid.self:SetDataCount(DataModel.PrisonerTab == 1 and DataModel.RoomLevelCfg.prisonerNum or DataModel.RoomLevelCfg.prisonerBackupNum)
  else
    View.Group_Right.Group_PrisonerManage.ScrollGrid_PrisonerManageList.grid.self:SetDataCount(DataModel.PrisonerTab == 1 and DataModel.RoomLevelCfg.prisonerNum + 1 or DataModel.RoomLevelCfg.prisonerBackupNum + 1)
  end
  View.Group_Right.Group_PrisonerManage.ScrollGrid_PrisonerManageList.grid.self:RefreshAllElement()
  local curCount = table.count(DataModel.PrisonerTab == 1 and DataModel.PlacedPrisonerList or DataModel.BackupPrisonerList)
  if curCount == 0 then
    View.Group_Right.Group_PrisonerNum.Img_.Txt_:SetText(string.format("<color=#CD5454>%d</color>/%d", curCount, DataModel.PrisonerTab == 1 and DataModel.RoomLevelCfg.prisonerNum or DataModel.RoomLevelCfg.prisonerBackupNum))
  else
    View.Group_Right.Group_PrisonerNum.Img_.Txt_:SetText(string.format("%d/%d", curCount, DataModel.PrisonerTab == 1 and DataModel.RoomLevelCfg.prisonerNum or DataModel.RoomLevelCfg.prisonerBackupNum))
  end
  View.Group_Right.Group_Pick.Btn_Diamond.Group_On:SetActive(DataModel.PrisonerTab == 1)
  View.Group_Right.Group_Pick.Btn_Item.Group_On:SetActive(DataModel.PrisonerTab == 2)
  View.Group_Right.Group_Pick.Btn_Diamond.Group_On.Txt_Num:SetText(string.format(GetText(80608944), table.count(DataModel.PlacedPrisonerList), DataModel.RoomLevelCfg.prisonerNum))
  View.Group_Right.Group_Pick.Btn_Diamond.Group_off.Txt_Num:SetText(string.format(GetText(80608944), table.count(DataModel.PlacedPrisonerList), DataModel.RoomLevelCfg.prisonerNum))
  View.Group_Right.Group_Pick.Btn_Item.Group_On.Txt_Num:SetText(string.format(GetText(80608945), table.count(DataModel.BackupPrisonerList), DataModel.RoomLevelCfg.prisonerBackupNum))
  View.Group_Right.Group_Pick.Btn_Item.Group_off.Txt_Num:SetText(string.format(GetText(80608945), table.count(DataModel.BackupPrisonerList), DataModel.RoomLevelCfg.prisonerBackupNum))
end

function Controller:OpenPrisonerList()
  if DataModel.IsInProduct and DataModel.PrisonerTab == 1 then
    CommonTips.OpenTips(GetText(80607144))
    return
  end
  View.PrisonerListManage:SetActive(true)
  DataModel.SelectPrisoner = {}
  if DataModel.PrisonerTab == 1 then
    for i, v in ipairs(DataModel.PlacedPrisonerList) do
      DataModel.SelectPrisoner[v.u_pid] = true
    end
  else
    for i, v in ipairs(DataModel.BackupPrisonerList) do
      DataModel.SelectPrisoner[v.u_pid] = true
    end
  end
  Controller:RefreshPrisonerList()
end

function Controller:PrisonerMeetFilter()
  local career = filterData[View.PrisonerListManage.Group_Screen.Group_Career.name]
  local campData = filterData[View.PrisonerListManage.Group_Screen.Group_Group.name]
  local qualityData = filterData[View.PrisonerListManage.Group_Screen.Group_Rarity.name]
  for k, v in pairs(DataModel.allPrisoner) do
    if DataModel.CheckPrisonerIsInTime(v.u_pid) then
      v.workingIdx = DataModel.SearchPrisonerWorkingInt(v.u_pid)
      if IsMeetFilter(career, v.personalityIdx) and IsMeetFilter(campData, v.specialityIdx) and IsMeetFilter(qualityData, v.rarityIdx) and DataModel.SelectPrisoner[v.u_pid] == nil then
        table.insert(DataModel.filterPrisoner, v)
      end
    end
  end
end

function Controller:OpenGetWayPanel(idx, posx)
  local data = {}
  local id = DataModel.FormulaList[idx].id
  local cfg = PlayerData:GetFactoryData(id)
  data.itemID = cfg.unlock
  if posx then
    local scalex = UIManager:GetCanvas().transform.localScale.x
    local maxPox = View.Group_Right.Img_Top.ScrollGrid_Toplist.self.transform.position.x / scalex - 322
    if posx > maxPox then
      posx = maxPox
    end
  end
  data.posX = posx or 270
  data.posY = -180
  UIManager:Open("UI/Common/Group_GetWay", Json.encode(data))
end

function Controller:FilterPrisoner()
  DataModel.filterPrisoner = {}
  Controller:PrisonerMeetFilter()
end

function Controller:SortFilterData()
  DataModel.SortFilterPrisoner = {}
  local index = DataModel.SortState.index
  if index == 1 then
    DataModel.SortFilterPrisoner = DataModel.filterPrisoner
    if DataModel.SortState.currentDown then
      Controller:SortDown(DataModel.SortFilterPrisoner)
    else
      Controller:SortUp(DataModel.SortFilterPrisoner)
    end
    return
  end
  if index == 2 then
    DataModel.SortFilterPrisoner = DataModel.filterPrisoner
    if DataModel.SortState.currentDown then
      Controller:TimeSortDown(DataModel.SortFilterPrisoner)
    else
      Controller:TimeSortUp(DataModel.SortFilterPrisoner)
    end
    return
  end
end

function Controller:SetPrisonerListElement(element, elementIndex)
  local row = DataModel.SortFilterPrisoner[elementIndex]
  if row then
    local cfg = PlayerData:GetFactoryData(row.id)
    element.Group_Character.Group_Normal.Img_Pic:SetSprite(cfg.prisonerIconPath)
    element.Group_Character.Group_Normal.Group_Time.Txt_Num:SetText(row.days)
    element.Group_Character.Group_Normal.Txt_Name:SetText(cfg.prisonerName)
    element.Group_Character.Group_Normal.Group_ID.Img_Rarity:SetSprite(PlayerData:GetFactoryData(cfg.prisonerRarity).prisonerRarity)
    element.Group_Character.Group_Normal.Group_ID.Txt_ID:SetText(string.format("%06d", tonumber(row.clint_num)))
    element.Group_Character.Group_Normal.Group_Personality.Txt_:SetText(PlayerData:GetFactoryData(row.personality_id).prisonerPersonalityName)
    element.Group_Character.Group_Normal.Group_Personality.Img_:SetSprite(PlayerData:GetFactoryData(row.personality_id).icon)
    element.Group_Character.Group_Normal.Group_GoodAt.Txt_:SetText(PlayerData:GetFactoryData(row.speciality_id).prisonerSpeciality)
    element.Group_Character.Group_Normal.Group_GoodAt.Img_:SetSprite(PlayerData:GetFactoryData(row.speciality_id).icon)
    element.Group_Character.Group_Normal.Group_Skill.Txt_:SetText(PlayerData:GetFactoryData(cfg.monitor).monitorJobName)
    element.Group_Character.Group_Normal.Group_Outcome.Txt_Des:SetText(math.floor(cfg.extraOutputProbability * 100 + 0.5) .. "%")
    element.Group_Character.Group_Normal.Group_Health.Txt_:SetText(math.floor(row.healthy))
    element.Group_Character.Group_Normal.Group_Health.Img_Health:SetFilledImgAmount(row.healthy / 100)
    element.Group_Character.Group_InTeam:SetActive(DataModel.SelectPrisoner[row.u_pid] ~= nil)
    element.Group_Character.Group_Normal.Group_Workshop:SetActive(DataModel.PrisonerUid2RoomPos[row.u_pid] ~= nil)
    element.Group_Character.Group_Normal.Group_Workshop.Txt_:SetText(DataModel.PrisonerUid2RoomPos[row.u_pid] == nil and "" or DataModel.PrisonerUid2RoomPos[row.u_pid].room)
    local remainTime = math.ceil(row.remainTime / 86400)
    if remainTime < 0 then
      remainTime = 0
    end
    element.Group_Character.Group_Normal.Group_Time.Txt_Num:SetText(remainTime)
    local prisonerState = row.workingIdx
    element.Group_Character.Group_CantChoose:SetActive(prisonerState ~= DataModel.PrisonerState.Free and prisonerState ~= DataModel.PrisonerState.InPrepare)
    if prisonerState ~= DataModel.PrisonerState.Free and prisonerState ~= DataModel.PrisonerState.InPrepare then
      element.Group_Character.Group_CantChoose.Group_Medical:SetActive(prisonerState == DataModel.PrisonerState.InMedical)
      element.Group_Character.Group_CantChoose.Group_Punish:SetActive(prisonerState == DataModel.PrisonerState.InPunish)
      element.Group_Character.Group_CantChoose.Group_Produce:SetActive(prisonerState == DataModel.PrisonerState.InProduct)
    end
    local hasPlaced = DataModel.SelectPrisoner[row.u_pid] ~= nil
    element.Group_Character.Img_Mask:SetActive(hasPlaced or prisonerState ~= DataModel.PrisonerState.Free and prisonerState ~= DataModel.PrisonerState.InPrepare)
    element.Group_Character.Btn_Item:SetClickParam(elementIndex)
  end
end

function Controller:RefreshPrisonerList()
  Controller:FilterPrisoner()
  Controller:SortFilterData()
  for i, v in pairs(DataModel.SelectPrisoner) do
    local pData = DataModel.allPrisoner[i]
    table.insert(DataModel.SortFilterPrisoner, 1, pData)
  end
  Controller:RefreshPrisonerAllElement()
end

function Controller:RefreshPrisonerAllElement()
  local count = table.count(DataModel.SortFilterPrisoner)
  View.PrisonerListManage.ScrollGrid_Prison.grid.self:SetDataCount(count)
  View.PrisonerListManage.ScrollGrid_Prison.grid.self:RefreshAllElement()
  View.PrisonerListManage.Group_NoPrison:SetActive(count == 0)
  Controller:RefreshBottom()
end

function Controller:RefreshBottom()
  View.Group_Right.Group_PrisonerNum:SetActive(not DataModel.IsInProduct or DataModel.PrisonerTab == 2)
  if not DataModel.IsInProduct or DataModel.PrisonerTab == 2 then
    View.PrisonerListManage.Group_Detail.Group_Prisoner.Txt_Num:SetText(string.format("<color=#FFB800>%d</color>/%d", table.count(DataModel.SelectPrisoner), DataModel.PrisonerTab == 1 and DataModel.RoomLevelCfg.prisonerNum or DataModel.RoomLevelCfg.prisonerBackupNum))
    local hasCanChoose = false
    for i, v in ipairs(DataModel.SortFilterPrisoner) do
      if DataModel.SelectPrisoner[v.u_pid] == nil then
        local state = DataModel.GetPrisonerState(v.u_pid)
        if state == DataModel.PrisonerState.Free or state == DataModel.PrisonerState.InPrepare then
          hasCanChoose = true
          break
        end
      end
    end
    local maxCanChooseNum = DataModel.PrisonerTab == 1 and DataModel.RoomLevelCfg.prisonerNum or DataModel.RoomLevelCfg.prisonerBackupNum
    if table.count(DataModel.SelectPrisoner) == maxCanChooseNum then
      hasCanChoose = false
    end
    View.PrisonerListManage.Group_Detail.Btn_All:SetActive(hasCanChoose)
    View.PrisonerListManage.Group_Detail.Btn_AllCancel:SetActive(not hasCanChoose)
  end
end

function Controller:SelectPrisoner(idx)
  local row = DataModel.SortFilterPrisoner[idx]
  if row then
    if DataModel.SelectPrisoner[row.u_pid] then
      if DataModel.IsInProduct and DataModel.PrisonerUid2CurMaterialBackup[row.u_pid] then
        CommonTips.OpenTips(GetText(80608988))
        return
      end
      DataModel.SelectPrisoner[row.u_pid] = nil
    else
      local state = DataModel.GetPrisonerState(row.u_pid)
      if (state == DataModel.PrisonerState.Free or state == DataModel.PrisonerState.InPrepare) and table.count(DataModel.SelectPrisoner) + 1 <= (DataModel.PrisonerTab == 1 and DataModel.RoomLevelCfg.prisonerNum or DataModel.RoomLevelCfg.prisonerBackupNum) then
        DataModel.SelectPrisoner[row.u_pid] = true
      end
    end
  end
  Controller:RefreshPrisonerAllElement()
end

function Controller:SelectFormula(idx)
  if DataModel.IsInProduct then
    CommonTips.OpenTips(GetText(80608503))
    return
  end
  local roomData = DataModel.GetRoomData()
  if roomData and roomData.product_detail and roomData.product_detail.normal > 0 then
    CommonTips.OpenTips(GetText(80608503))
    return
  end
  local row = DataModel.FormulaList[idx]
  if row and DataModel.SelectFormulaId ~= row.id then
    DataModel.SelectFormulaId = row.id
    Controller:RefreshFormulaList()
    Controller:RefreshLeft()
    Controller:RefreshTop()
  end
end

function Controller:ConfirmSelectPrisoner()
  local selectStr = "{}"
  if table.count(DataModel.SelectPrisoner) > 0 then
    local t = {}
    for i, v in pairs(DataModel.SelectPrisoner) do
      table.insert(t, i)
    end
    selectStr = Json.encode(t)
  end
  if DataModel.PrisonerTab == 1 then
    Net:SendProto("prison.modify_front_raw_material", function(json)
      if json.raw_material_workshops then
        DataModel.UpdateRoomData(json.raw_material_workshops)
      end
      if json.workshops_front then
        PlayerData.ServerData.user_prison_info.workshops_front = json.workshops_front
      end
      if json.workshops_master then
        PlayerData.ServerData.user_prison_info.workshops_master = json.workshops_master
      end
      if json.power then
        PlayerData.ServerData.user_prison_info.power = json.power
      end
      View.PrisonerListManage:SetActive(false)
      DataModel.SelectPrisoner = {}
      DataModel.InitPrisonerData()
      Controller:RefreshTop()
      Controller:RefreshPlacedPrisonerList()
      Controller:RefreshLeft()
    end, tostring(DataModel.RoomTypeId), selectStr)
  elseif DataModel.PrisonerTab == 2 then
    if DataModel.IsInProduct then
      local curPower = PrisonData.GetUsePower()
      local maxPower = PrisonData.GetCurPower()
      local formulaCfg = PlayerData:GetFactoryData(DataModel.SelectFormulaId)
      local emptyPlace = DataModel.RoomLevelCfg.prisonerNum - table.count(DataModel.PlacedPrisonerList)
      if emptyPlace > table.count(DataModel.SelectPrisoner) then
        emptyPlace = table.count(DataModel.SelectPrisoner)
      end
      local addPower = formulaCfg.electricityOccupation * emptyPlace
      if maxPower < curPower + addPower then
        CommonTips.OpenTips(GetText(80608170))
        return
      end
    end
    Net:SendProto("prison.set_raw_workshop_pre_prisoner", function(json)
      if json.raw_material_workshops then
        DataModel.UpdateRoomData(json.raw_material_workshops)
      end
      if json.workshops_front then
        PlayerData.ServerData.user_prison_info.workshops_front = json.workshops_front
      end
      if json.workshops_master then
        PlayerData.ServerData.user_prison_info.workshops_master = json.workshops_master
      end
      if json.power then
        PlayerData.ServerData.user_prison_info.power = json.power
      end
      View.PrisonerListManage:SetActive(false)
      DataModel.SelectPrisoner = {}
      DataModel.InitPrisonerData()
      Controller:RefreshPlacedPrisonerList()
      Controller:RefreshPower()
      Controller:ShowTips(true)
    end, tostring(DataModel.RoomTypeId), selectStr)
  end
  Net:SendProto("prison.del_leave_replace", function()
  end, tostring(DataModel.RoomTypeId))
end

function Controller:OneBtnChooseAll()
  DataModel.SelectPrisoner = {}
  for index, data in ipairs(DataModel.SortFilterPrisoner) do
    local state = DataModel.GetPrisonerState(data.u_pid)
    if (state == DataModel.PrisonerState.Free or state == DataModel.PrisonerState.InPrepare) and table.count(DataModel.SelectPrisoner) + 1 <= (DataModel.PrisonerTab == 1 and DataModel.RoomLevelCfg.prisonerNum or DataModel.RoomLevelCfg.prisonerBackupNum) then
      DataModel.SelectPrisoner[data.u_pid] = true
    end
  end
  Controller:RefreshPrisonerAllElement()
  Controller:RefreshBottom()
end

function Controller:OneBtnCancelAll()
  DataModel.SelectPrisoner = {}
  if DataModel.IsInProduct then
    for i, v in pairs(DataModel.PrisonerTab == 1 and DataModel.PrisonerUid2CurMaterialPlaced or DataModel.PrisonerUid2CurMaterialBackup) do
      DataModel.SelectPrisoner[i] = true
    end
  end
  Controller:RefreshPrisonerAllElement()
  Controller:RefreshBottom()
end

function Controller:TryStorageCoin()
  Net:SendProto("prison.set_gold_raw_material", function(json)
    if json.raw_material_workshops then
      DataModel.UpdateRoomData(json.raw_material_workshops)
    end
    DataModel.BatchNum = 1
    View.BuyTips:SetActive(false)
    Controller:RefreshCoin()
    Controller:RefreshLeft()
  end, tostring(DataModel.RoomTypeId), DataModel.BatchNum)
end

function Controller:TryStartProduct()
  if not DataModel.SelectFormulaId or DataModel.SelectFormulaId <= 0 then
    return
  end
  if table.count(DataModel.PlacedPrisonerList) == 0 then
    return
  end
  local count, time = DataModel.CalExpectProductCountAndTime()
  if count == 0 then
    return
  end
  local curPower = PrisonData.GetUsePower()
  local maxPower = PrisonData.GetCurPower()
  local formulaCfg = PlayerData:GetFactoryData(DataModel.SelectFormulaId)
  local addPower = formulaCfg.electricityOccupation * table.count(DataModel.PlacedPrisonerList)
  local emptyPlace = DataModel.RoomLevelCfg.prisonerNum - table.count(DataModel.PlacedPrisonerList)
  if emptyPlace > table.count(DataModel.BackupPrisonerList) then
    emptyPlace = table.count(DataModel.BackupPrisonerList)
  end
  if maxPower < curPower + addPower + formulaCfg.electricityOccupation * emptyPlace then
    CommonTips.OpenTips(GetText(80608170))
    return
  end
  local roomData = DataModel.GetRoomData()
  
  local function startFunc()
    Net:SendProto("prison.start_product_raw_material", function(json)
      if json.raw_material_workshops then
        DataModel.UpdateRoomData(json.raw_material_workshops)
      end
      if json.power then
        PlayerData.ServerData.user_prison_info.power = json.power
      end
      CommonTips.OpenTips(GetText(80608385))
      Controller:RefreshOnProductSateChange()
      Controller:RefreshPlacedPrisonerList()
      Controller:ShowTips(true)
    end, tostring(DataModel.RoomTypeId), tostring(DataModel.SelectFormulaId))
  end
  
  if roomData.product_detail and 0 < roomData.product_detail.normal and roomData.formula_group_id ~= tostring(DataModel.SelectFormulaId) then
    CommonTips.OnPrompt(GetText(80608503), nil, nil, startFunc)
  else
    startFunc()
  end
end

function Controller:TryRefreshRoomData(cb)
  Net:SendProto("prison.pre_receive_raw_material", function(json)
    if json.raw_material_workshops then
      DataModel.UpdateRoomData(json.raw_material_workshops)
    end
    Controller:RefreshOnProductSateChange()
    if cb then
      cb()
    end
  end, tostring(DataModel.RoomTypeId))
end

function Controller:TryStopProduct()
  Net:SendProto("prison.stop_product_raw_material", function(json)
    if json.raw_material_workshops then
      DataModel.UpdateRoomData(json.raw_material_workshops)
    end
    Controller:RefreshOnProductSateChange()
  end, tostring(DataModel.RoomTypeId))
end

function Controller:TryGetProduction()
  local formulaId = PlayerData.ServerData.user_prison_info.raw_material_workshops[tostring(DataModel.RoomTypeId)].formula_group_id
  
  local function doReceive()
    local curSpace = PrisonData.GetRawMaterialWarehouseCapacity()
    local maxSpace = PrisonData.GetRawMaterialWarehouseMaxCapacity()
    local product_detail = DataModel.GetRoomData().product_detail
    local needPrompt = maxSpace < curSpace + product_detail.normal + product_detail.extra
    
    local function receiveFunc()
      Net:SendProto("prison.receive_raw_material", function(json)
        if json.raw_material then
          PlayerData.ServerData.user_prison_info.raw_material = json.raw_material
        end
        if json.raw_material_workshops then
          PlayerData.ServerData.user_prison_info.raw_material_workshops = json.raw_material_workshops
        end
        if json.power then
          PlayerData.ServerData.user_prison_info.power = json.power
        end
        if json.prison_backpack then
          PlayerData.ServerData.user_prison_info.prison_backpack = json.prison_backpack
        end
        if json.product_detail then
          local data = {
            normal = 0,
            extra = 0,
            buff = 0
          }
          if json.product_detail.normal then
            data.normal = data.normal + json.product_detail.normal
          end
          if json.product_detail.extra then
            data.extra = data.extra + json.product_detail.extra
          end
          if json.product_detail.buff then
            data.buff = data.buff + json.product_detail.buff
          end
          local formulaProductId = PlayerData:GetFactoryData(formulaId).product
          local reward = {}
          reward[tostring(formulaProductId)] = data
          if 0 < table.count(reward) then
            UIManager:Open("UI/Common/ShowItem", Json.encode({
              prisonProductRewards = reward,
              title = GetText(80608306),
              ignoreCloseTime = true
            }, function()
              if json.reward then
                CommonTips.OpenShowItem(json.reward)
              end
            end), function()
              if json.reward then
                CommonTips.OpenShowItem(json.reward)
              end
            end)
          end
        end
        if json.warehouse then
          if PlayerData.ServerData.user_home_info == nil then
            PlayerData.ServerData.user_home_info = {}
            PlayerData.ServerData.user_home_info.warehouse = {}
          end
          PlayerData.ServerData.user_home_info.warehouse = json.warehouse
        end
        Controller:RefreshOnProductSateChange()
      end, tostring(DataModel.RoomTypeId))
    end
    
    if needPrompt then
      CommonTips.OnPrompt(GetText(80608307), nil, nil, receiveFunc)
    else
      receiveFunc()
    end
  end
  
  if DataModel.IsInProduct then
    Controller:TryRefreshRoomData(doReceive)
  else
    doReceive()
  end
end

function Controller:TrySpeedProduct()
  local function cb()
    local cost = DataModel.CalPrisonerCost()
    
    local canProductCount = DataModel.GetRoomData().gold // cost
    UIManager:Open("UI/Prison/PrisonBuildingUpgrade/SelectItemAcculate", Json.encode({
      addSpeedType = 3,
      typeId = DataModel.RoomTypeId,
      canProductCount = canProductCount
    }))
  end
  
  Controller:TryRefreshRoomData(cb)
end

function Controller:DoSpeedProduct(cb, data)
  Net:SendProto("prison.speed_product_raw_material", function(json)
    if json.raw_material_workshops then
      DataModel.UpdateRoomData(json.raw_material_workshops)
    end
    if json.power then
      PlayerData.ServerData.user_prison_info.power = json.power
    end
    if cb then
      cb()
    end
  end, tostring(DataModel.RoomTypeId), data)
end

function Controller:JumpToWarehouse()
  UIManager:Open("UI/Prison/PrisonWarehouse/PrisonWarehouse", Json.encode({openStationTab = 1}))
end

function Controller:Click(btn)
  if DataModel.SortState.currentBtn == btn then
    Controller:Revert(btn)
    Controller:RefreshPrisonerList()
    return
  end
  Controller:Deactivate(DataModel.SortState.currentBtn)
  DataModel.SortState.currentBtn = btn
  Controller:Active(DataModel.SortState.currentBtn)
  Controller:RefreshPrisonerList()
end

function Controller:ScreenBtn(Type, btn, enumIndex)
  local name = Type.Btn_All.name
  if btn == nil then
    btn = Type.Btn_All
  end
  local data = filterData[Type.name] or {}
  local length = data.length
  if DataModel.PrisonerFilter == nil then
    DataModel.PrisonerFilter = {}
  end
  if DataModel.PrisonerFilter[Type.name] == nil then
    DataModel.PrisonerFilter[Type.name] = {}
    DataModel.PrisonerFilter[Type.name].index = {}
  end
  DataModel.PrisonerFilter[Type.name].btn = btn
  DataModel.PrisonerFilter[Type.name].type = Type
  if next(data) == nil or name == btn.name then
    DataModel.PrisonerFilter[Type.name].index = {}
    InitFilterRolesData(Type)
    return
  else
    if data[name] then
      data[name] = nil
    end
    if data[btn.name] == nil then
      data[btn.name] = enumIndex
      DataModel.PrisonerFilter[Type.name].index[btn.name] = enumIndex
      data.count = data.count + 1
      if data.count == length then
        InitFilterRolesData(Type)
        return
      end
    else
      data[btn.name] = nil
      DataModel.PrisonerFilter[Type.name].index[btn.name] = nil
      data.count = data.count - 1
      if data.count == 0 then
        InitFilterRolesData(Type)
        return
      end
    end
  end
  filterData[Type.name] = data
  SetFilterView(Type)
  ControllerFilterBtn()
end

function Controller:ResetActive(btn)
  for key, value in pairs(btn) do
    if key == "self" then
    elseif key == "Img_DeN" then
      btn[key]:SetActive(true)
    elseif key == "Img_DeP" then
      btn[key]:SetActive(true)
    else
      btn[key]:SetActive(false)
    end
  end
end

function Controller:Deactivate(btn)
  if btn.Img_DeP.gameObject.activeInHierarchy then
    btn.Img_DeP:SetActive(false)
    btn.Img_DeN:SetActive(true)
  elseif btn.Img_AP.gameObject.activeInHierarchy then
    btn.Img_AP:SetActive(false)
    btn.Img_AN:SetActive(true)
  end
end

function Controller:Active(btn)
  if btn.Img_AN.gameObject.activeInHierarchy then
    btn.Img_AP:SetActive(true)
    btn.Img_AN:SetActive(false)
    DataModel.SortState.currentDown = false
  elseif btn.Img_DeN.gameObject.activeInHierarchy then
    btn.Img_DeP:SetActive(true)
    btn.Img_DeN:SetActive(false)
    DataModel.SortState.currentDown = true
  end
end

function Controller:Revert(btn)
  if btn.Img_DeP.gameObject.activeInHierarchy then
    btn.Img_DeP:SetActive(false)
    btn.Img_DeN:SetActive(false)
    btn.Img_AP:SetActive(true)
    btn.Img_AN:SetActive(false)
    DataModel.SortState.currentDown = false
  elseif btn.Img_AP.gameObject.activeInHierarchy then
    btn.Img_DeP:SetActive(true)
    btn.Img_DeN:SetActive(false)
    btn.Img_AP:SetActive(false)
    btn.Img_AN:SetActive(false)
    DataModel.SortState.currentDown = true
  end
end

function Controller:Reset(btn)
  for key, value in pairs(View.PrisonerListManage.Group_TopRightPrison) do
    if key ~= "self" and key ~= "Btn_Screen" then
      Controller:ResetActive(value)
      Controller:Deactivate(value)
    end
  end
  DataModel.SortState.currentBtn = btn
  Controller:Active(DataModel.SortState.currentBtn)
end

function Controller:SortDown(List)
  table.sort(List, function(a, b)
    if a.workingIdx == 3 or b.workingIdx == 3 then
      if a.workingIdx == b.workingIdx then
        return a.extraOutputProbability > b.extraOutputProbability
      else
        return a.workingIdx < b.workingIdx
      end
    end
    return a.extraOutputProbability > b.extraOutputProbability
  end)
end

function Controller:SortUp(List)
  table.sort(List, function(a, b)
    if a.workingIdx == 3 or b.workingIdx == 3 then
      if a.workingIdx == b.workingIdx then
        return a.extraOutputProbability < b.extraOutputProbability
      else
        return a.workingIdx < b.workingIdx
      end
    end
    return a.extraOutputProbability < b.extraOutputProbability
  end)
end

function Controller:TimeSortDown(List)
  table.sort(List, function(a, b)
    if a.workingIdx == 3 or b.workingIdx == 3 then
      if a.workingIdx == b.workingIdx then
        return a.remainTime > b.remainTime
      else
        return a.workingIdx < b.workingIdx
      end
    end
    return a.remainTime > b.remainTime
  end)
end

function Controller:TimeSortUp(List)
  table.sort(List, function(a, b)
    if a.workingIdx == 3 or b.workingIdx == 3 then
      if a.workingIdx == b.workingIdx then
        return a.remainTime < b.remainTime
      else
        return a.workingIdx < b.workingIdx
      end
    end
    return a.remainTime < b.remainTime
  end)
end

function Controller:InitFilter()
  filterData = {}
  InitFilterRolesData(View.PrisonerListManage.Group_Screen.Group_Career, "careerInt")
  InitFilterRolesData(View.PrisonerListManage.Group_Screen.Group_Group, "specialInt")
  InitFilterRolesData(View.PrisonerListManage.Group_Screen.Group_Rarity, "qualityInt")
end

return Controller
