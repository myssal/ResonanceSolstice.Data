local DataModel = require("UIPrisonProductionEdit/UIPrisonProductionEditDataModel")
local View = require("UIPrisonProductionEdit/UIPrisonProductionEditView")
local CommonItem = require("Common/BtnItem")
local TradeDataModel = require("UIHome/UIHomeTradeDataModel")
local Controller = {}

function Controller:Init()
  DataModel.InitData()
  View.Group_FormulaList:SetActive(false)
  View.Group_Bottom.Group_Formula:SetActive(true)
  View.Group_Windows:SetActive(false)
  Controller:RefreshLockElement()
  Controller:RefreshWorkPlacedElement()
  Controller:RefreshFormulaTypeList()
  Controller:RefreshFormulaList()
  Controller:RefreshTop()
  Controller:RefreshRequirePanel()
  Controller:RefreshOneBtnState()
end

function Controller:RefreshTop()
  Controller:RefreshPower()
  local maxWarehouse = PrisonData.GetProductWarehouseMaxCapacity()
  local curWarehouse = PrisonData.GetProductWarehouseCapacity()
  View.Group_Warehouse.Group_Num.Txt_Own:SetText(curWarehouse)
  View.Group_Warehouse.Group_Num.Txt_Max:SetText(maxWarehouse)
  View.Group_Warehouse.Img_Bar.Img_Fill:SetFilledImgAmount(curWarehouse / maxWarehouse)
  View.Group_Top.Group_WorkshopInfo.Txt_Workshop:SetText(string.format(GetText(80600296), DataModel.CurRoomIndex))
  if DataModel.GetUnlockGridCount() > 0 then
    local program = PlayerData.ServerData.user_prison_info.workshops_programme[tostring(DataModel.CurRoomIndex)] or "1"
    local type = PrisonData.GetPrisonCA().initialHomeFurnitureList[tonumber(program)].schemeType
    View.Group_Top.Group_WorkshopInfo.Txt_WorkshopName:SetText(PlayerData:GetFactoryData(type).typeName)
  else
    View.Group_Top.Group_WorkshopInfo.Txt_WorkshopName:SetText("")
  end
end

function Controller:RefreshPower()
  View.Group_Power.Group_Num.Txt_Max:SetText(DataModel.MaxPower)
  local add = 0
  local count = table.count(DataModel.SelectPosIndex)
  if not DataModel.CurSelectFormulaId or 0 > DataModel.CurSelectFormulaId or count == 0 then
    add = 0
  else
    local powerCost = PlayerData:GetFactoryData(DataModel.CurSelectFormulaId).electricityOccupation
    add = powerCost * count
  end
  local afterPower = DataModel.CurPower + add
  View.Group_Power.Group_Num.Txt_Own:SetText(afterPower)
  if afterPower > DataModel.MaxPower then
    View.Group_Power.Group_Num.Txt_Own:SetColor("#CD5454")
  else
    View.Group_Power.Group_Num.Txt_Own:SetColor("#FFFFFF")
  end
end

function Controller:SetLockElement(element, elementIndex)
  local lv = PrisonData.GetPrisonLv()
  local prisonCfg = PrisonData.GetPrisonCA()
  local lvCfg = prisonCfg.lvList[lv]
  local idx = (DataModel.CurRoomIndex - 1) * DataModel.DesignColumnCount + elementIndex
  local unlockCount = DataModel.GetUnlockGridCount(DataModel.CurRoomIndex) // DataModel.DesignRowCount
  local ctr = View.Group_Lock.StaticGrid_.grid[elementIndex]
  if elementIndex <= unlockCount then
    ctr:SetActive(false)
  else
    ctr.Group_Mask.Btn_Lock:SetActive(idx <= lvCfg.SpaceNum)
    ctr.Group_Mask.Effect_InTips:SetActive(idx <= lvCfg.SpaceNum and not DataModel.IsExpand)
    local ls = (DataModel.CurRoomIndex - 1) * 5 + 1
    local le = DataModel.CurRoomIndex * 5
    for i = ls, le do
      if idx <= prisonCfg.lvList[i].SpaceNum then
        element.Group_Mask.Group_Num.Txt_NumunLock:SetActive(i <= PrisonData.GetPrisonLv())
        element.Group_Mask.Group_Num.Txt_NumLock:SetActive(i > PrisonData.GetPrisonLv())
        element.Group_Mask.Group_Level.Txt_leveunlLock:SetActive(i <= PrisonData.GetPrisonLv())
        element.Group_Mask.Group_Level.Txt_levelLock:SetActive(i > PrisonData.GetPrisonLv())
        element.Group_Mask.Group_Num.Txt_NumunLock:SetText(string.format("%02d", i))
        element.Group_Mask.Group_Num.Txt_NumLock:SetText(string.format("%02d", i))
        break
      end
    end
  end
end

function Controller:RefreshLockElement()
  View.Group_Lock:SetActive(true)
  View.Group_Lock.StaticGrid_.grid.self:SetDataCount(6)
  View.Group_Lock.StaticGrid_.grid.self:RefreshAllElement()
