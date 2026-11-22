local View = require("UIIllustration_Equipment/UIIllustration_EquipmentView")
local DataModel = require("UIIllustration_Equipment/UIIllustration_EquipmentDataModel")
local Controller = {}
local filterData = {}

local function ControllerFilterBtn()
  local equipTypeData = filterData[View.Group_Filter.Group_Type.name]
  local rareData = filterData[View.Group_Filter.Group_Rarity.name]
  local stateData = filterData[View.Group_Filter.Group_State.name]
  View.Group_TopRight.Btn_Screen.Img_P:SetActive(equipTypeData ~= nil and equipTypeData.count ~= 0 and (rareData == nil or rareData.count == 0) and (stateData == nil or stateData.count == 0))
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
    if name == "Group_Type" then
      length = 0
      local config = PlayerData:GetFactoryData(99900017).enumEquipTypeList
      for i, v in ipairs(config) do
        local btn = "Btn_T0" .. i
        if Type[btn] then
          Type[btn].self:SetActive(true)
          Type[btn].Txt_:SetText(PlayerData:GetFactoryData(config[i].equipType).Name)
          length = length + 1
        end
      end
    end
    if name == "Group_Rarity" then
      length = 0
      local config = {
        [1] = {id = 12600887},
        [2] = {id = 12600888},
        [3] = {id = 12600889},
        [4] = {id = 12600890}
      }
      for i = 1, 4 do
        local btn = "Btn_Rarity_0" .. i
        if Type[btn] then
          Type[btn].self:SetActive(true)
          Type[btn].Txt_:SetSprite(PlayerData:GetFactoryData(config[i].id).icon)
          length = length + 1
        end
      end
    end
    if name == "Group_State" then
      length = 0
      for i = 1, 2 do
        local btn = "Btn_S0" .. i
        if Type[btn] then
          Type[btn].self:SetActive(true)
          Type[btn].Txt_:SetText(i == 1 and GetText(80607379) or GetText(80607380))
          length = length + 1
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
  DataModel.UnlockCount = 0
  DataModel.TotalCount = 0
  Controller:InitFilter()
  DataModel.EquipList = {}
  DataModel.AllEquipList = {}
  DataModel.NowShowList = {}
  DataModel.Element = {}
  DataModel.InitAffixData()
  local equipList = PlayerData:GetFactoryData(80900010).equipmentList
  for i, v in ipairs(equipList) do
    local row = {}
    local ca = PlayerData:GetFactoryData(v.id)
    row.quality = ca.quality
    row.qualityIndex = DataModel.QualityCfg[ca.quality].qualityIndex
    row.side = ca.campTagId
    row.id = v.id
    row.name = ca.name
    row.icon = ca.iconPath
    row.listIndex = i
    row.equipType = ca.equipTagId
    row.typeIndex = PlayerData:GetFactoryData(ca.equipTagId).typeID
    row.server = PlayerData:GetEquipmentById(v.id)
    row.sortIndex = 0
    if 0 < table.count(row.server) then
      row.sortIndex = 1
      DataModel.UnlockCount = DataModel.UnlockCount + 1
    end
    table.insert(DataModel.AllEquipList, row)
    DataModel.TotalCount = DataModel.TotalCount + 1
    if DataModel.EquipList[row.side] == nil then
      DataModel.EquipList[row.side] = {}
    end
    table.insert(DataModel.EquipList[row.side], row)
  end
  local enumTypeList = PlayerData:GetFactoryData(99900017).bookEquipmentEnumList
  DataModel.EnumEquipIndex = {}
  DataModel.EnumEquipIndex[1] = DataModel.AllEquipList
  DataModel.EnumEquipSideList = {}
  local index = 1
  table.insert(DataModel.EnumEquipSideList, {
    id = "-1",
    typeName = GetText(80607338),
    icon = "UI/Book/Character_Illustration/Allicon",
    index = index
  })
  for i = 1, table.count(enumTypeList) do
    local row = {}
    local ca = PlayerData:GetFactoryData(enumTypeList[i].id)
    index = index + 1
    row.index = index
    row.icon = ca.icon
    row.typeName = ca.sideName
    row.id = ca.id
    DataModel.EnumEquipIndex[row.index] = DataModel.EquipList[ca.id]
    table.insert(DataModel.EnumEquipSideList, row)
  end
  DataModel.RightIndex = 1
  DataModel.SortStateBtn = nil
  DataModel.SortStateIndex = 0
  DataModel.isFirst = true
  View.Group_RightList.ScrollGrid_RightList.grid.self:SetDataCount(table.count(DataModel.EnumEquipSideList))
  View.Group_RightList.ScrollGrid_RightList.grid.self:RefreshAllElement()
  DataModel.SortState.index = 1
  DataModel.SortState.currentDown = true
  Controller:Reset(View.Group_TopRight.Btn_Acquiesce)
  Controller:RefreshData()
  View.Group_TopRightTxt.Txt_Num:SetText(DataModel.UnlockCount .. "/" .. DataModel.TotalCount)
