local View = require("UISelectItemAcculate/UISelectItemAcculateView")
local CommonItem = require("Common/BtnItem")
local DataModel = {}
DataModel.prisonCA = PrisonData.GetPrisonCA()
DataModel.addSpeedType = 1
DataModel.roomTypeId = nil
DataModel.serverRoomData = nil
DataModel.roomId = nil
DataModel.remainTime = 0
DataModel.canProductCount = 0
DataModel.cellIndex = 1
DataModel.selectIndex = nil
DataModel.selectNum = 0
DataModel.maxUseNum = 0
DataModel.itemUseList = {}
DataModel.itemUseElementList = {}

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.addSpeedType = data.addSpeedType
  if data.addSpeedType == 1 then
    DataModel.roomTypeId = data.typeId
  elseif data.addSpeedType == 3 then
    DataModel.roomTypeId = data.typeId
    DataModel.canProductCount = data.canProductCount
  elseif data.addSpeedType == 4 then
    DataModel.cellIndex = data.cellIndex
  end
end

function DataModel.InitData()
  DataModel.itemUseList = {}
  local itemUseList = {}
  local itemUseSortList = {}
  if DataModel.addSpeedType == 1 then
    local serverBuildList = PrisonData.GetBuildList()
    DataModel.serverRoomData = serverBuildList[tostring(DataModel.roomTypeId)]
    local roomTypeCA = PlayerData:GetFactoryData(DataModel.roomTypeId, "PrisonRoomTypeFactory")
    for i, v in pairs(roomTypeCA.roomList) do
      local roomCA = PlayerData:GetFactoryData(v.config, "PrisonRoomFactory")
      if roomCA.roomLevel == DataModel.serverRoomData.lv then
        DataModel.roomId = v.config
        break
      end
    end
    for i, v in pairs(DataModel.prisonCA.cardFaster) do
      table.insert(itemUseList, {
        itemId = v.card,
        time = v.cardTime,
        haveNum = PlayerData:GetGoodsById(v.card).num
      })
    end
  elseif DataModel.addSpeedType == 2 or DataModel.addSpeedType == 3 or DataModel.addSpeedType == 4 then
    for i, v in pairs(DataModel.prisonCA.productionAccelerationItemList) do
      table.insert(itemUseList, {
        itemId = v.id,
        time = v.time,
        haveNum = PlayerData:GetGoodsById(v.id).num,
        fasterType = v.type
      })
    end
  end
  DataModel.itemUseList = itemUseList
  for i, v in ipairs(itemUseList) do
    if DataModel.IsItemCanUse(i) then
      table.insert(itemUseSortList, 1, v)
    else
      table.insert(itemUseSortList, v)
    end
  end
  DataModel.itemUseList = itemUseSortList
  DataModel.selectIndex = nil
  DataModel.selectNum = 0
  DataModel.maxUseNum = 0
end