end

function Controller:SetWorkPlaceElement(element, elementIndex)
  local unlockGridCount = DataModel.GetUnlockGridCount(DataModel.CurRoomIndex)
  if elementIndex <= unlockGridCount then
    element.Group_Machine:SetActive(true)
    local machineId = DataModel.GetWorkMachineInfo(DataModel.CurRoomIndex, elementIndex).id
    local hasPrisoner = DataModel.HasWorkingPrisoner(DataModel.CurRoomIndex, elementIndex)
    local hasPlant, isFinish, remainTime = DataModel.IsWorkPlaceHasPlant(DataModel.CurRoomIndex, elementIndex)
    local machineCfg = PlayerData:GetFactoryData(machineId)
    element.Group_Machine.Img_Machine:SetSprite(machineCfg.iconPath)
    element.Group_Machine.Txt_MachineLevel:SetText("LV." .. machineCfg.Level)
    element.Group_PrisonerEmpty:SetActive(not hasPrisoner)
    element.Group_PrisonerPlaced:SetActive(hasPrisoner)
    element.Group_PrisonerPlaced.Group_Frame:SetActive(true)
    element.Group_ProductCondition:SetActive(hasPlant)
    if hasPlant then
      local plantData = DataModel.GetWorkPlacePlantData(DataModel.CurRoomIndex, elementIndex)
      if not plantData then
        element.Group_ProductCondition:SetActive(false)
      else
        element.Group_ProductCondition:SetActive(hasPlant)
        element.Group_ProductCondition.Group_ProductStop:SetActive(false)
        element.Group_ProductCondition.Group_Producting:SetActive(hasPlant and not isFinish)
        element.Group_ProductCondition.Group_ProductFinish:SetActive(hasPlant and isFinish)
        element.Group_ProductCondition.Group_Mask:SetActive(hasPlant)
        if 0 < remainTime then
          local timeTbl = TimeUtil:SecondToTable(remainTime)
          element.Group_PrisonerPlaced.Group_Frame.Txt_WorkTime:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
          local handler = {
            finishTime = TimeUtil:GetServerTimeStamp() + remainTime,
            ctr = element.Group_PrisonerPlaced.Group_Frame.Txt_WorkTime
          }
          table.insert(DataModel.CountDownHandler, handler)
        else
          element.Group_PrisonerPlaced.Group_Frame.Txt_WorkTime:SetText("--:--:--")
        end
        local originPrisonerPid = plantData.u_pid
        local originPrisonerInfo = DataModel.AllPrisoner[originPrisonerPid]
        if originPrisonerInfo then
          local originPrisonerCfg = PlayerData:GetFactoryData(originPrisonerInfo.prisoner_id)
          element.Group_PrisonerPlaced.Group_ExtraProduct.Txt_:SetText(math.floor(originPrisonerCfg.extraOutputProbability) .. "%")
        end
        element.Group_ProductCondition.Img_Item:SetSprite(PlayerData:GetFactoryData(plantData.formulaGroupId).iconPath)
        element.Group_ProductCondition.Txt_Num:SetText(DataModel.CalWorkerPlaceProductNum(elementIndex))
      end
    end
    if hasPrisoner then
      local prisonerId = DataModel.GetWorkPrisonerInfo(DataModel.CurRoomIndex, elementIndex).prisoner_id
      if not prisonerId then
        return
      end
      local prisonerCfg = PlayerData:GetFactoryData(prisonerId)
      element.Group_PrisonerPlaced.Img_Prisoner:SetSprite(prisonerCfg.prisonerIconPath)
      element.Group_PrisonerPlaced.Group_ExtraProduct.Txt_:SetText(math.floor(prisonerCfg.extraOutputProbability * 100) .. "%")
      local isSelected = DataModel.SelectPosIndex[tostring(elementIndex)] ~= nil
      local isMonitor = DataModel.IsRoomMonitor(DataModel.GetWorkPrisonerUid(DataModel.CurRoomIndex, elementIndex))
      if isSelected then
        element.Group_PrisonerPlaced.Group_PickFrame:SetActive(true)
        element.Group_PrisonerPlaced.Group_PickFrame.Group_Monitor:SetActive(isMonitor)
      else
        element.Group_PrisonerPlaced.Group_PickFrame:SetActive(false)
        element.Group_PrisonerPlaced.Group_Frame.Group_Monitor:SetActive(isMonitor)
      end
      element.Group_PrisonerPlaced.Group_PickFrame:SetActive(isSelected)
      element.Group_PrisonerPlaced.Btn_Pick:SetClickParam(elementIndex)
    else
      element.Group_PrisonerEmpty.Img_PrisonerEmpty.Btn_:SetClickParam(elementIndex)
    end
  else
    element.Group_Machine:SetActive(false)
    element.Group_PrisonerEmpty:SetActive(false)
    element.Group_PrisonerPlaced:SetActive(false)
    element.Group_ProductCondition:SetActive(false)
  end