end

function Controller:Filter()
  local list = {}
  local typeData = filterData[View.Group_Filter.Group_Type.name]
  local rareData = filterData[View.Group_Filter.Group_Rarity.name]
  local stateData = filterData[View.Group_Filter.Group_State.name]
  if DataModel.EnumEquipIndex[DataModel.RightIndex] == nil then
    DataModel.NowShowList = {}
  else
    for i, data in ipairs(DataModel.EnumEquipIndex[DataModel.RightIndex]) do
      if IsMeetFilter(typeData, data.typeIndex) and IsMeetFilter(rareData, data.qualityIndex) and IsMeetFilter(stateData, data.sortIndex + 1) then
        table.insert(list, data)
      end
    end
    DataModel.NowShowList = list
  end
end

function Controller:RefreshData()
  Controller:Filter()
  Controller:SortRefreshData()
  Controller:ClearTweens()
  DataModel.Element = {}
  if DataModel.isFirst then
    View.Group_Card.NewScrollGrid_EquipmentCard.grid.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
      View.Group_Card.NewScrollGrid_EquipmentCard.grid.self:SetDataCount(table.count(DataModel.NowShowList))
      View.Group_Card.NewScrollGrid_EquipmentCard.grid.self:RefreshAllElement()
      View.Group_Card.NewScrollGrid_EquipmentCard.grid.self:MoveToTop()
    end))
    DataModel.isFirst = false
  else
    View.Group_Card.NewScrollGrid_EquipmentCard.grid.self:SetDataCount(table.count(DataModel.NowShowList))
    View.Group_Card.NewScrollGrid_EquipmentCard.grid.self:RefreshAllElement()
    View.Group_Card.NewScrollGrid_EquipmentCard.grid.self:MoveToTop()
  end
end

function Controller:RefreshAffixData()
  local curChoosePart = DataModel.AffixPartCfg[DataModel.CurAffixPartIndex].id or "-1"
  local curChooseCamp = DataModel.EnumEquipSideList[tonumber(DataModel.RightIndex)].id or "-1"
  DataModel.CurAffixList = DataModel.CacheAffixData[tostring(curChoosePart)][tostring(curChooseCamp)] or {}
  View.Group_Affix.ScrollGrid_Affix.grid.self:SetDataCount(table.count(DataModel.CurAffixList))
  View.Group_Affix.ScrollGrid_Affix.grid.self:RefreshAllElement()
end

function Controller:ChooseRightIndex(index)
  if index and index == DataModel.RightIndex and not isInit then
    return
  end
  if View.Group_RightList.ScrollGrid_RightList.grid[DataModel.RightIndex] then
    local old_element = View.Group_RightList.ScrollGrid_RightList.grid[DataModel.RightIndex]
    old_element.Btn_ArmamentType.Img_UnSelected.Img_Selected:SetActive(false)
  end
  DataModel.RightIndex = index
  local element = View.Group_RightList.ScrollGrid_RightList.grid[index]
  element.Btn_ArmamentType.Img_UnSelected.Img_Selected:SetActive(true)
  if not DataModel.isInAffix then
    Controller:RefreshData()
  else
    Controller:RefreshAffixData()
  end
end

function Controller:ChooseAffixPartIndex(index)
  if DataModel.CurAffixPartIndex == index then
    return
  end
  if DataModel.AffixPartCfg[DataModel.CurAffixPartIndex] then
    local old_element = DataModel.AffixPartCfg[DataModel.CurAffixPartIndex].ctr
    old_element.Img_Select:SetActive(false)
  end
  DataModel.CurAffixPartIndex = index
  local element = DataModel.AffixPartCfg[DataModel.CurAffixPartIndex].ctr
  element.Img_Select:SetActive(true)
  Controller:RefreshAffixData()