function DataModel.RefreshOnShow()
  View.Group_Line:SetActive(DataModel.addSpeedType == 1)
  View.Group_ProductLine:SetActive(DataModel.addSpeedType == 2 or DataModel.addSpeedType == 3 or DataModel.addSpeedType == 4)
  View.Btn_Cancel:SetActive(DataModel.addSpeedType == 3)
  View.Btn_Complete:SetActive(DataModel.addSpeedType == 1 or DataModel.addSpeedType == 2)
  if DataModel.addSpeedType == 1 then
    local roomTypeCA = PlayerData:GetFactoryData(DataModel.roomTypeId, "PrisonRoomTypeFactory")
    local roomCA = PlayerData:GetFactoryData(DataModel.roomId, "PrisonRoomFactory")
    View.Group_Line.Txt_RoomName:SetText(roomTypeCA.roomName)
    DataModel.remainTime = DataModel.serverRoomData.start_ts + roomCA.upgradeTime - TimeUtil:GetServerTimeStamp()
  elseif DataModel.addSpeedType == 2 then
    local roomIndex = PrisonData.roomIndex
    local allProducts = PrisonData.GetRoomProducts(roomIndex)
    local remainTime = 0
    if allProducts then
      for cellIndex, v in pairs(allProducts) do
        local time = PrisonData.GetProductRemainTime(roomIndex, cellIndex)
        if remainTime < time then
          remainTime = time
        end
      end
    end
    DataModel.remainTime = remainTime
  elseif DataModel.addSpeedType == 3 then
    local roomData = PlayerData.ServerData.user_prison_info.raw_material_workshops[tostring(DataModel.roomTypeId)]
    if roomData and roomData.start_ts ~= 0 then
      local speedTime = roomData.speed_ts or 0
      DataModel.remainTime = TimeUtil:GetServerTimeStamp() - roomData.st_ts + speedTime
    end
  elseif DataModel.addSpeedType == 4 then
    local roomIndex = PrisonData.roomIndex
    local allProducts = PrisonData.GetRoomProducts(roomIndex)
    local product = allProducts[tostring(DataModel.cellIndex)]
    if product then
      DataModel.remainTime = PrisonData.GetProductRemainTime(roomIndex, DataModel.cellIndex)
    end
  end
  local timeStr = DataModel.GetTimeStr(DataModel.remainTime)
  if DataModel.addSpeedType == 1 then
    View.Group_Line.Txt_BuildTime:SetText(timeStr)
  elseif DataModel.addSpeedType == 2 then
    View.Group_ProductLine.Txt_ProductTime:SetText(timeStr)
  elseif DataModel.addSpeedType == 3 then
    View.Group_ProductLine.Txt_ProductTime:SetText(timeStr)
  elseif DataModel.addSpeedType == 4 then
    View.Group_ProductLine.Txt_ProductTime:SetText(timeStr)
  end
  DataModel.itemUseElementList = {}
  View.ScrollGrid_List.grid.self:SetDataCount(#DataModel.itemUseList)
  View.ScrollGrid_List.grid.self:RefreshAllElement()
  View.ScrollGrid_List.grid.self.ScrollRect.enabled = 3 < #DataModel.itemUseList
  DataModel.ClickItem(1)
  DataModel.RefreshImmediatelyCost()
end

function DataModel.ClickItem(index)
  if not DataModel.IsItemCanUse(index) then
    return
  end
  if DataModel.selectIndex == index then
    return
  end
  local ctr = DataModel.itemUseElementList[DataModel.selectIndex]
  if ctr then
    ctr.Img_Selected:SetActive(false)
  end
  ctr = DataModel.itemUseElementList[index]
  if ctr then
    ctr.Img_Selected:SetActive(true)
  end
  DataModel.selectIndex = index
  local itemUseInfo = DataModel.itemUseList[index]
  local itemId = itemUseInfo.itemId
  local itemCA = PlayerData:GetFactoryData(itemId)
  CommonItem.SetItem(self, View.Group_Item, {id = itemId})
  View.Txt_Name:SetText(itemCA.name)
  View.Txt_Describe:SetText(itemCA.desc)
  View.Group_Num.Txt_Num:SetText(itemUseInfo.haveNum)
  local maxNum = 0
  if DataModel.addSpeedType == 1 or DataModel.addSpeedType == 2 or DataModel.addSpeedType == 4 then
    maxNum = math.ceil(DataModel.remainTime / itemUseInfo.time)
  elseif DataModel.addSpeedType == 3 then
    maxNum = DataModel.canProductCount
  end
  maxNum = maxNum > itemUseInfo.haveNum and itemUseInfo.haveNum or maxNum
  local minNum = 1 <= maxNum and 1 or 0
  if maxNum <= 1 then
    View.Group_SelectQuantity.Group_Slider.Slider_Value:SetMinAndMaxValue(0, 1)
    if maxNum == 1 then
      View.Group_SelectQuantity.Group_Slider.Slider_Value:SetSliderValue(1)
      DataModel.selectNum = 1
    else
      View.Group_SelectQuantity.Group_Slider.Slider_Value:SetSliderValue(0)
      DataModel.selectNum = 0
    end
    View.Group_SelectQuantity.Group_Slider.Slider_Value.slider.enabled = false
  else
    View.Group_SelectQuantity.Group_Slider.Slider_Value:SetMinAndMaxValue(1, maxNum)
    View.Group_SelectQuantity.Group_Slider.Slider_Value:SetSliderValue(1)
    DataModel.selectNum = 1
    View.Group_SelectQuantity.Group_Slider.Slider_Value.slider.enabled = true
  end
  DataModel.maxUseNum = maxNum
  View.Group_SelectQuantity.Group_Slider.Group_Num.Txt_Select:SetText(minNum)
  View.Group_SelectQuantity.Group_Slider.Group_Num.Txt_Max:SetText(maxNum)
  local timeStr = DataModel.GetTimeStr(itemUseInfo.time * minNum)
  View.Group_Time.Txt_TimeNum:SetText(timeStr)
end

function DataModel.RefreshImmediatelyCost()
  local costInfo
  local prisonCA = PrisonData.GetPrisonCA()
  for i, v in ipairs(prisonCA.diamondFaster) do
    if v.timeFaster >= DataModel.remainTime then
      costInfo = v
      break
    end
  end
  if costInfo then
    View.Btn_Complete.Group_.Group_.Group_.Txt_:SetText(costInfo.diamondNum)
  end
end

function DataModel.GetTimeStr(time)
  local timeStr = "00:00:00"
  local hours = math.floor(time / 3600)
  local minutes = math.floor(time % 3600 / 60)
  local secs = math.floor(time % 60)
  if hours < 10 then
    hours = "0" .. hours
  end
  if minutes < 10 then
    minutes = "0" .. minutes
  end
  if secs < 10 then
    secs = "0" .. secs
  end
  timeStr = hours .. ":" .. minutes .. ":" .. secs
  return timeStr
end

function DataModel.IsItemCanUse(itemIndex)
  local itemInfo = DataModel.itemUseList[tonumber(itemIndex)]
  if DataModel.addSpeedType == 1 then
    return true
  elseif DataModel.addSpeedType == 2 or DataModel.addSpeedType == 3 then
    return itemInfo.fasterType == 12601372
  elseif DataModel.addSpeedType == 4 then
    return itemInfo.fasterType == 12601373
  end
  return false
end

return DataModel