end

function Controller:RefreshWorkPlacedElement()
  DataModel.CountDownHandler = {}
  View.Group_WorkerList.StaticGrid_Unit.grid.self:SetDataCount(18)
  View.Group_WorkerList.StaticGrid_Unit.grid.self:RefreshAllElement()
end

function Controller:SetFormulaGroupListElement(element, elementIndex)
  local row = DataModel.CurRoomFormulaGroup[tostring(DataModel.CurSelectFormulaType)][elementIndex]
  if row then
    local cfg = PlayerData:GetFactoryData(row.id)
    element.Img_Item2:SetSprite(cfg.iconPath)
    element.Group_Name.Txt_Item:SetText(cfg.name)
    element.Img_Select:SetActive(row.id == DataModel.CurSelectFormulaId)
    element.Img_Electric.Txt_Num:SetText(cfg.electricityOccupation)
    element.Btn_Item:SetClickParam(elementIndex)
    element.Group_NoGet:SetActive(not DataModel.CheckUnlockFormula(row.id))
    element.Group_NoGet.Btn_:SetClickParam(elementIndex)
    element.Btn_Tips:SetClickParam(cfg.product)
    View.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
      local maskWidth = element.Group_Name.Rect.rect.width
      local txtWidth = element.Group_Name.Txt_Item.Rect.rect.width
      local objName = element.name
      if maskWidth < txtWidth then
        local scrollSpeed = DataModel.NameScrollSpeed
        scrollSpeed = scrollSpeed * string.getLength(cfg.name)
        element.Group_Name.Txt_Item:SetText(cfg.name .. "    " .. cfg.name)
        local spaceWidth = math.floor(element.Group_Name.Txt_Item.Txt.fontSize / 5) + 1
        local spaceNum = 4
        txtWidth = element.Group_Name.Txt_Item.Rect.rect.width
        local endposx = txtWidth / 2 + spaceWidth * spaceNum / 2
        element.Group_Name.Txt_Item:SetLocalPositionX(endposx)
        local t = DataModel.Tweens[objName]
        if t then
          DOTweenTools.KillTween(t)
        end
        local tween = DOTweenTools.DOLocalMoveX(element.Group_Name.Txt_Item.transform, -endposx, scrollSpeed):SetLoops(-1):SetEase(CS.DG.Tweening.Ease.Linear)
        DataModel.Tweens[objName] = tween
      else
        local t = DataModel.Tweens[objName]
        if t then
          DOTweenTools.KillTween(t)
          DataModel.Tweens[objName] = nil
        end
      end
    end))
  end
end

function Controller:RefreshFormulaList()
  local sortFormulaList = DataModel.CurRoomFormulaGroup[tostring(DataModel.CurSelectFormulaType)] or {}
  local count = table.count(sortFormulaList)
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.01))
    View.Group_Bottom.Group_Formula.Group_Type.NewScrollGrid_FormulaList.grid.self:SetDataCount(count)
    View.Group_Bottom.Group_Formula.Group_Type.NewScrollGrid_FormulaList.grid.self:RefreshAllElement()
  end))
end

function Controller:SetFormulaTypeElement(element, elementIndex)
  local row = DataModel.CurRoomFormulaType[elementIndex]
  if row then
    local cfg = PlayerData:GetFactoryData(row.id)
    element.Btn_Custom.Group_Custom.Txt_Custom:SetText(cfg.tagName)
    element.Btn_Custom.Img_CustomLight.Txt_Customselect:SetText(cfg.tagName)
    element.Btn_Custom.Img_CustomLight:SetActive(row.id == DataModel.CurSelectFormulaType)
    element.Btn_Custom:SetClickParam(elementIndex)
  end
end

function Controller:RefreshFormulaTypeList()
  View.Group_Bottom.Group_Formula.Group_Type.Group_Type.Group_Btn_Zuijin.Btn_Custom.Img_CustomLight:SetActive(DataModel.CurSelectFormulaType == 0)
  View.Group_Bottom.Group_Formula.Group_Type.Group_Type.Btn_NormalFormula.Img_NormalFormulaLight:SetActive(DataModel.CurSelectFormulaType == -1)
  View.Group_Bottom.Group_Formula.Group_Type.Group_Type.Group_BoxBtn.Img_Mask.StaticGrid_Type.grid.self:SetDataCount(table.count(DataModel.CurRoomFormulaType))
  View.Group_Bottom.Group_Formula.Group_Type.Group_Type.Group_BoxBtn.Img_Mask.StaticGrid_Type.grid.self:RefreshAllElement()
end

