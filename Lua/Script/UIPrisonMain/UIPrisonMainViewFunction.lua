local View = require("UIPrisonMain/UIPrisonMainView")
local DataModel = require("UIPrisonMain/UIPrisonMainDataModel")
local UIHYOrderStationController = require("UIHYOrderStation/UIHYOrderStationController")
local ViewFunction = {
  PrisonMain_Btn_Left_Click = function(btn, str)
    local roomIndex = PrisonData.roomIndex - 1
    DataModel.ChangeRoomRefresh(roomIndex)
    PrisonController.ChangeRoom(roomIndex, View.self)
  end,
  PrisonMain_Btn_Light_Click = function(btn, str)
    local roomIndex = PrisonData.roomIndex + 1
    DataModel.ChangeRoomRefresh(roomIndex)
    PrisonController.ChangeRoom(roomIndex, View.self)
  end,
  PrisonMain_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
    PrisonController.CloseRoom()
  end,
  PrisonMain_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  PrisonMain_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PrisonMain_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80303794}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end,
  PrisonMain_Group_Top_Group_PrisonIcon_Btn_Logo_Click = function(btn, str)
    if not PrisonData.GetSeverPrisonData() then
      return
    end
    UIManager:Open("UI/Prison/Overview/PrisonLevel/PrisonLevel")
  end,
  PrisonMain_Group_Top_Group_Monitor_Group_Avatar_Btn_Avatar_Click = function(btn, str)
  end,
  PrisonMain_Group_Windows_Btn__Click = function(btn, str)
    View.Group_Windows:SetActive(false)
  end,
  PrisonMain_Group_Windows_ScrollGrid_QuickJump_SetGrid = function(element, elementIndex)
    local roomCount = DataModel.curRoomCount
    element.Group_Lock:SetActive(elementIndex > roomCount)
    element.Group_Lock.Txt_0:SetText("0" .. elementIndex)
    local name = string.format(GetText(80600296), elementIndex)
    element.Group_Lock.Txt_WorkShop:SetText(name)
    element.Group_Workshop:SetActive(elementIndex <= roomCount)
    element.Group_Workshop.Txt_0:SetText(string.format("%02d", elementIndex))
    if elementIndex <= roomCount then
      local prisonData = PrisonData.GetSeverPrisonData()
      local prisonCA = DataModel.prisonCA
      local program = prisonData.workshops_programme[tostring(elementIndex)] or 1
      local tagId = program and prisonCA.initialHomeFurnitureList[tonumber(program)].schemeType or 12600593
      local tagCA = PlayerData:GetFactoryData(tagId, "TagFactory")
      element.Group_Workshop.Txt_Tips:SetText(tagCA.typeName)
      element.Group_Workshop.Txt_WorkShop:SetText(name)
    end
    local select = elementIndex == PrisonData.roomIndex
    element.Img_Pick:SetActive(select)
    element.Btn_:SetClickParam(elementIndex)
  end,
  PrisonMain_Group_Windows_ScrollGrid_QuickJump_Group_Item_Btn__Click = function(btn, str)
    local roomCount = DataModel.curRoomCount
    if roomCount < tonumber(str) then
      CommonTips.OpenTips(80608281)
      return
    end
    PrisonController.ChangeRoom(tonumber(str), View.self)
    DataModel.ChangeRoomRefresh(tonumber(str))
    View.Group_Windows:SetActive(false)
  end,
  PrisonMain_Btn_QuickJump_Click = function(btn, str)
    View.Group_Windows:SetActive(true)
    View.Group_Windows.ScrollGrid_QuickJump.grid.self:SetDataCount(6)
    View.Group_Windows.ScrollGrid_QuickJump.grid.self:RefreshAllElement()
  end,
  PrisonMain_Btn_Warehouse_Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonWarehouse/PrisonWarehouse")
  end,
  PrisonMain_Btn_Order_Click = function(btn, str)
    UIHYOrderStationController.ShowRecordPanel()
  end,
  PrisonMain_Group_ProductionBtn_Btn_PrisonEdit_Click = function(btn, str)
    if not PrisonData.CheckCanEditAndProduct() then
      CommonTips.OpenTips(GetText(80608014))
      return
    end
    local prisonData = PrisonData.GetSeverPrisonData()
    local selectIndex
    local roomIndex = PrisonData.roomIndex
    local roomCellData = prisonData.workshops_front[tostring(roomIndex)]
    local allProducts = prisonData.workshops_product_plant[tostring(roomIndex)] or {}
    local roomCellDataPairs = {}
    for cellIndex, u_pid in pairs(roomCellData) do
      roomCellDataPairs[tonumber(cellIndex)] = u_pid
    end
    for cellIndex, u_pid in ipairs(roomCellDataPairs) do
      cellIndex = tostring(cellIndex)
      local product = allProducts[cellIndex]
      if product then
        if u_pid == "" then
          local canReceive = PrisonData.IsProductCanReceive(roomIndex, cellIndex)
          if not canReceive and product.sts == 0 then
            selectIndex = cellIndex
          end
        end
      else
        selectIndex = cellIndex
      end
      if selectIndex then
        break
      end
    end
    if selectIndex then
      UIManager:Open("UI/Prison/Manage/PrisonEdit", Json.encode({
        roomIndex = roomIndex,
        selectWorkerIndex = tonumber(selectIndex)
      }))
    else
      CommonTips.OpenTips(80608257)
    end
  end,
  PrisonMain_Group_ProductionBtn_Btn_PrisonProduct_Click = function(btn, str)
    if not PrisonData.CheckCanEditAndProduct() then
      CommonTips.OpenTips(GetText(80608014))
      return
    end
    UIManager:Open("UI/Prison/PrisonerProduction/PrisonProductionEdit")
  end,
  PrisonMain_Group_ProductionBtn_Btn_WorkshopFaster_Click = function(btn, str)
    local roomIndex = PrisonData.roomIndex
    local allProducts = PrisonData.GetRoomProducts(roomIndex)
    if allProducts then
      for cellIndex, v in pairs(allProducts) do
        local remainTime = PrisonData.GetProductRemainTime(roomIndex, cellIndex)
        if 0 < remainTime then
          UIManager:Open("UI/Prison/PrisonBuildingUpgrade/SelectItemAcculate", Json.encode({addSpeedType = 2}))
          break
        end
      end
    end
  end,
  PrisonMain_Group_ProductionBtn_Btn_BatchGet_Click = function(btn, str)
    DataModel.ReceiveAll()
  end,
  PrisonMain_Btn_PrisonManage_Click = function(btn, str)
  end,
  PrisonMain_Group_ProductionBtn_Btn_BatchGet_Btn_Get_Click = function(btn, str)
    DataModel.ReceiveAll()
  end,
  PrisonMain_Group_Navigation_Btn_Quest_Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonTask/PrisonTask", Json.encode({stationId = 83000017}))
  end,
  PrisonMain_Group_Navigation_Btn_Navigation_Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonTask/PrisonTask", Json.encode({stationId = 83000017}))
  end,
  PrisonMain_Group_AllBtn_Btn_AllMedical_Click = function(btn, str)
    local u_pidList = {}
    local productRoomList = PrisonData.GetProductRoomList() or {}
    local list = PrisonData.GetProductRoomList()
    for index, data in pairs(list) do
      local roomData = productRoomList[tostring(index)] or {}
      for cellIndex, v in pairs(roomData) do
        local u_pid = productRoomList[tostring(index)][cellIndex]
        local illHappen = PrisonData.IsIllHappen(u_pid)
        if illHappen then
          table.insert(u_pidList, u_pid)
        end
      end
    end
    
    local function callBack()
      PrisonController.InitRoom(PrisonData.roomIndex, View.self)
      CommonTips.OpenTips(string.format(GetText(80607968), #u_pidList))
    end
    
    PrisonData.SolveIll(callBack, u_pidList)
  end,
  PrisonMain_Group_AllBtn_Btn_AllEvent_Click = function(btn, str)
    local function callBack()
      PrisonController.InitRoom(PrisonData.roomIndex, View.self)
      
      DataModel.RefreshOneButton()
    end
    
    PrisonData.SolveProductAccidentAll(callBack)
  end
}
return ViewFunction
