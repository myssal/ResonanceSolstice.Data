local View = require("UIDepot/UIDepotView")
local DataModel = require("UIDepot/UIDepotDataModel")
local CommonItem = require("Common/BtnItem")
local Controller = require("UIDepot/UIDepotController")

local function SetDepotFilter(index, value)
  if PlayerData.DepotFilter == nil then
    PlayerData.DepotFilter = {}
  end
  PlayerData.DepotFilter[index] = value
end

local StateEnum = {
  [0] = "Btn_All",
  "Btn_S01",
  "Btn_S02"
}

local function switchType(index)
  local Group_Type = View.Group_Filter.Group_Type
  if index ~= 0 or not DataModel.FilterType[index] then
    DataModel.FilterType[index] = not DataModel.FilterType[index]
  end
  local len = #DataModel.FilterType
  if DataModel.FilterType[0] then
    for i = 1, len do
      DataModel.FilterType[i] = false
    end
  else
    local isAll = true
    local isAntiAll = true
    for i = 1, len do
      isAll = isAll and DataModel.FilterType[i]
      isAntiAll = isAntiAll and not DataModel.FilterType[i]
    end
    if isAll or isAntiAll then
      DataModel.FilterType[0] = true
      for i = 1, len do
        DataModel.FilterType[i] = false
      end
    else
      DataModel.FilterType[0] = false
    end
  end
  for i = 0, len do
    if i == 0 then
      Group_Type.Btn_All.Img_Select:SetActive(DataModel.FilterType[i])
    else
      Group_Type.StaticGrid_Type.grid[i].Btn_Type.Img_Select:SetActive(DataModel.FilterType[i])
    end
  end
  SetDepotFilter(1, DataModel.FilterType)
end

local function switchRarity(index)
  local Group_Rarity = View.Group_Filter.Group_Rarity
  if index ~= 0 or not DataModel.FilterRarity[index] then
    DataModel.FilterRarity[index] = not DataModel.FilterRarity[index]
  end
  local len = #DataModel.FilterRarity
  if DataModel.FilterRarity[0] then
    for i = 1, len do
      DataModel.FilterRarity[i] = false
    end
  else
    local isAll = true
    local isAntiAll = true
    for i = 1, len do
      isAll = isAll and DataModel.FilterRarity[i]
      isAntiAll = isAntiAll and not DataModel.FilterRarity[i]
    end
    if isAll or isAntiAll then
      DataModel.FilterRarity[0] = true
      for i = 1, len do
        DataModel.FilterRarity[i] = false
      end
    else
      DataModel.FilterRarity[0] = false
    end
  end
  for i = 0, len do
    if i == 0 then
      Group_Rarity.Btn_All.Img_Select:SetActive(DataModel.FilterRarity[i])
    else
      Group_Rarity.StaticGrid_Rarity.grid[i].Btn_Rarity.Img_Select:SetActive(DataModel.FilterRarity[i])
    end
  end
  SetDepotFilter(2, DataModel.FilterRarity)
end

local function switchState(index)
  local Group_State = View.Group_Filter.Group_State
  if index ~= 0 or not DataModel.FilterState[index] then
    DataModel.FilterState[index] = not DataModel.FilterState[index]
  end
  local len = #DataModel.FilterState
  if DataModel.FilterState[0] then
    for i = 1, len do
      DataModel.FilterState[i] = false
    end
  else
    local isAll = true
    local isAntiAll = true
    for i = 1, len do
      isAll = isAll and DataModel.FilterState[i]
      isAntiAll = isAntiAll and not DataModel.FilterState[i]
    end
    if isAll or isAntiAll then
      DataModel.FilterState[0] = true
      for i = 1, len do
        DataModel.FilterState[i] = false
      end
    else
      DataModel.FilterState[0] = false
    end
  end
  for i = 0, len do
    if i == 0 then
      Group_State.Btn_All.Img_Select:SetActive(DataModel.FilterState[i])
    else
      Group_State[StateEnum[i]].Img_Select:SetActive(DataModel.FilterState[i])
    end
  end
  SetDepotFilter(3, DataModel.FilterState)
end