function Controller:SetExpandFormulaGroupListElement(element, elementIndex)
  local row = DataModel.CurRoomFormulaGroup[tostring(DataModel.CurSelectFormulaType)][elementIndex]
  if row then
    local cfg = PlayerData:GetFactoryData(row.id)
    element.Img_Item2:SetSprite(cfg.iconPath)
    element.Group_Name.Txt_Item:SetText(cfg.name)
    element.Img_Select:SetActive(row.id == DataModel.CurSelectFormulaId)
    element.Img_Electric.Txt_Num:SetText(cfg.electricityOccupation)
    element.Btn_Item:SetClickParam(elementIndex)
    element.Group_NoGet:SetActive(not DataModel.CheckUnlockFormula(row.id))
    element.Group_NoGet.Btn_:SetClickParam(elementIndex)
    element.Btn_Tips:SetClickParam(cfg.product)
    View.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
      local maskWidth = element.Group_Name.Rect.rect.width
      local txtWidth = element.Group_Name.Txt_Item.Rect.rect.width
      local objName = element.name
      if maskWidth < txtWidth then
        local scrollSpeed = DataModel.NameScrollSpeed
        scrollSpeed = scrollSpeed * string.getLength(cfg.name)
        element.Group_Name.Txt_Item:SetText(cfg.name .. "    " .. cfg.name)
        local spaceWidth = math.floor(element.Group_Name.Txt_Item.Txt.fontSize / 5) + 1
        local spaceNum = 4
        txtWidth = element.Group_Name.Txt_Item.Rect.rect.width
        local endposx = txtWidth / 2 + spaceWidth * spaceNum / 2
        element.Group_Name.Txt_Item:SetLocalPositionX(endposx)
        local t = DataModel.Tweens[objName]
        if t then
          DOTweenTools.KillTween(t)
        end
        local tween = DOTweenTools.DOLocalMoveX(element.Group_Name.Txt_Item.transform, -endposx, scrollSpeed):SetLoops(-1):SetEase(CS.DG.Tweening.Ease.Linear)
        DataModel.Tweens[objName] = tween
      else
        element.Group_Name.Txt_Item:SetText(cfg.name)
        local t = DataModel.Tweens[objName]
        if t then
          DOTweenTools.KillTween(t)
          DataModel.Tweens[objName] = nil
        end
      end
    end))
  end
end

function Controller:RefreshExpandFormulaGroupList()
  local sortFormulaList = DataModel.CurRoomFormulaGroup[tostring(DataModel.CurSelectFormulaType)] or {}
  local count = table.count(sortFormulaList)
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.01))
    View.Group_FormulaList.Group_Formula.Group_Type.NewScrollGrid_FormulaList.grid.self:SetDataCount(count)
    View.Group_FormulaList.Group_Formula.Group_Type.NewScrollGrid_FormulaList.grid.self:RefreshAllElement()
  end))
end

function Controller:SetExpandFormulaTypeElement(element, elementIndex)
  local row = DataModel.CurRoomFormulaType[elementIndex]
  if row then
    local cfg = PlayerData:GetFactoryData(row.id)
    element.Btn_Custom.Group_Custom.Txt_Custom:SetText(cfg.tagName)
    element.Btn_Custom.Img_CustomLight.Txt_Customselect:SetText(cfg.tagName)
    element.Btn_Custom.Img_CustomLight:SetActive(row.id == DataModel.CurSelectFormulaType)
    element.Btn_Custom:SetClickParam(elementIndex)
  end
end

function Controller:RefreshExpandFormulaTypeList()
  View.Group_FormulaList.Group_Formula.Group_Type.Group_Type.Group_Btn_Zuijin.Btn_Custom.Img_CustomLight:SetActive(DataModel.CurSelectFormulaType == 0)
  View.Group_FormulaList.Group_Formula.Group_Type.Group_Type.Btn_NormalFormula.Img_NormalFormulaLight:SetActive(DataModel.CurSelectFormulaType == -1)
  View.Group_FormulaList.Group_Formula.Group_Type.Group_Type.Group_BoxBtn.Img_Mask.StaticGrid_Type.grid.self:SetDataCount(table.count(DataModel.CurRoomFormulaType))
  View.Group_FormulaList.Group_Formula.Group_Type.Group_Type.Group_BoxBtn.Img_Mask.StaticGrid_Type.grid.self:RefreshAllElement()
end

function Controller:SetRequireItemElement(element, elementIndex)
  if DataModel.CurSelectFormulaId == nil or DataModel.CurSelectFormulaId <= 0 then
    return
  end
  local reqList = DataModel.CurSelectFormulaProductionCfg.costList
  local programmeList = DataModel.CurSelectFormulaProductionCfg.programmeList
  local count = programmeList[DataModel.CurSelectTimeIdx].count
  local row = reqList[elementIndex]
  if row then
    element.Group_Item:SetActive(true)
    element.Group_Empty:SetActive(false)
    local hasNum = DataModel.GetGoodsNumById(row.id)
    local selectPrisonerCount = table.count(DataModel.SelectPosIndex)
    local needNum = row.num * count * selectPrisonerCount
    CommonItem:SetItem(element.Group_Item, {
      id = row.id,
      num = needNum
    })
    element.Group_Item.Group_Num.Txt_NeedRed:SetActive(hasNum < needNum)
    element.Group_Item.Group_Num.Txt_Need:SetActive(hasNum >= needNum)
    element.Group_Item.Group_Num.Txt_Need:SetText(needNum)
    element.Group_Item.Group_Num.Txt_NeedRed:SetText(needNum)
    element.Group_Item.Group_Num.Txt_Have:SetText(hasNum)
    element.Group_Item.Btn_Item:SetClickParam(row.id)
  else
    element.Group_Item:SetActive(false)
    element.Group_Empty:SetActive(true)
  end