end

function Controller:Click(btn)
  if DataModel.SortState.currentBtn == btn then
    Controller:Revert(btn)
    Controller:RefreshData()
    return
  end
  Controller:Deactivate(DataModel.SortState.currentBtn)
  DataModel.SortState.currentBtn = btn
  Controller:Active(DataModel.SortState.currentBtn)
  Controller:RefreshData()
end

function Controller:ScreenBtn(Type, btn, enumIndex)
  local name = Type.Btn_All.name
  if btn == nil then
    btn = Type.Btn_All
  end
  local data = filterData[Type.name] or {}
  local length = data.length
  if DataModel.EquipmentFilter == nil then
    DataModel.EquipmentFilter = {}
  end
  if DataModel.EquipmentFilter[Type.name] == nil then
    DataModel.EquipmentFilter[Type.name] = {}
    DataModel.EquipmentFilter[Type.name].index = {}
  end
  DataModel.EquipmentFilter[Type.name].btn = btn
  DataModel.EquipmentFilter[Type.name].type = Type
  if next(data) == nil or name == btn.name then
    DataModel.EquipmentFilter[Type.name].index = {}
    InitFilterRolesData(Type)
    return
  else
    if data[name] then
      data[name] = nil
    end
    if data[btn.name] == nil then
      data[btn.name] = enumIndex
      DataModel.EquipmentFilter[Type.name].index[btn.name] = enumIndex
      data.count = data.count + 1
      if data.count == length then
        InitFilterRolesData(Type)
        return
      end
    else
      data[btn.name] = nil
      DataModel.EquipmentFilter[Type.name].index[btn.name] = nil
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
  for key, value in pairs(View.Group_TopRight) do
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
    return a.listIndex < b.listIndex
  end)
end

function Controller:SortUp(List)
  table.sort(List, function(a, b)
    return a.listIndex > b.listIndex
  end)
end

function Controller:QualitySortDown(List)
  table.sort(List, function(a, b)
    if a.qualityIndex == b.qualityIndex then
      return a.listIndex < b.listIndex
    else
      return a.qualityIndex > b.qualityIndex
    end
  end)
end

function Controller:QualitySortUp(List)
  table.sort(List, function(a, b)
    if a.qualityIndex == b.qualityIndex then
      return a.listIndex < b.listIndex
    else
      return a.qualityIndex < b.qualityIndex
    end
  end)
end

function Controller:SortRefreshData()
  DataModel.SortShowList = {}
  local index = DataModel.SortState.index
  if index == 1 then
    DataModel.SortShowList = DataModel.NowShowList
    if DataModel.SortState.currentDown then
      Controller:SortDown(DataModel.SortShowList)
    else
      Controller:SortUp(DataModel.SortShowList)
    end
    return
  end
  if index == 2 then
    DataModel.SortShowList = DataModel.NowShowList
    if DataModel.SortState.currentDown then
      Controller:QualitySortDown(DataModel.SortShowList)
    else
      Controller:QualitySortUp(DataModel.SortShowList)
    end
    return
  end
end

function Controller:InitFilter()
  filterData = {}
  InitFilterRolesData(View.Group_Filter.Group_Type, "typeInt")
  InitFilterRolesData(View.Group_Filter.Group_Rarity, "rarityInt")
  InitFilterRolesData(View.Group_Filter.Group_State, "stateInt")
end

