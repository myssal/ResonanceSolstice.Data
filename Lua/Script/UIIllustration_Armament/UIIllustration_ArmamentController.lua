local View = require("UIIllustration_Armament/UIIllustration_ArmamentView")
local DataModel = require("UIIllustration_Armament/UIIllustration_ArmamentDataModel")
local Controller = {}
local filterData = {}

local function ControllerFilterBtn()
  local rareData = filterData[View.Group_Filter.Group_Rarity.name]
  local stateData = filterData[View.Group_Filter.Group_State.name]
  View.Group_TopRight.Btn_Screen.Img_P:SetActive(rareData ~= nil and rareData.count ~= 0 or stateData ~= nil and stateData.count ~= 0)
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
  DataModel.ArmList = {}
  DataModel.AllArmList = {}
  DataModel.NowShowList = {}
  DataModel.Element = {}
  local armList = PlayerData:GetFactoryData(80900009).armamentList
  for i, v in ipairs(armList) do
    local row = {}
    local ca = PlayerData:GetFactoryData(v.id)
    row.quality = ca.quality
    row.qualityIndex = DataModel.QualityCfg[ca.quality].qualityIndex
    row.typeWeapon = ca.typeWeapon
    row.id = v.id
    row.name = ca.name
    row.icon = ca.imagePath
    row.listIndex = i
    row.server = PlayerData:GetArmamentById(v.id)
    row.sortIndex = 0
    if 0 < table.count(row.server) then
      row.sortIndex = 1
      DataModel.UnlockCount = DataModel.UnlockCount + 1
    end
    table.insert(DataModel.AllArmList, row)
    DataModel.TotalCount = DataModel.TotalCount + 1
    if DataModel.ArmList[row.typeWeapon] == nil then
      DataModel.ArmList[row.typeWeapon] = {}
    end
    table.insert(DataModel.ArmList[row.typeWeapon], row)
  end
  local enumArmList = PlayerData:GetFactoryData(99900017).trainWeaponTypeList
  DataModel.EnumArmIndex = {}
  DataModel.EnumArmIndex[1] = DataModel.AllArmList
  DataModel.EnumArmTypeList = {}
  table.insert(DataModel.EnumArmTypeList, {
    id = "",
    typeName = GetText(80607338),
    icon = "UI/Book/Enemy_Illustration/Allicon_Enemy",
    index = 1
  })
  for i = 1, table.count(enumArmList) do
    local row = {}
    local ca = PlayerData:GetFactoryData(enumArmList[i].id)
    row.index = i + 1
    row.icon = ca.icon
    row.typeName = ca.tagName
    row.id = ca.id
    DataModel.EnumArmIndex[row.index] = DataModel.ArmList[ca.id]
    table.insert(DataModel.EnumArmTypeList, row)
  end
  DataModel.RightIndex = 1
  DataModel.SortStateBtn = nil
  DataModel.SortStateIndex = 0
  DataModel.isFirst = true
  Controller:RefreshRightData()
  DataModel.SortState.index = 1
  DataModel.SortState.currentDown = true
  Controller:Reset(View.Group_TopRight.Btn_Acquiesce)
  Controller:RefreshData()
  View.Group_TopRightTxt.Txt_Num:SetText(DataModel.UnlockCount .. "/" .. DataModel.TotalCount)
end

function Controller:Filter()
  local list = {}
  local rareData = filterData[View.Group_Filter.Group_Rarity.name]
  local stateData = filterData[View.Group_Filter.Group_State.name]
  if DataModel.EnumArmIndex[DataModel.RightIndex] == nil then
    DataModel.NowShowList = {}
  else
    for i, data in ipairs(DataModel.EnumArmIndex[DataModel.RightIndex]) do
      if IsMeetFilter(rareData, data.qualityIndex) and IsMeetFilter(stateData, data.sortIndex + 1) then
        table.insert(list, data)
      end
    end
    DataModel.NowShowList = list
  end
end

function Controller:RefreshRightData()
  if DataModel.isFirst then
    View.Group_Card.NewScrollGrid_ArmamentCard.grid.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
      View.Group_RightList.NewScrollGrid_RightList.grid.self:SetDataCount(table.count(DataModel.EnumArmTypeList))
      View.Group_RightList.NewScrollGrid_RightList.grid.self:RefreshAllElement()
      View.Group_RightList.NewScrollGrid_RightList.grid.self:MoveToTop()
    end))
  else
    View.Group_RightList.NewScrollGrid_RightList.grid.self:SetDataCount(table.count(DataModel.EnumArmTypeList))
    View.Group_RightList.NewScrollGrid_RightList.grid.self:RefreshAllElement()
  end