end

function Controller:RefreshRequireItemList()
  if DataModel.CurSelectFormulaId == nil or DataModel.CurSelectFormulaId <= 0 then
    return
  end
  local reqList = DataModel.CurSelectFormulaProductionCfg.costList
  if #reqList <= 4 then
    View.Group_Bottom.Group_Programme.Group_Programme.ScrollGrid_Required.grid.self:SetDataCount(4)
    View.Group_Bottom.Group_Programme.Group_Programme.ScrollGrid_Required.grid.self:RefreshAllElement()
  else
    View.Group_Bottom.Group_Programme.Group_Programme.ScrollGrid_Required.grid.self:SetDataCount(#reqList)
    View.Group_Bottom.Group_Programme.Group_Programme.ScrollGrid_Required.grid.self:RefreshAllElement()
  end
end

function Controller:SetTimeElement(element, elementIndex)
  local perCountHour = DataModel.CurSelectFormulaProductionCfg.perTime // 60
  local programmeList = DataModel.CurSelectFormulaProductionCfg.programmeList
  local row = programmeList[elementIndex]
  if row then
    element.Btn_Choose.Txt_:SetText(string.format(GetText(80608132), row.count * perCountHour))
    element.Group_Choose.Txt_:SetText(string.format(GetText(80608132), row.count * perCountHour))
    element.Group_Choose:SetActive(elementIndex == DataModel.CurSelectTimeIdx)
    element.Btn_Choose:SetClickParam(elementIndex)
  end
end

function Controller:RefreshTimeList()
  local programmeList = DataModel.CurSelectFormulaProductionCfg.programmeList
  local count = #programmeList
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
    View.Group_Bottom.Group_Programme.Group_Programme.Group_Time.StaticGrid_Time.grid.self:SetDataCount(count)
    View.Group_Bottom.Group_Programme.Group_Programme.Group_Time.StaticGrid_Time.grid.self:RefreshAllElement()
  end))
end

function Controller:RefreshRequirePanel()
  local selectCount = table.count(DataModel.SelectPosIndex)
  local unlockGrid = DataModel.GetUnlockGridCount()
  if selectCount == 0 then
    View.Group_Bottom.Group_Programme.Group_PrisonerNum.Txt_:SetText(string.format(GetText(80608128), selectCount, unlockGrid))
  else
    View.Group_Bottom.Group_Programme.Group_PrisonerNum.Txt_:SetText(string.format("%d/%d", selectCount, unlockGrid))
  end
  local canShowRequire = 0 < selectCount and 0 < DataModel.CurSelectFormulaId
  View.Group_Bottom.Group_Programme.Group_NoPrisoner:SetActive(not canShowRequire)
  View.Group_Bottom.Group_Programme.Group_Programme:SetActive(canShowRequire)
  Controller:RefreshPower()
  if canShowRequire then
    Controller:RefreshRequireItemList()
    Controller:RefreshTimeList()
    local productCount = DataModel.CalExpectedProductNum()
    View.Group_Bottom.Group_Programme.Group_Programme.Group_ProductNum.Txt_:SetText(productCount)
    local powerCost = PlayerData:GetFactoryData(DataModel.CurSelectFormulaId).electricityOccupation
    local prisonCount = table.count(DataModel.SelectPosIndex)
    View.Group_Bottom.Group_Programme.Group_Programme.Group_ProductNum.Group_Power.Txt_:SetText(powerCost * prisonCount)
  end
end

function Controller:ClickWorkerElement(idx)
  local hasPlant, isFinish = DataModel.IsWorkPlaceHasPlant(DataModel.CurRoomIndex, idx)
  if hasPlant then
    if isFinish then
      return
    end
  else
    local element = View.Group_WorkerList.StaticGrid_Unit.grid[idx]
    if DataModel.SelectPosIndex[tostring(idx)] then
      DataModel.SelectPosIndex[tostring(idx)] = nil
    else
      DataModel.SelectPosIndex[tostring(idx)] = true
      element.self:SetActive(false)
      element.self:SetActive(true)
      local animatorCtr = element.self
      View.self:SelectPlayAnim(animatorCtr, "Select")
    end
    Controller:SetWorkPlaceElement(element, idx)
    Controller:RefreshRequirePanel()
    Controller:RefreshOneBtnState()
  end
end