function Controller:SetElement(element, row, index)
  local Group_Locked = element.Group_Locked
  Group_Locked:SetActive(false)
  local Group_Unlocked = element.Group_Unlocked
  element.Img_New:SetActive(false)
  if table.count(row.server) ~= 0 then
    Group_Unlocked:SetActive(true)
    element.Img_New:SetActive(row.server.read == 0)
  else
    Group_Locked:SetActive(true)
    element.Img_New:SetActive(false)
  end
  element.Group_Unlocked.Img_BG:SetSprite(DataModel.QualityCfg[row.quality].bgPath)
  element.Group_Unlocked.Img_Icon:SetColor(DataModel.QualityCfg[row.quality].iconColor)
  element.Group_Unlocked.Img_Icon:SetSprite(DataModel.EquipTypeIcon[tostring(row.equipType)])
  element.Group_Unlocked.Img_Equipment:SetSprite(row.icon)
  element.Group_Unlocked.Group_Name.Txt_Name:SetText(row.name)
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
    local maskWidth = element.Group_Unlocked.Group_Name.Rect.rect.width
    local txtWidth = element.Group_Unlocked.Group_Name.Txt_Name.Rect.rect.width
    local pName = element.transform.parent.gameObject.name
    if maskWidth < txtWidth then
      local scrollSpeed = 0.4
      scrollSpeed = scrollSpeed * string.getLength(row.name)
      element.Group_Unlocked.Group_Name.Txt_Name:SetText(row.name .. "    " .. row.name)
      local spaceWidth = math.floor(element.Group_Unlocked.Group_Name.Txt_Name.Txt.fontSize / 5) + 1
      local spaceNum = 4
      txtWidth = element.Group_Unlocked.Group_Name.Txt_Name.Rect.rect.width
      local endposx = txtWidth / 2 + spaceWidth * spaceNum / 2
      element.Group_Unlocked.Group_Name.Txt_Name:SetLocalPositionX(endposx)
      local t = DataModel.Tweens[pName]
      if t then
        DOTweenTools.KillTween(t)
      end
      local tween = DOTweenTools.DOLocalMoveX(element.Group_Unlocked.Group_Name.Txt_Name.transform, -endposx, scrollSpeed):SetLoops(-1):SetEase(CS.DG.Tweening.Ease.Linear)
      DataModel.Tweens[pName] = tween
    else
      local t = DataModel.Tweens[pName]
      if t then
        DOTweenTools.KillTween(t)
        DataModel.Tweens[pName] = nil
      end
    end
  end))
end

function Controller:SetRightElement(element, row, index)
  if row.id == "-1" then
    element.Img_UnSelected.Img_TypeIcon:SetWidthHeight(80, 80)
  else
    element.Img_UnSelected.Img_TypeIcon:SetWidthHeight(100, 100)
  end
  element.Img_UnSelected.Img_TypeIcon:SetSprite(row.icon)
  element.Img_UnSelected.Txt_TypeName:SetText(row.typeName)
  element.Img_UnSelected.Img_Selected:SetActive(false)
  element.Img_UnSelected:SetActive(true)
  if DataModel.RightIndex == index then
    element.Img_UnSelected.Img_Selected:SetActive(true)
  end
end

function Controller:ClickEquipment(index)
  local row = DataModel.NowShowList[index]
  if row.server.read and row.server.read == 0 then
    Net:SendProto("main.read", function(json)
      PlayerData:GetEquipmentById(row.id).read = 1
      row.server.read = 1
      local element = DataModel.Element[index]
      element.Btn_Card.Img_New:SetActive(false)
      CommonTips.OpenPreRewardDetailTips(row.id)
      return
    end, tostring(row.id), "equip")
  end
  CommonTips.OpenPreRewardDetailTips(row.id)
end

function Controller:ClearTweens()
  for i, v in pairs(DataModel.Tweens) do
    DOTweenTools.KillTween(v)
  end
  DataModel.Tweens = {}
end

function Controller:EnterAffixBook()
  DataModel.CacheSelectRecord.RightIndex = DataModel.RightIndex
  DataModel.isInAffix = true
  DataModel.CurAffixPartIndex = 1
  Controller:ChooseRightIndex(DataModel.RightIndex, true)
  DataModel.CurMaxLevelStats = 0
  View.Group_Affix.Group_TopLeft.Btn_Button.Img_OFF:SetActive(DataModel.CurMaxLevelStats == 0)
  View.Group_Affix.Group_TopLeft.Btn_Button.Img_ON:SetActive(DataModel.CurMaxLevelStats == 1)
  View.Group_Affix:SetActive(true)
end

function Controller:ExitAffixBook()
  DataModel.isInAffix = false
  DataModel.CurAffixPartIndex = 1
  Controller:ChooseRightIndex(DataModel.CacheSelectRecord.RightIndex)
  View.Group_Affix:SetActive(false)
end

function Controller:SwitchMaxLevelStats()
  DataModel.CurMaxLevelStats = DataModel.CurMaxLevelStats == 0 and 1 or 0
  View.Group_Affix.Group_TopLeft.Btn_Button.Img_OFF:SetActive(DataModel.CurMaxLevelStats == 0)
  View.Group_Affix.Group_TopLeft.Btn_Button.Img_ON:SetActive(DataModel.CurMaxLevelStats == 1)
  Controller:RefreshAffixData()
end

return Controller