local ViewFunction = {
  Depot_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    View.self:PlayAnim("Out")
    UIManager:GoBack()
  end,
  Depot_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    View.self:PlayAnim("Out")
    UIManager:GoBack()
  end,
  Depot_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Depot_Group_Tab_Btn_TabEquipment_Click = function(btn, str)
    Controller:ChangeTab(EnumDefine.Depot.Equipment)
    Controller.OpenSale(false)
  end,
  Depot_Group_Tab_Btn_TabItem_Click = function(btn, str)
    Controller:ChangeTab(EnumDefine.Depot.Item)
  end,
  Depot_Group_Tab_Btn_TabMaterial_Click = function(btn, str)
    Controller:ChangeTab(EnumDefine.Depot.Material)
  end,
  Depot_Group_TopRight_Btn_Rarity_Click = function(btn, str)
    Controller:FilterRefresh(EnumDefine.Sort.Quality)
    Controller:ChangeTab(EnumDefine.Depot.Equipment, true)
  end,
  Depot_Group_TopRight_Btn_Screen_Click = function(btn, str)
    UIManager:LoadSplitPrefab(View, "UI/Depot/Depot", "Group_Filter")
    View.Group_Filter.self:SetActive(true)
  end,
  Depot_Group_TopRight_Btn_Time_Click = function(btn, str)
    Controller:FilterRefresh(EnumDefine.Sort.Time)
    Controller:ChangeTab(EnumDefine.Depot.Equipment, true)
  end,
  Depot_Group_TopRight_Btn_Level_Click = function(btn, str)
    Controller:FilterRefresh(EnumDefine.Sort.Level)
    Controller:ChangeTab(EnumDefine.Depot.Equipment, true)
  end,
  Depot_Group_Equipment_Btn_Forge_Click = function(btn, str)
    UIManager:Open("UI/Equipment/EquipForge")
  end,
  Depot_Group_Equipment_Btn_Resolve_Click = function(btn, str)
    UIManager:Open("UI/Equipment/EquipResolve")
  end,
  Depot_Group_Other_Btn_Sale_Click = function(btn, str)
    UIManager:Open("UI/Depot/Sale", Json.encode({
      Select = DataModel.Select
    }))
  end,
  Depot_Group_Filter_Btn_BG_Click = function(btn, str)
    View.Group_Filter.self:SetActive(false)
  end,
  Depot_Group_Filter_Group_Type_Btn_All_Click = function(btn, str)
    switchType(0)
  end,
  Depot_Group_Filter_Group_Type_StaticGrid_Type_SetGrid = function(element, elementIndex)
    local index = tonumber(elementIndex)
    local data = DataModel.EquipType[index]
    element.Btn_Type.self:SetClickParam(tostring(elementIndex))
    element.Btn_Type.Txt_Name:SetText(data.name)
  end,
  Depot_Group_Filter_Group_Type_StaticGrid_Type_Group_BtnType_Btn_Type_Click = function(btn, str)
    DataModel.FilterType[0] = false
    switchType(tonumber(str))
  end,
  Depot_Group_Filter_Group_Rarity_Btn_All_Click = function(btn, str)
    switchRarity(0)
  end,
  Depot_Group_Filter_Group_Rarity_StaticGrid_Rarity_SetGrid = function(element, elementIndex)
    local index = tonumber(elementIndex)
    local Btn_Rarity = element.Btn_Rarity
    Btn_Rarity.self:SetClickParam(tostring(elementIndex))
    Btn_Rarity.Img_Name:SetSprite(UIConfig.EquipTipRarity[index])
    Btn_Rarity.Img_Name:SetActive(true)
  end,
  Depot_Group_Filter_Group_Rarity_StaticGrid_Rarity_Group_BtnRarity_Btn_Rarity_Click = function(btn, str)
    DataModel.FilterRarity[0] = false
    switchRarity(tonumber(str))
  end,
  Depot_Group_Filter_Group_State_Btn_All_Click = function(btn, str)
    switchState(0)
  end,
  Depot_Group_Filter_Group_State_Btn_S01_Click = function(btn, str)
    DataModel.FilterState[0] = false
    switchState(1)
  end,
  Depot_Group_Filter_Group_State_Btn_S02_Click = function(btn, str)
    DataModel.FilterState[0] = false
    switchState(2)
  end,
  Depot_Group_Filter_Btn_OK_Click = function(btn, str)
    View.Group_Filter.self:SetActive(false)
    Controller:Refresh(true)
    Controller:FilterButtonType()
  end,
  Depot_Group_Filter_Btn_Cancel_Click = function(btn, str)
    View.Group_Filter.self:SetActive(false)
  end,
  Depot_Group_Equipment_Group_Resolve_Btn_Cancel_Click = function(btn, str)
  end,
  Depot_Group_Equipment_Group_Resolve_Btn_Confirm_Click = function(btn, str)
  end,
  Depot_Group_Equipment_Group_Resolve_Btn_N_Click = function(btn, str)
  end,
  Depot_Group_Equipment_Group_Resolve_Btn_R_Click = function(btn, str)
  end,
  Depot_Group_Plugin_ScrollGrid_Plugin_SetGrid = function(element, elementIndex)
  end,
  Depot_Group_Plugin_ScrollGrid_Plugin_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  Depot_Group_Plugin_Btn_Resolve_Click = function(btn, str)
  end,
  Depot_Group_Plugin_Group_Resolve_Btn_Cancel_Click = function(btn, str)
  end,
  Depot_Group_Plugin_Group_Resolve_Btn_Confirm_Click = function(btn, str)
  end,
  Depot_Group_Plugin_Group_Resolve_Btn_N_Click = function(btn, str)
  end,
  Depot_Group_Plugin_Group_Resolve_Btn_R_Click = function(btn, str)
  end,
  Depot_Group_Plugin_Group_Sort_Btn_Decompose_Click = function(btn, str)
  end,
  Depot_Group_Plugin_Group_Sort_Btn_Rarity_Click = function(btn, str)
  end,
  Depot_Group_Plugin_Group_Sort_Btn_Screen_Click = function(btn, str)
  end,
  Depot_Group_Plugin_Group_Sort_Btn_Time_Click = function(btn, str)
  end,
  Depot_Group_Tab_Btn_TabPlugin_Click = function(btn, str)
  end,
  Depot_Group_Tab_Btn_Goods_Click = function(btn, str)
    Controller:ChangeTab(4)
  end,
  Depot_Btn_Talk_Click = function(btn, str)
    Controller:RandomPlayRoleSound()
  end,
  Depot_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Depot_Group_Tab_Btn_Food_Click = function(btn, str)
    Controller:ChangeTab(5)
  end,
  Depot_Group_Item_ScrollGrid_Item_SetGrid = function(element, elementIndex)
    element.Btn_Item:SetClickParam(tostring(elementIndex))
    local currData = DataModel.Now_List[elementIndex]
    CommonItem:SetItem(element, {
      id = currData.data.id,
      num = currData.num or currData.server.num
    }, EnumDefine.ItemType.Item)
    element.Img_TimeLeft:SetActive(currData.limitedData ~= nil or currData.remainTime ~= nil)
    if currData.limitedData then
      element.Img_TimeLeft.Txt_:SetText(string.format(GetText(80601882), currData.limitedData.remainDay))
    elseif currData.remainTime then
      element.Img_TimeLeft.Txt_:SetText(string.format(GetText(80601882), math.ceil(currData.remainTime / 86400)))
    end
  end,
  Depot_Group_Item_ScrollGrid_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local detailData = DataModel.Now_List[tonumber(str)]
    local id = detailData.data.id
    if DataModel.Index == EnumDefine.Depot.Keepsake then
      local params = {
        itemId = id,
        type = EnumDefine.OpenTip.Depot
      }
      CommonTips.OpenKeepsake(params)
    else
      local params = {
        itemId = id,
        type = EnumDefine.OpenTip.Depot,
        saleData = PlayerData:GetSaleItem(id, EnumDefine.Depot.Item),
        limitedTimeData = detailData.limitedData
      }
      CommonTips.OpenItem(params)
    end
  end,
  Depot_Group_Material_ScrollGrid_Material_SetGrid = function(element, elementIndex)
    element.Btn_Item:SetClickParam(tostring(elementIndex))
    local currData = DataModel.Now_List[elementIndex]
    CommonItem:SetItem(element, {
      id = currData.data.id,
      num = currData.server.num
    }, EnumDefine.ItemType.Material)
  end,
  Depot_Group_Material_ScrollGrid_Material_Group_Item_Btn_Item_Click = function(btn, str)
    local id = DataModel.Now_List[tonumber(str)].data.id
    local params = {
      itemId = id,
      type = EnumDefine.OpenTip.Depot,
      saleData = PlayerData:GetSaleItem(id, EnumDefine.Depot.Material)
    }
    CommonTips.OpenItem(params)
  end,
  Depot_Group_Goods_ScrollGrid_Goods_SetGrid = function(element, elementIndex)
    element.Btn_Item:SetClickParam(tostring(elementIndex))
    local currData = DataModel.Now_List[elementIndex]
    DataModel.goods = DataModel.goods + currData.server.num
    CommonItem:SetWarehouse(element, {
      id = currData.data.id,
      num = currData.server.num
    })
  end,
  Depot_Group_Goods_ScrollGrid_Goods_Group_Goods_Btn_Item_Click = function(btn, str)
    local idx = tonumber(str)
    local currData = DataModel.Now_List[idx]
    local id = currData.data.id
    local ca = PlayerData:GetFactoryData(id)
    CommonTips.OpenGoodsTips(id, 1, ca.mod == "\229\159\186\231\161\128\232\180\167\231\137\169", function()
      local element = View.Group_Goods.ScrollGrid_Goods.grid.self:GetElementByIndex(idx - 1)
      if element then
        CommonItem:SetWarehouse(element, {
          id = currData.data.id,
          num = currData.server.num
        })
      end
    end)
  end,
  Depot_Group_Food_ScrollGrid_Food_SetGrid = function(element, elementIndex)
    element.Btn_Item:SetClickParam(tostring(elementIndex))
    local currData = DataModel.Now_List[elementIndex]
    CommonItem:SetFridgeItems(element, {
      id = currData.data.id,
      num = currData.server.num
    })
  end,
  Depot_Group_Food_ScrollGrid_Food_Group_Item_Btn_Item_Click = function(btn, str)
    local id = DataModel.Now_List[tonumber(str)].data.id
    local params = {
      itemId = id,
      type = EnumDefine.OpenTip.Depot,
      saleData = PlayerData:GetSaleItem(id, EnumDefine.Depot.FridgeItem)
    }
    CommonTips.OpenItem(params)
  end,
  Depot_Group_Equipments_ScrollGrid_Equipment_SetGrid = function(element, elementIndex)
    element.Group_Equipment.Btn_Item:SetClickParam(elementIndex)
    local data = DataModel.Now_List[elementIndex]
    CommonItem:SetEquipment(element.Group_Equipment, data, false)
  end,
  Depot_Group_Equipments_ScrollGrid_Equipment_Group_Item_Group_Equipment_Btn_Item_Click = function(btn, str)
    local params = DataModel.Now_List[tonumber(str)]
    params.scene = 0
    CommonTips.OpenEquipment(params, params.server)
  end,
  Depot_Group_Tab_Btn_TrainWeapon_Click = function(btn, str)
    Controller:ChangeTab(EnumDefine.Depot.TrainWeapon)
  end,
  Depot_Group_TrainWeapon_ScrollGrid_TrainWeapon_SetGrid = function(element, elementIndex)
    local info = DataModel.Now_List[elementIndex]
    CommonItem:SetItem(element.Group_Item, {
      id = info.id
    })
    element.Group_Item.Btn_Item:SetClickParam(elementIndex)
    element.Group_Item.Img_Select:SetActive(false)
    element.Group_Item.Img_UseBg:SetActive(false)
    local used = DataModel.WeaponIsEquipByUid(info.uid)
    element.Group_Item.Img_Tag:SetActive(used)
    element.Group_Item.Txt_EquipmentLevel:SetText(string.format("<size=16>LV</size>%d", info.server.lv))
  end,
  Depot_Group_TrainWeapon_ScrollGrid_TrainWeapon_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local info = DataModel.Now_List[tonumber(str)]
    local data = {
      id = info.id,
      weaponUid = info.uid
    }
    UIManager:Open("UI/Trainfactory/Weapon/Group_TrainWeaponItem", Json.encode(data), function()
      View.Group_TrainWeapon.ScrollGrid_TrainWeapon.grid.self:RefreshAllElement()
    end)
  end,
  Depot_Group_TopItem_Btn_Rarity_Click = function(btn, str)
  end,
  Depot_Group_Tab_Btn_Keepsake_Click = function(btn, str)
    Controller:ChangeTab(EnumDefine.Depot.Keepsake)
  end,
  Depot_Group_Tab_Btn_WareHouse_Click = function(btn, str)
    Controller:ChangeTab(EnumDefine.Depot.WareGoods)
  end,
  Depot_Group_WareGoods_ScrollGrid_Goods_SetGrid = function(element, elementIndex)
    local info = DataModel.Now_List[elementIndex]
    CommonItem:SetItem(element, {
      id = info.id,
      num = info.server.num
    })
    element.Btn_Item:SetClickParam(info.id)
  end,
  Depot_Group_WareGoods_ScrollGrid_Goods_Group_Goods_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenGoodsTips(itemId, 2)
  end,
  Depot_Group_WareLimit_Group_City_Btn_Rarity_Click = function(btn, str)
    UIManager:LoadSplitPrefab(View, "UI/Depot/Depot", "Group_CityChose")
    View.Group_CityChose:SetActive(true)
    DataModel.lastSelectDic = Clone(DataModel.selectStationDic)
    View.Group_CityChose.Group_Type.Btn_All.Img_Select:SetActive(next(DataModel.lastSelectDic) == nil)
    View.Group_CityChose.Group_Type.ScrollGrid_City.grid.self:SetDataCount(#DataModel.wareHouseStationList)
    View.Group_CityChose.Group_Type.ScrollGrid_City.grid.self:RefreshAllElement()
  end,
  Depot_Group_CityChose_Btn_BG_Click = function(btn, str)
  end,
  Depot_Group_CityChose_Group_Type_Btn_All_Click = function(btn, str)
    DataModel.lastSelectDic = {}
    View.Group_CityChose.Group_Type.Btn_All.Img_Select:SetActive(true)
    View.Group_CityChose.Group_Type.ScrollGrid_City.grid.self:RefreshAllElement()
  end,
  Depot_Group_CityChose_Group_Type_ScrollGrid_City_SetGrid = function(element, elementIndex)
    local stationId = DataModel.wareHouseStationList[elementIndex]
    local cfg = PlayerData:GetFactoryData(stationId)
    element.Btn_All.Txt_:SetText(cfg.name)
    element.Btn_All.Img_Select:SetActive(DataModel.lastSelectDic[stationId])
    element.Btn_All:SetClickParam(stationId)
  end,
  Depot_Group_CityChose_Group_Type_ScrollGrid_City_Group_Item_Btn_All_Click = function(btn, str)
    local stationId = str
    DataModel.UpdateStationDic(stationId)
    View.Group_CityChose.Group_Type.ScrollGrid_City.grid.self:RefreshAllElement()
    View.Group_CityChose.Group_Type.Btn_All.Img_Select:SetActive(next(DataModel.lastSelectDic) == nil)
  end,
  Depot_Group_CityChose_Btn_OK_Click = function(btn, str)
    DataModel.selectStationDic = Clone(DataModel.lastSelectDic)
    DataModel.CalWareHouseGoodsData()
    Controller:ChangeTab(EnumDefine.Depot.WareGoods, true)
    View.Group_CityChose:SetActive(false)
  end,
  Depot_Group_CityChose_Btn_Cancel_Click = function(btn, str)
    View.Group_CityChose:SetActive(false)
  end,
  Depot_Group_Tab_Btn_Key_Click = function(btn, str)
    Controller:ChangeTab(EnumDefine.Depot.Key)
  end,
  Depot_Group_Key_ScrollGrid_Item_SetGrid = function(element, elementIndex)
    local info = DataModel.Now_List[elementIndex]
    CommonItem:SetItem(element, {
      id = info.id,
      num = info.server.num
    })
    element.Btn_Item:SetClickParam(info.id)
  end,
  Depot_Group_Key_ScrollGrid_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local params = {
      itemId = tonumber(str),
      type = EnumDefine.OpenTip.Depot
    }
    CommonTips.OpenItem(params)
  end,
  Depot_Group_Equipment_ScrollGrid_Equipment_SetGrid = function(element, elementIndex)
    element.Group_Equipment.Btn_Item:SetClickParam(elementIndex)
    local data = DataModel.Now_List[elementIndex]
    CommonItem:SetEquipment(element.Group_Equipment, data, false)
  end,
  Depot_Group_Equipment_ScrollGrid_Equipment_Group_Item_Group_Equipment_Btn_Item_Click = function(btn, str)
    local params = DataModel.Now_List[tonumber(str)]
    params.scene = 0
    CommonTips.OpenEquipment(params, params.server)
  end,
  Depot_ScrollGrid_Item_SetGrid = function(element, elementIndex)
    element.Btn_Item:SetClickParam(tostring(elementIndex))
    local data = DataModel:GetDataByType(EnumDefine.Depot.Item, DataModel.Sort, false)
    local currData = data[elementIndex]
    CommonItem:SetItem(element, {
      id = currData.data.id,
      num = currData.num or currData.server.num
    }, EnumDefine.ItemType.Item)
    element.Img_TimeLeft:SetActive(currData.limitedData ~= nil)
    if currData.limitedData then
      element.Img_TimeLeft.Txt_:SetText(string.format(GetText(80601882), currData.limitedData.remainDay))
    end
  end,
  Depot_ScrollGrid_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local data = DataModel:GetDataByType(EnumDefine.Depot.Item, DataModel.Sort)
    local detailData = data[tonumber(str)]
    local id = detailData.data.id
    local params = {
      itemId = id,
      type = EnumDefine.OpenTip.Depot,
      saleData = PlayerData:GetSaleItem(id, EnumDefine.Depot.Item),
      limitedTimeData = detailData.limitedData
    }
    CommonTips.OpenItem(params)
  end,
  Depot_ScrollGrid_Equipment_SetGrid = function(element, elementIndex)
    element.Group_Equipment.Btn_Item:SetClickParam(elementIndex)
    local data = DataModel.Now_List[elementIndex]
    CommonItem:SetEquipment(element.Group_Equipment, data, false)
  end,
  Depot_ScrollGrid_Equipment_Group_Item_Group_Equipment_Btn_Item_Click = function(btn, str)
    local params = DataModel.Now_List[tonumber(str)]
    params.scene = 0
    CommonTips.OpenEquipment(params, params.server)
  end,
  Depot_ScrollGrid_Material_SetGrid = function(element, elementIndex)
    element.Btn_Item:SetClickParam(tostring(elementIndex))
    local data = DataModel:GetDataByType(EnumDefine.Depot.Material, DataModel.Sort)
    local currData = data[elementIndex]
    CommonItem:SetItem(element, {
      id = currData.data.id,
      num = currData.server.num
    }, EnumDefine.ItemType.Material)
  end,
  Depot_ScrollGrid_Material_Group_Item_Btn_Item_Click = function(btn, str)
    local data = DataModel:GetDataByType(EnumDefine.Depot.Material, DataModel.Sort)
    local id = data[tonumber(str)].data.id
    local params = {
      itemId = id,
      type = EnumDefine.OpenTip.Depot,
      saleData = PlayerData:GetSaleItem(id, EnumDefine.Depot.Material)
    }
    CommonTips.OpenItem(params)
  end,
  Depot_ScrollGrid_Goods_SetGrid = function(element, elementIndex)
    element.Btn_Item:SetClickParam(tostring(elementIndex))
    local data = DataModel:GetDataByType(EnumDefine.Depot.Warehouse, DataModel.Sort, false)
    local currData = data[elementIndex]
    DataModel.goods = DataModel.goods + currData.server.num
    CommonItem:SetWarehouse(element, {
      id = currData.data.id,
      num = currData.server.num
    })
  end,
  Depot_ScrollGrid_Goods_Group_Goods_Btn_Item_Click = function(btn, str)
    local data = DataModel:GetDataByType(EnumDefine.Depot.Warehouse, DataModel.Sort)
    local id = data[tonumber(str)].data.id
    CommonTips.OpenGoodsTips(id, 1)
  end,
  Depot_ScrollGrid_Food_SetGrid = function(element, elementIndex)
    element.Btn_Item:SetClickParam(tostring(elementIndex))
    local data = DataModel:GetDataByType(EnumDefine.Depot.FridgeItem, DataModel.Sort)
    local currData = data[elementIndex]
    CommonItem:SetFridgeItems(element, {
      id = currData.data.id,
      num = currData.server.num
    })
  end,
  Depot_ScrollGrid_Food_Group_Item_Btn_Item_Click = function(btn, str)
    local data = DataModel:GetDataByType(EnumDefine.Depot.FridgeItem, DataModel.Sort)
    local id = data[tonumber(str)].data.id
    local params = {
      itemId = id,
      type = EnumDefine.OpenTip.Depot,
      saleData = PlayerData:GetSaleItem(id, EnumDefine.Depot.FridgeItem)
    }
    CommonTips.OpenItem(params)
  end,
  Depot_Group_Goods_Btn_Item_Click = function(btn, str)
  end,
  Depot_ScrollGrid_Equipment_Group_Equipment_Btn_Item_Click = function(btn, str)
    local params = DataModel.Now_List[tonumber(str)]
    params.scene = 0
    CommonTips.OpenEquipment(params, params.server)
  end,
  Depot_ScrollGrid_Goods_Group_Item_Btn_Item_Click = function(btn, str)
    local data = DataModel:GetDataByType(EnumDefine.Depot.Warehouse, DataModel.Sort)
    local id = data[tonumber(str)].data.id
    CommonTips.OpenGoodsTips(id, 1)
  end
}
return ViewFunction