function Controller:RefreshOneBtnState()
  local hasUnChoose = false
  local unlockGrid = DataModel.GetUnlockGridCount()
  for i = 1, unlockGrid do
    local hasPrisoner = DataModel.HasWorkingPrisoner(DataModel.CurRoomIndex, i)
    local hasPlant = DataModel.IsWorkPlaceHasPlant(DataModel.CurRoomIndex, i)
    local isSelect = DataModel.SelectPosIndex[tostring(i)] ~= nil
    if hasPrisoner and not isSelect and not hasPlant then
      hasUnChoose = true
      break
    end
  end
  View.Group_Bottom.Group_Programme.Group_PrisonerNum.Btn_All:SetActive(hasUnChoose)
  View.Group_Bottom.Group_Programme.Group_PrisonerNum.Btn_AllCancel:SetActive(not hasUnChoose)
end

function Controller:OneBtnChooseAll()
  DataModel.SelectPosIndex = {}
  local unlockGrid = DataModel.GetUnlockGridCount()
  for i = 1, unlockGrid do
    local hasPlant = DataModel.IsWorkPlaceHasPlant(DataModel.CurRoomIndex, i)
    if not hasPlant then
      local hasPrisoner = DataModel.HasWorkingPrisoner(DataModel.CurRoomIndex, i)
      if hasPrisoner then
        DataModel.SelectPosIndex[tostring(i)] = true
      end
    end
  end
  Controller:RefreshWorkPlacedElement()
  Controller:RefreshRequirePanel()
  Controller:RefreshOneBtnState()
end

function Controller:OneBtnCancelAll()
  DataModel.SelectPosIndex = {}
  Controller:RefreshWorkPlacedElement()
  Controller:RefreshRequirePanel()
  Controller:RefreshOneBtnState()
end

function Controller:ShowExpandFormulaList()
  DataModel.IsExpand = true
  View.Group_FormulaList:SetActive(true)
  View.Group_Bottom.Group_Formula:SetActive(false)
  Controller:RefreshExpandFormulaGroupList()
  Controller:RefreshExpandFormulaTypeList()
  Controller:RefreshLockElement()
end

function Controller:SetRoomIndexElement(element, elementIndex)
  local isUnlock = elementIndex <= DataModel.TotalRoomCount
  element.Group_Lock:SetActive(not isUnlock)
  element.Group_Workshop:SetActive(isUnlock)
  element.Img_Pick:SetActive(elementIndex == DataModel.CurRoomIndex)
  element.Group_Lock.Txt_0:SetText(string.format("%02d", elementIndex))
  element.Group_Workshop.Txt_0:SetText(string.format("%02d", elementIndex))
  if isUnlock then
    local unlockGrid = DataModel.GetUnlockGridCount()
    local type
    if unlockGrid == 0 then
      type = PrisonData.GetPrisonCA().initialHomeFurnitureList[1].schemeType
    else
      local program = PlayerData.ServerData.user_prison_info.workshops_programme[tostring(elementIndex)] or "1"
      type = PrisonData.GetPrisonCA().initialHomeFurnitureList[tonumber(program)].schemeType
    end
    local typeName = PlayerData:GetFactoryData(type).typeName
    element.Group_Workshop.Txt_Tips:SetText(typeName)
  end
  element.Btn_:SetClickParam(elementIndex)
end

function Controller:RefreshRoomList()
  View.Group_Windows.ScrollGrid_QuickJump.grid.self:SetDataCount(DataModel.MaxRoomCount)
  View.Group_Windows.ScrollGrid_QuickJump.grid.self:RefreshAllElement()
end

function Controller:ShowRoomWindow()
  View.Group_Windows:SetActive(true)
  Controller:RefreshRoomList()
end

function Controller:SwitchFormulaType(type)
  if type ~= DataModel.CurSelectFormulaType then
    DataModel.CurSelectFormulaType = type
    if DataModel.IsExpand then
      Controller:RefreshExpandFormulaTypeList()
      Controller:RefreshExpandFormulaGroupList()
    else
      Controller:RefreshFormulaTypeList()
      Controller:RefreshFormulaList()
    end
  end
end

function Controller:ChangeRoom(roomIndex)
  if DataModel.CurRoomIndex == roomIndex then
    return
  end
  if roomIndex > DataModel.TotalRoomCount then
    return
  end
  DataModel.CurRoomIndex = roomIndex
  Controller:Init()
  Controller:RefreshTop()
  Controller:RefreshRoomList()
end