end

function Controller:RefreshData()
  Controller:Filter()
  Controller:SortRefreshData()
  Controller:ClearTweens()
  DataModel.Element = {}
  if DataModel.isFirst then
    View.Group_Card.NewScrollGrid_ArmamentCard.grid.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
      View.Group_Card.NewScrollGrid_ArmamentCard.grid.self:SetDataCount(table.count(DataModel.NowShowList))
      View.Group_Card.NewScrollGrid_ArmamentCard.grid.self:RefreshAllElement()
      View.Group_Card.NewScrollGrid_ArmamentCard.grid.self:MoveToTop()
    end))
    DataModel.isFirst = false
  else
    View.Group_Card.NewScrollGrid_ArmamentCard.grid.self:SetDataCount(table.count(DataModel.NowShowList))
    View.Group_Card.NewScrollGrid_ArmamentCard.grid.self:RefreshAllElement()
    View.Group_Card.NewScrollGrid_ArmamentCard.grid.self:MoveToTop()
  end
end

function Controller:ChooseRightIndex(index)
  if index and index == DataModel.RightIndex then
    return
  end
  if View.Group_RightList.NewScrollGrid_RightList.grid[DataModel.RightIndex] then
    local old_element = View.Group_RightList.NewScrollGrid_RightList.grid[DataModel.RightIndex]
    old_element.Btn_ArmamentType.Img_UnSelected.Img_Selected:SetActive(false)
  end
  DataModel.RightIndex = index
  local element = View.Group_RightList.NewScrollGrid_RightList.grid[index]
  element.Btn_ArmamentType.Img_UnSelected.Img_Selected:SetActive(true)
  Controller:RefreshRightData()
  Controller:RefreshData()
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
  if DataModel.ArmamentFilter == nil then
    DataModel.ArmamentFilter = {}
  end
  if DataModel.ArmamentFilter[Type.name] == nil then
    DataModel.ArmamentFilter[Type.name] = {}
    DataModel.ArmamentFilter[Type.name].index = {}
  end
  DataModel.ArmamentFilter[Type.name].btn = btn
  DataModel.ArmamentFilter[Type.name].type = Type
  if next(data) == nil or name == btn.name then
    DataModel.ArmamentFilter[Type.name].index = {}
    InitFilterRolesData(Type)
    return
  else
    if data[name] then
      data[name] = nil
    end
    if data[btn.name] == nil then
      data[btn.name] = enumIndex
      DataModel.ArmamentFilter[Type.name].index[btn.name] = enumIndex
      data.count = data.count + 1
      if data.count == length then
        InitFilterRolesData(Type)
        return
      end
    else
      data[btn.name] = nil
      DataModel.ArmamentFilter[Type.name].index[btn.name] = nil
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
  element.Group_Unlocked.Img_Icon:SetSprite(PlayerData:GetFactoryData(row.typeWeapon).icon)
  element.Group_Unlocked.Img_Icon:SetColor(DataModel.QualityCfg[row.quality].iconColor)
  element.Group_Unlocked.Img_Armament:SetSprite(row.icon)
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
  element.Img_UnSelected.Img_TypeIcon:SetSprite(row.icon)
  element.Img_UnSelected.Txt_TypeName:SetText(row.typeName)
  element.Img_UnSelected.Img_Selected:SetActive(false)
  element.Img_UnSelected:SetActive(true)
  if DataModel.RightIndex == index then
    element.Img_UnSelected.Img_Selected:SetActive(true)
  end
end

function Controller:ClickArmament(index)
  local row = DataModel.NowShowList[index]
  local params = {
    id = row.id,
    weaponUid = nil,
    isBook = true
  }
  if row.server.read and row.server.read == 0 then
    Net:SendProto("main.read", function(json)
      PlayerData:GetArmamentById(row.id).read = 1
      row.server.read = 1
      local element = DataModel.Element[index]
      element.Btn_Card.Img_New:SetActive(false)
      UIManager:Open("UI/Trainfactory/Weapon/Group_TrainWeaponItem", Json.encode(params))
      return
    end, tostring(row.id), "battery")
  end
  UIManager:Open("UI/Trainfactory/Weapon/Group_TrainWeaponItem", Json.encode(params))
end

function Controller:ClearTweens()
  for i, v in pairs(DataModel.Tweens) do
    DOTweenTools.KillTween(v)
  end
  DataModel.Tweens = {}
end

return Controller
