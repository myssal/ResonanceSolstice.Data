local View = require("UIRoleHire/UIRoleHireView")
local DataModel = require("UIRoleHire/UIRoleHireDataModel")
local RogueController = require("UICubeRogueMain/UICubeRoguewMainController")
local currentBtn

local function BtnSort(btn, isIncr, isInit)
  PlayerData.CubeCharacterSort = btn
  PlayerData.CubeCharacterSortName = btn.self.name
  local pluckPath = DataModel.pluckPath or {}
  View.ScrollGrid_Middle.self:SetActive(false)
  if PlayerData.CubeCharacterSort == View.Group_TopRight.Btn_Level then
    pluckPath = {
      "lv",
      "qualityInt",
      "awake_lv",
      "resonance_lv",
      "obtain_time",
      "id"
    }
  elseif PlayerData.CubeCharacterSort == View.Group_TopRight.Btn_Rarity then
    pluckPath = {
      "qualityInt",
      "lv",
      "awake_lv",
      "resonance_lv",
      "obtain_time",
      "id"
    }
  elseif PlayerData.CubeCharacterSort == View.Group_TopRight.Btn_Time then
    pluckPath = {
      "obtain_time",
      "lv",
      "qualityInt",
      "awake_lv",
      "resonance_lv",
      "id"
    }
  end
  DataModel.SortType.pluckList = pluckPath
  DataModel.SortType.isIncr = isIncr
  DataModel.Roles = PlayerData:SortRole(DataModel.Roles, pluckPath, isIncr)
  if PlayerData.CubeCharacterFilter ~= nil and isInit == true then
    return
  end
  View.ScrollGrid_Middle.self:SetActive(true)
  View.ScrollGrid_Middle.grid.self:SetDataCount(#DataModel.Roles)
  View.ScrollGrid_Middle.grid.self:RefreshAllElement()
  View.ScrollGrid_Middle.grid.self:MoveToTop()
end

local BtnController = {
  _resetActive = function(self, btn)
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
  end,
  _init = function(self, btn)
    btn.Img_DeP:SetActive(true)
    btn.Img_DeN:SetActive(false)
    btn.Img_AP:SetActive(false)
    btn.Img_AN:SetActive(false)
    if PlayerData.CubeCharacterSortAn and PlayerData.CubeCharacterSortAn == true then
      btn.Img_DeP:SetActive(false)
      btn.Img_DeN:SetActive(false)
      btn.Img_AP:SetActive(true)
      btn.Img_AN:SetActive(false)
      BtnSort(btn, true, true)
    else
      BtnSort(btn, false, true)
    end
  end,
  _revert = function(self, btn)
    if btn.Img_DeP.gameObject.activeInHierarchy then
      btn.Img_DeP:SetActive(false)
      btn.Img_DeN:SetActive(false)
      btn.Img_AP:SetActive(true)
      btn.Img_AN:SetActive(false)
      PlayerData.CubeCharacterSortAn = true
      BtnSort(btn, true)
    elseif btn.Img_AP.gameObject.activeInHierarchy then
      btn.Img_DeP:SetActive(true)
      btn.Img_DeN:SetActive(false)
      btn.Img_AP:SetActive(false)
      btn.Img_AN:SetActive(false)
      PlayerData.CubeCharacterSortAn = false
      BtnSort(btn, false)
    end
  end,
  _deactivate = function(self, btn)
    if btn.Img_DeP.gameObject.activeInHierarchy then
      btn.Img_DeP:SetActive(false)
      btn.Img_DeN:SetActive(true)
    elseif btn.Img_AP.gameObject.activeInHierarchy then
      btn.Img_AP:SetActive(false)
      btn.Img_AN:SetActive(true)
    end
  end,
  _activate = function(self, btn)
    if btn.Img_AN.gameObject.activeInHierarchy then
      btn.Img_AP:SetActive(true)
      btn.Img_AN:SetActive(false)
      PlayerData.CubeCharacterSortAn = true
      BtnSort(btn, true)
    elseif btn.Img_DeN.gameObject.activeInHierarchy then
      btn.Img_DeP:SetActive(true)
      btn.Img_DeN:SetActive(false)
      PlayerData.CubeCharacterSortAn = false
      BtnSort(btn, false)
    end
  end,
  Reset = function(self, btn)
    local now_btn = btn
    for key, value in pairs(View.Group_TopRight) do
      if key == "self" or key == "Btn_Screen" then
      else
        if PlayerData.CubeCharacterSortName and value.self.name == PlayerData.CubeCharacterSortName then
          PlayerData.CubeCharacterSort = value
          now_btn = value
        end
        self:_resetActive(value)
        self:_deactivate(value)
      end
    end
    self:_resetActive(now_btn)
    BtnSort(now_btn, false, true)
    currentBtn = now_btn
  end
}
local module = {
  Init = function(self, btn)
    BtnController:_init(btn)
  end,
  Click = function(self, btn)
    PlayerData.CubeCharacterSort = btn
    if currentBtn == btn then
      BtnController:_revert(btn)
      return
    end
    BtnController:_deactivate(currentBtn)
    currentBtn = btn
    BtnController:_activate(currentBtn)
  end,
  Serialize = function(self)
    local function __bntnToStatus(btn)
      if btn.Img_DeP.gameObject.activeInHierarchy then
        return "Img_DeP"
      end
      if btn.Img_DeN.gameObject.activeInHierarchy then
        return "Img_DeN"
      end
      if btn.Img_AP.gameObject.activeInHierarchy then
        return "Img_AP"
      end
      if btn.Img_AN.gameObject.activeInHierarchy then
        return "Img_AN"
      end
    end
    
    local status = {}
    status.level = __bntnToStatus(View.Group_TopRight.Btn_Level)
    status.rarity = __bntnToStatus(View.Group_TopRight.Btn_Rarity)
    status.time = __bntnToStatus(View.Group_TopRight.Btn_Time)
    return status
  end,
  Deserialize = function(self)
    BtnController:Reset(PlayerData.CubeCharacterSort == nil and View.Group_TopRight.Btn_Level or PlayerData.CubeCharacterSort)
  end
}
local filterData = {}

local function ControllerFilterBtn()
  local campData = filterData[View.Screen_Chapter_New.Group_Group.name]
  local specialData = filterData[View.Screen_Chapter_New.Group_Tag.name]
  local qualityData = filterData[View.Screen_Chapter_New.Group_Rarity.name]
  View.Group_TopRight.Btn_Screen.Img_P:SetActive(campData ~= nil and campData.count ~= 0 or qualityData ~= nil and qualityData.count ~= 0 or specialData ~= nil and specialData.list ~= nil and (not specialData.list or table.count(specialData.list) ~= 0))
end

local function SetFilterView(Type)
  local data = filterData[Type.name]
  for k, v in pairs(Type) do
    if k == "self" or k == "Txt_" or k == "Img_Bg" then
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

local function IsMeetFilterSpecial(chooseList, roleData)
  if chooseList == nil or table.count(chooseList) == 0 then
    return true
  end
  for k, v in pairs(chooseList) do
    for c, d in pairs(roleData.careerList) do
      if k == d.des then
        return true
      end
    end
    for m, n in pairs(roleData.classifyList) do
      if k == n.des then
        return true
      end
    end
  end
  return false
end

function module.Filter()
  DataModel.SetRoleData()
  View.ScrollGrid_Middle.self:SetActive(false)
  local roleData = {}
  local campData = filterData[View.Screen_Chapter_New.Group_Group.name] or {}
  local qualityData = filterData[View.Screen_Chapter_New.Group_Rarity.name] or {}
  local specialData = filterData[View.Screen_Chapter_New.Group_Tag.name] or {}
  for k, v in pairs(DataModel.Roles) do
    local role = PlayerData:GetFactoryData(v, "UnitFactory")
    if IsMeetFilter(campData, PlayerData:SearchRoleCampInt(role.sideId)) and IsMeetFilter(qualityData, role[qualityData.property]) and IsMeetFilterSpecial(specialData.list, role) then
      table.insert(roleData, v)
    end
  end
  local count = #roleData
  local allCount = #DataModel.Roles
  if count == allCount then
    BtnSort(View.Group_TopRight.Btn_Level, DataModel.SortType.isIncr)
  elseif count < allCount then
    DataModel.Roles = roleData
    BtnSort(PlayerData.CubeCharacterSort == nil and View.Group_TopRight.Btn_Level or PlayerData.CubeCharacterSort, DataModel.SortType.isIncr)
  end
end

local function InitFilterRolesData(Type, property)
  local name = Type.name
  if type(filterData[name]) == "nil" then
    local length = 0
    local config = {}
    for k, v in pairs(Type) do
      if PlayerData.CubeCharacterFilter and PlayerData.CubeCharacterFilter[name] then
        PlayerData.CubeCharacterFilter[name].type[k] = v
      end
      if k ~= "self" and k ~= "Txt_" and k ~= "Btn_All" and k ~= "Img_Bg" then
        if name == "Group_Group" then
          v.self:SetActive(false)
        end
        length = length + 1
      end
    end
    if name == "Group_Group" then
      length = 0
      config = PlayerData:GetRoleCampFilterList()
      for k, v in ipairs(config) do
        local btn = "Btn_C0" .. k
        if Type[btn] then
          Type[btn].self:SetActive(true)
          Type[btn].Txt_:SetText(v.sideName)
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
  if Type.name == "Group_Tag" then
    if PlayerData.CubeCharacterFilter and PlayerData.CubeCharacterFilter.Group_Tag and PlayerData.CubeCharacterFilter.Group_Tag.index then
      data.list = PlayerData.CubeCharacterFilter.Group_Tag.list
    end
    module.RefreshFilterSpecialTagList()
  end
  ControllerFilterBtn()
end

function module.InitScreenBtn(Type, btn, enumIndex)
  local name = Type.Btn_All.name
  if btn == nil then
    btn = Type.Btn_All
  end
  local data = filterData[Type.name] or {}
  local length = data.length
  if PlayerData.CubeCharacterFilter == nil then
    PlayerData.CubeCharacterFilter = {}
  end
  if PlayerData.CubeCharacterFilter[Type.name] == nil then
    PlayerData.CubeCharacterFilter[Type.name] = {}
    PlayerData.CubeCharacterFilter[Type.name].index = {}
  end
  PlayerData.CubeCharacterFilter[Type.name].btn = btn
  PlayerData.CubeCharacterFilter[Type.name].type = Type
  if next(data) == nil or name == btn then
    PlayerData.CubeCharacterFilter[Type.name].index = {}
    if PlayerData.CubeCharacterFilter and PlayerData.CubeCharacterFilter.Group_Tag and PlayerData.CubeCharacterFilter.Group_Tag.index then
      data.list = PlayerData.CubeCharacterFilter.Group_Tag.list
    end
    InitFilterRolesData(Type)
    return
  else
    if data[name] then
      data[name] = nil
    end
    if data[btn] == nil then
      data[btn] = enumIndex
      PlayerData.CubeCharacterFilter[Type.name].index[btn] = enumIndex
      data.count = data.count + 1
      if data.count == length then
        InitFilterRolesData(Type)
        return
      end
    else
      data[btn] = nil
      PlayerData.CubeCharacterFilter[Type.name].index[btn] = nil
      data.count = data.count - 1
      if data.count == 0 then
        InitFilterRolesData(Type)
        return
      end
    end
  end
  filterData[Type.name] = data
  SetFilterView(Type)
  if Type.name == "Group_Tag" then
    module.RefreshFilterSpecialTagList(btn.name, enumIndex)
  end
end

function module.ScreenBtn(Type, btn, enumIndex)
  local name = Type.Btn_All.name
  if btn == nil then
    btn = Type.Btn_All
  end
  local data = filterData[Type.name] or {}
  local length = data.length
  if PlayerData.CubeCharacterFilter == nil then
    PlayerData.CubeCharacterFilter = {}
  end
  if PlayerData.CubeCharacterFilter[Type.name] == nil then
    PlayerData.CubeCharacterFilter[Type.name] = {}
    PlayerData.CubeCharacterFilter[Type.name].index = {}
    PlayerData.CubeCharacterFilter[Type.name].list = {}
  end
  PlayerData.CubeCharacterFilter[Type.name].btn = btn
  PlayerData.CubeCharacterFilter[Type.name].type = Type
  if next(data) == nil or name == btn.name then
    PlayerData.CubeCharacterFilter[Type.name].index = {}
    if PlayerData.CubeCharacterFilter and PlayerData.CubeCharacterFilter.Group_Tag and PlayerData.CubeCharacterFilter.Group_Tag.index then
      data.list = PlayerData.CubeCharacterFilter.Group_Tag.list
    end
    InitFilterRolesData(Type)
    return
  else
    if data[name] then
      data[name] = nil
    end
    if data[btn.name] == nil then
      data[btn.name] = enumIndex
      PlayerData.CubeCharacterFilter[Type.name].index[btn.name] = enumIndex
      data.count = data.count + 1
      if data.count == length then
        InitFilterRolesData(Type)
        return
      end
    else
      data[btn.name] = nil
      PlayerData.CubeCharacterFilter[Type.name].index[btn.name] = nil
      data.count = data.count - 1
      if data.count == 0 then
        InitFilterRolesData(Type)
        return
      end
    end
  end
  filterData[Type.name] = data
  SetFilterView(Type)
  if Type.name == "Group_Tag" then
    module.RefreshFilterSpecialTagList(btn.name, enumIndex)
  end
end

function module.RefreshCharacterFilter()
  if PlayerData.CubeCharacterFilter ~= nil then
    for k, v in pairs(PlayerData.CubeCharacterFilter) do
      for c, d in pairs(v.index) do
        module.InitScreenBtn(v.type, c, d)
      end
    end
    ControllerFilterBtn()
    module.Filter()
  end
end

function module.OpenInitFilterSpeacialTagList(...)
  if PlayerData.CubeCharacterFilter and PlayerData.CubeCharacterFilter.Group_Tag and PlayerData.CubeCharacterFilter.Group_Tag.index then
    for k, v in pairs(PlayerData.CubeCharacterFilter.Group_Tag.index) do
      module.RefreshFilterSpecialTagList(k, v)
    end
  end
end

function module.RefreshFilterSpecialTagList(name, enumIndex)
  DataModel.CurrentSpecialList = DataModel.SpecialList.Btn_All
  if name then
    local data = filterData.Group_Tag or {}
    local length = data.length
    if length == table.count(PlayerData.CubeCharacterFilter.Group_Tag.index) then
      PlayerData.CubeCharacterFilter.Group_Tag.index = {}
      PlayerData.CubeCharacterFilter.Group_Tag.index[name] = enumIndex
    end
    DataModel.CurrentSpecialList = {}
    for k, v in pairs(PlayerData.CubeCharacterFilter.Group_Tag.index) do
      local row = DataModel.SpecialList[k]
      for c, d in pairs(row) do
        table.insert(DataModel.CurrentSpecialList, d)
      end
    end
  end
  View.Screen_Chapter_New.Group_Tag.Img_Bg.ScrollGrid_Tag.grid.self:SetDataCount(table.count(DataModel.CurrentSpecialList))
  View.Screen_Chapter_New.Group_Tag.Img_Bg.ScrollGrid_Tag.grid.self:RefreshAllElement()
  View.Screen_Chapter_New.Group_Tag.Img_Bg.ScrollGrid_Tag.grid.self:MoveToTop()
end

function module.Open_Screen_Chapter(isOpen)
  View.Screen_Chapter_New.self:SetActive(isOpen)
  if isOpen then
    SetFilterView(View.Screen_Chapter_New.Group_Group)
    SetFilterView(View.Screen_Chapter_New.Group_Rarity)
    SetFilterView(View.Screen_Chapter_New.Group_Tag)
    module.OpenInitFilterSpeacialTagList()
  else
    ControllerFilterBtn()
  end
end

function module.ClickSpecialTitle(index)
  if PlayerData.CubeCharacterFilter == nil then
    PlayerData.CubeCharacterFilter = {}
  end
  if PlayerData.CubeCharacterFilter.Group_Tag == nil then
    PlayerData.CubeCharacterFilter.Group_Tag = {}
    PlayerData.CubeCharacterFilter.Group_Tag.index = {}
    PlayerData.CubeCharacterFilter.Group_Tag.btn = View.Screen_Chapter_New.Group_Tag.Btn_All
    PlayerData.CubeCharacterFilter.Group_Tag.type = View.Screen_Chapter_New.Group_Tag
    PlayerData.CubeCharacterFilter.Group_Tag.list = {}
  end
  local row = DataModel.CurrentSpecialList[index]
  local element = View.Screen_Chapter_New.Group_Tag.Img_Bg.ScrollGrid_Tag.grid.self:GetElementByIndex(index - 1)
  if PlayerData.CubeCharacterFilter.Group_Tag.list[row.id] == nil then
    PlayerData.CubeCharacterFilter.Group_Tag.list[row.id] = row.id
    element.Btn_Tag.Img_UnSelect:SetActive(false)
    element.Btn_Tag.Img_Select:SetActive(true)
  else
    PlayerData.CubeCharacterFilter.Group_Tag.list[row.id] = nil
    element.Btn_Tag.Img_UnSelect:SetActive(true)
    element.Btn_Tag.Img_Select:SetActive(false)
  end
  filterData.Group_Tag.list = PlayerData.CubeCharacterFilter.Group_Tag.list
end

function module.InitSpecialTitle(name, index)
  local Group_Tag = View.Screen_Chapter_New.Group_Tag
  local length = 0
  for k, v in pairs(Group_Tag) do
    if k ~= "self" and k ~= "Txt_" and k ~= "Btn_All" and k ~= "Img_Bg" then
      local btn_Name = "Btn_" .. name
      v.Img_Select:SetActive(false)
      if k == btn_Name then
        v.Img_Select:SetActive(true)
      end
      length = length + 1
    end
  end
  module.ClickSpecialTitle(index)
end

function module.InitFilter()
  filterData = {}
  InitFilterRolesData(View.Screen_Chapter_New.Group_Group, "campInt")
  InitFilterRolesData(View.Screen_Chapter_New.Group_Rarity, "qualityInt")
  InitFilterRolesData(View.Screen_Chapter_New.Group_Tag, "specialInt")
end

function module.SetSpeacialElement(element, elementIndex)
  local row = DataModel.CurrentSpecialList[elementIndex]
  element.Btn_Tag.Img_UnSelect:SetActive(not PlayerData.CubeCharacterFilter or not PlayerData.CubeCharacterFilter.Group_Tag or not PlayerData.CubeCharacterFilter.Group_Tag.list[row.id])
  element.Btn_Tag.Img_Select:SetActive(PlayerData.CubeCharacterFilter and PlayerData.CubeCharacterFilter.Group_Tag and PlayerData.CubeCharacterFilter.Group_Tag.list[row.id])
  element.Btn_Tag.Img_Icon:SetSprite(row.icon)
  element.Btn_Tag.Txt_Name:SetText(row.name)
  element.Btn_Tag:SetClickParam(elementIndex)
end

function module.ShowCoin()
  local cfg = GetCA(89400002, "CubeRogueFactory")
  local coinCfg = GetCA(cfg.coinId, "ItemFactory")
  View.Group_Coin.Img_Icon:SetSprite(coinCfg.iconPath)
  View.Group_Coin.Txt_Num:SetText(PlayerData:GetGoodsById(cfg.coinId).num)
  View.Img_Title:SetSprite(GetResPath(88300180))
  View.Img_Title:SetNativeSize()
end

function module.SelectRole(id)
  if not table.list_remove(DataModel.SelectList, id) then
    table.insert(DataModel.SelectList, id)
  end
  DataModel.onlyRefreshSelect = true
  View.ScrollGrid_Middle.grid.self:RefreshAllElement()
  DataModel.onlyRefreshSelect = nil
  module.RefreshHireBtn()
end

function module.RefreshHireBtn()
  local selCount = #DataModel.SelectList
  View.Btn_Hire.Img_Active:SetActive(0 < selCount)
  local cost = 0
  for k, v in pairs(DataModel.SelectList) do
    local _c = PlayerData:GetFactoryData(v)
    local costOne = 0
    if _c.quality == "FiveStar" then
      costOne = DataModel.Cfg.recruitPriceSSRList[1].num
    elseif _c.quality == "fourStar" then
      costOne = DataModel.Cfg.recruitPriceSRList[1].num
    elseif _c.quality == "threeStar" then
      costOne = DataModel.Cfg.recruitPriceRList[1].num
    elseif _c.quality == "twoStar" or _c.quality == "oneStar" then
      costOne = DataModel.Cfg.recruitPriceNList[1].num
    end
    cost = cost + costOne
  end
  DataModel.CostId = DataModel.Cfg.recruitPriceSSRList[1].id
  View.Group_Price.Img_Icon:SetSprite(GetCA(DataModel.CostId, "ItemFactory").iconPath)
  DataModel.NeedCoinNum = cost
  View.Group_Price.Txt_Num:SetText(string.format("%d", DataModel.NeedCoinNum))
  DataModel.IsEnough = DataModel.NeedCoinNum <= PlayerData:GetGoodsById(DataModel.CostId).num
  View.Group_Price.Txt_Num:SetColor(DataModel.IsEnough and "#FFFFFF" or "#CD5454")
end

function module.OnHireClick()
  if #DataModel.SelectList == 0 then
    return
  end
  if not DataModel.IsEnough then
    return
  end
  local hireList = ""
  for k, v in pairs(DataModel.SelectList) do
    hireList = hireList .. v
    if k ~= #DataModel.SelectList then
      hireList = hireList .. ","
    end
  end
  Net:SendProto("cube.chose_role", function()
    module.OnHireSuccess()
  end, hireList)
end

function module.OnHireSuccess()
  View.Group_SuccessTip:SetActive(true)
  View.Group_SuccessTip.Img_Title:SetSprite(GetResPath(88300180))
  View.Group_SuccessTip.Img_Title:SetNativeSize()
  DataModel.newRoles = DataModel.SelectList
  local num = #DataModel.SelectList
  if num <= 5 then
    View.Group_SuccessTip.ScrollGrid_Role.grid.self:SetStartCorner("Center")
  else
    View.Group_SuccessTip.ScrollGrid_Role.grid.self:SetStartCorner("Left")
  end
  View.Group_SuccessTip.ScrollGrid_Role.grid.self:SetDataCount(num)
  View.Group_SuccessTip.ScrollGrid_Role.grid.self:RefreshAllElement()
  DataModel.OnHireSuccess()
  PlayerData:RefreshUseItems({
    [DataModel.CostId] = DataModel.NeedCoinNum
  })
  module:Init(PlayerData.CubeCharacterSort == nil and View.Group_TopRight.Btn_Level or PlayerData.CubeCharacterSort)
  module.RefreshCharacterFilter()
  module.ShowCoin()
  module.RefreshHireBtn()
  RogueController.ShowCoin()
end

local Enum_QualityTranslate = {
  [1] = "N",
  [2] = "N",
  [3] = "R",
  [4] = "SR",
  [5] = "SSR"
}

function module.SetElement(element, data)
  if element.Img_Selected then
    element.Img_Selected:SetActive(table.contains(DataModel.SelectList, tonumber(data.id)))
  end
  if DataModel.onlyRefreshSelect then
    return
  end
  local id = tostring(data.id)
  element.Group_LV.Txt_Num:SetText(PlayerData.GetCubeRoleLv() + RogueController:GetRoleExLv(id))
  element.Group_Break.StaticGrid_BK.grid.self:RefreshAllElement()
  local portraitId = PlayerData:GetRoleById(id).current_skin[1]
  local ca = PlayerData:GetFactoryData(id)
  local portrailData = PlayerData:GetFactoryData(portraitId, "UnitViewFactory")
  element.Img_Mask.Img_Character:SetSprite(portrailData.roleListResUrl)
  if PlayerData:GetRoleById(id).current_skin[2] == 1 and ca.isSpine2 == 1 then
    element.Img_Mask.Img_Character:SetSprite(portrailData.State2RoleListRes)
  end
  element.Img_Mask.Img_Character:SetActive(true)
  element.Txt_Name:SetText(ca.name)
  local quality1 = "UI/CubeRogue/QualityBG/Character/Big/" .. Enum_QualityTranslate[ca.qualityInt + 1]
  element.Img_Quality:SetSprite(quality1)
  local quality2 = quality1 .. "_Mask"
  element.Img_Mask:SetSprite(quality2)
end

return module