function Controller:AreaUnlockCallBack(roomIndex, targetUnlockArea)
  if roomIndex < 0 or targetUnlockArea < 0 then
    return
  end
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.3))
    local unlockCtr = View.Group_UnLockEffect
    local baseCtr = View.Group_Lock.StaticGrid_.grid[targetUnlockArea]
    unlockCtr.self:SetActive(false)
    unlockCtr.Group_Mask.Group_Num.Txt_NumunLock:SetText(baseCtr.Group_Mask.Group_Num.Txt_NumunLock.Txt.text)
    unlockCtr.transform.position = baseCtr.self.transform.position
    unlockCtr.self:SetActive(true)
    local lockAnimator = unlockCtr.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
    lockAnimator:Play("UnLock")
    for i = 1, 3 do
      local targetIndex = (targetUnlockArea - 1) * 3 + i
      if 0 < targetIndex and targetIndex <= 18 then
        local element = View.Group_WorkerList.StaticGrid_Unit.grid[targetIndex]
        Controller:SetWorkPlaceElement(element, targetIndex)
      end
    end
    Controller:RefreshLockElement()
    if PrisonData.roomIndex == DataModel.CurRoomIndex then
      PrisonController.InitRoom(DataModel.CurRoomIndex, View.self)
    end
  end))
end

function Controller:SelectFormula(id)
  if not id then
    return
  end
  if DataModel.CurSelectFormulaId ~= id then
    if not DataModel.CheckUnlockFormula(id) then
      CommonTips.OpenTips(GetText(80608624))
      return
    end
    DataModel.CurSelectFormulaId = id
    DataModel.CurSelectFormulaProductionCfg = PlayerData:GetFactoryData(id)
    DataModel.CurSelectTimeIdx = 1
    if DataModel.IsExpand then
      Controller:RefreshExpandFormulaGroupList()
    else
      Controller:RefreshFormulaList()
    end
    Controller:RefreshRequirePanel()
  end
end

function Controller:TrySetProductPlant()
  local workShopId = DataModel.CurRoomIndex
  local formulaGroupId = DataModel.CurSelectFormulaId
  if not formulaGroupId or formulaGroupId <= 0 then
    return
  end
  if not DataModel.CheckUnlockFormula(formulaGroupId) then
    CommonTips.OpenTips(GetText(80608624))
    return
  end
  local gradIdList = {}
  for posIndex, value in pairs(DataModel.SelectPosIndex) do
    local u_pid = DataModel.GetWorkPrisonerUid(DataModel.CurRoomIndex, posIndex)
    local illHappen = PrisonData.IsIllHappen(u_pid)
    if illHappen then
      CommonTips.OpenTips(GetText(80608070))
      return
    end
    table.insert(gradIdList, tostring(posIndex))
  end
  if #gradIdList == 0 then
    return
  end
  local count = DataModel.CurSelectFormulaProductionCfg.programmeList[DataModel.CurSelectTimeIdx].count
  if not count or count <= 0 then
    return
  end
  local costList = PlayerData:GetFactoryData(DataModel.CurSelectFormulaId).costList
  local isEnough = true
  for i, v in ipairs(costList) do
    if 0 < v.id then
      local has = DataModel.GetGoodsNumById(v.id)
      local need = v.num * count * table.count(DataModel.SelectPosIndex)
      if has < need then
        isEnough = false
        break
      end
    end
  end
  if not isEnough then
    CommonTips.OpenTips(GetText(80607072))
    return
  end
  local add = 0
  if DataModel.CurSelectFormulaId and DataModel.CurSelectFormulaId > 0 then
    local powerCost = PlayerData:GetFactoryData(DataModel.CurSelectFormulaId).electricityOccupation
    add = powerCost * table.count(DataModel.SelectPosIndex)
  end
  local afterPower = DataModel.CurPower + add
  if afterPower > DataModel.MaxPower then
    CommonTips.OpenTips(GetText(80608140))
    return
  end
  Net:SendProto("prison.set_product_plant", function(json)
    if json.workshops_product_plant then
      PlayerData.ServerData.user_prison_info.workshops_product_plant = json.workshops_product_plant
    end
    if json.power then
      PlayerData.ServerData.user_prison_info.power = json.power
    end
    for k, v in pairs(costList) do
      local totalCost = v.num * count * table.count(DataModel.SelectPosIndex)
      if not TradeDataModel.InTravel and TradeDataModel.EndCity == 83000017 then
        local trainNum = PlayerData:GetGoodsById(v.id).num
        if 0 < trainNum and totalCost <= trainNum then
          totalCost = 0
          PlayerData:GetGoodsById(v.id).num = trainNum - v.num * count * table.count(DataModel.SelectPosIndex) > 0 and trainNum - v.num * count * table.count(DataModel.SelectPosIndex) or 0
        else
          totalCost = totalCost - trainNum
          PlayerData:GetGoodsById(v.id).num = 0
        end
      end
      if 0 < totalCost then
        local rawMaterialData = PlayerData.ServerData.user_prison_info.raw_material[tostring(v.id)]
        local materialNum = rawMaterialData and rawMaterialData.num or 0
        if totalCost <= materialNum then
          PlayerData.ServerData.user_prison_info.raw_material[tostring(v.id)].num = materialNum - totalCost
          totalCost = 0
        else
          totalCost = totalCost - materialNum
          if rawMaterialData then
            rawMaterialData.num = 0
          end
        end
        if 0 < totalCost then
          local productData = PlayerData.ServerData.user_prison_info.product[tostring(v.id)]
          local productNum = productData and productData.num or 0
          if totalCost <= productNum then
            productData.num = productNum - totalCost
          else
          end
        end
      end
    end
    DataModel.InitPlantData()
    local roomIndex = PrisonData.roomIndex
    for cellIndex, v in pairs(DataModel.SelectPosIndex) do
      PrisonController.InitProductEvent(roomIndex, cellIndex)
      PrisonController.InitPrisonerAnim(roomIndex, cellIndex)
    end
    DataModel.SelectPosIndex = {}
    Controller:RefreshWorkPlacedElement()
    Controller:RefreshRequirePanel()
    DataModel.CurPower = PrisonData.GetUsePower()
    Controller:RefreshTop()
    DataModel.RecordRecentFormulaGroup(formulaGroupId)
    if DataModel.IsExpand then
      Controller:RefreshExpandFormulaGroupList()
    else
      Controller:RefreshFormulaList()
    end
    PrisonController.ChangeRoom(DataModel.CurRoomIndex, View.self)
    UIManager:GoBack()
    CommonTips.OpenTips(GetText(80608385))
  end, tostring(workShopId), tostring(formulaGroupId), Json.encode(gradIdList), count)
end

function Controller:TryReceiveProductPlant(idx)
  if not idx then
    return
  end
  local gridIdList = {}
  table.insert(gridIdList, tostring(idx))
  local hasPlant, isFinish = DataModel.IsWorkPlaceHasPlant(DataModel.CurRoomIndex, idx)
  if hasPlant and isFinish then
    Net:SendProto("prison.receive_product_plant", function(json)
      if json.workshops_product_plant then
        PlayerData.ServerData.user_prison_info.workshops_product_plant = json.workshops_product_plant
      end
      if json.power then
        PlayerData.ServerData.user_prison_info.power = json.power
      end
      if json.product then
        PlayerData.ServerData.user_prison_info.product = json.product
      end
      Controller:RefreshTop()
    end, tostring(DataModel.CurRoomIndex), Json.encode(gridIdList))
  end
end

function Controller:TryUnlockNextArea()
  local canUnlock, targetUnlockArea = DataModel.CheckNextAreaCanUnlock()
  if not canUnlock then
    return
  end
  local prisonCfg = PrisonData.GetPrisonCA()
  local price = prisonCfg.buySpacePrice[1].num
  local t = {}
  t.itemId = 11400001
  t.useNum = price
  t.addUnit = true
  local roomIndex = DataModel.CurRoomIndex
  if PlayerData:GetGoodsById(t.itemId).num < t.useNum then
    CommonTips.OpenTips(80600062)
    return
  end
  
  local function confirmCb()
    Net:SendProto("prison.unlock_front", function(json)
      if json.furniture then
        PlayerData.ServerData.user_prison_info.furniture = json.furniture
      end
      if json.workshops_front then
        PlayerData.ServerData.user_prison_info.workshops_front = json.workshops_front
      end
      if json.workshops_furniture then
        PlayerData.ServerData.user_prison_info.workshops_furniture = json.workshops_furniture
      end
      DataModel.InitRoomUnlockCount()
      DataModel.ResetRoomData()
      DataModel.InitWorkerData()
      if json.reward then
        CommonTips.OpenShowItem(json.reward, function()
          UIManager:Open("UI/Prison/Manage/OpenWorkshopSuccess", Json.encode({
            roomIndex = roomIndex,
            unlockIndex = targetUnlockArea,
            isFromProductionEdit = true
          }))
        end)
      end
      Controller:RefreshTop()
    end, tostring(roomIndex))
  end
  
  UIManager:Open("UI/Prison/Manage/PrisonSpaceUnlockPrompt", Json.encode({roomIndex = roomIndex}), confirmCb)
end

function Controller:OpenGetWayPanel(idx, posx)
  local data = {}
  local id = DataModel.CurRoomFormulaGroup[tostring(DataModel.CurSelectFormulaType)][idx].id
  local cfg = PlayerData:GetFactoryData(id)
  data.itemID = cfg.unlock
  if posx then
    local scalex = UIManager:GetCanvas().transform.localScale.x
    local maxPox = View.Group_FormulaList.transform.position.x / scalex - 322
    if posx > maxPox then
      posx = maxPox
    end
  end
  data.posX = posx or 270
  data.posY = -180
  UIManager:Open("UI/Common/Group_GetWay", Json.encode(data))
  DataModel.jumpToExchangeFormulaIndex = idx
end

function Controller.RefreshAfterJumpToExchange()
  if DataModel.jumpToExchangeFormulaIndex then
    local data = DataModel.CurRoomFormulaGroup[tostring(DataModel.CurSelectFormulaType)][DataModel.jumpToExchangeFormulaIndex]
    data.unlock = 1
    if DataModel.IsExpand then
      Controller:RefreshExpandFormulaGroupList()
    else
      Controller:RefreshFormulaList()
    end
    Controller:RefreshRequirePanel()
  end
end

return Controller
