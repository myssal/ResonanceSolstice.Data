local DataModel = require("UIGamingShop/UIGamingShopDataModel")
local View = require("UIGamingShop/UIGamingShopView")
local RogueMainController = require("UICubeRogueMain/UICubeRoguewMainController")
local EquipAttrManager = require("UICubeRogueMain/CubeRogueEquipAttrManager")
local RogueData = require("UICubeRogueMain/UICubeRogueMainDataModel")
local StoreDataModel = require("UIStore/UIStoreDataModel")
local Controller = {}

function Controller:Init(shops)
  View.Img_Title:SetSprite(GetResPath(88300247))
  local cubeId = PlayerData.TempCache.RogueCache.cubeId
  DataModel.cubeCA = PlayerData:GetFactoryData(cubeId)
  local coinCA = PlayerData:GetFactoryData(DataModel.cubeCA.coinId)
  View.Group_Coin.Img_Icon:SetSprite(coinCA.iconPath)
  View.Group_Coin.Txt_Num:SetText(math.floor(PlayerData:GetGoodsById(coinCA.id).num))
  DataModel.shops = {}
  for k, v in pairs(shops) do
    DataModel.shops[#DataModel.shops + 1] = {id = k, data = v}
  end
  DataModel.curIndex = 1
  self:RefreshWeaponShop()
end

function Controller:RefreshWeaponShop()
  View.Group_Weapon.self:SetActive(true)
  local index = DataModel.curIndex
  local itemList = DataModel.shops[index].data.items
  table.sort(itemList, function(a, b)
    local w1 = Controller:GetItemWeight(a.id)
    local w2 = Controller:GetItemWeight(b.id)
    if w1 ~= w2 then
      return w1 > w2
    else
      return tonumber(a.id) > tonumber(b.id)
    end
  end)
  View.Group_Weapon.ScrollGrid_Weapon.grid.self:SetDataCount(#itemList)
  DataModel.commodityIndex = nil
  self:OnSelectWeapon(1)
  View.Group_Weapon.ScrollGrid_Weapon.grid.self:MoveToTop()
end

function Controller:GetItemWeight(id)
  local commodityCa = PlayerData:GetFactoryData(id)
  local factoryName = DataManager:GetFactoryNameById(commodityCa.commodityItemList[1].id)
  if factoryName == "RogueBuffFactory" then
    return self:GetBuffWeight(commodityCa.commodityItemList[1].id)
  elseif factoryName == "RogueEquipmentFactory" then
    return self:GetWeaponWeight(commodityCa.commodityItemList[1].id)
  else
    return -101
  end
end

function Controller:OnSetItemGrid(element, elementIndex)
  local index = DataModel.curIndex
  local itemList = DataModel.shops[index].data.items
  local data = itemList[elementIndex]
  local commodityCa = PlayerData:GetFactoryData(data.id)
  local factoryName = DataManager:GetFactoryNameById(commodityCa.commodityItemList[1].id)
  if factoryName == "RogueBuffFactory" or factoryName == "ItemFactory" then
    self:OnSetBuffGrid(element, elementIndex)
  elseif factoryName == "RogueEquipmentFactory" then
    self:OnSetWeaponGrid(element, elementIndex)
  end
end

function Controller:OnSetBuffGrid(element, elementIndex)
  local index = DataModel.curIndex
  local itemList = DataModel.shops[index].data.items
  local data = itemList[elementIndex]
  local commodityCa = PlayerData:GetFactoryData(data.id)
  local ca = PlayerData:GetFactoryData(commodityCa.commodityItemList[1].id)
  local qualityInt = ca.qualityInt + 1
  if ca.mod == "\233\173\148\230\150\185\229\177\128\229\134\133\233\129\147\229\133\183" then
    qualityInt = ca.qualityInt
  end
  element.Img_BG:SetSprite(DataModel.BuffSmallBgMap[qualityInt])
  element.Txt_Name:SetText(ca.name)
  element.Img_Icon:SetSprite(ca.iconPath)
  element.Group_Price.Img_Icon:SetSprite(commodityCa.monetaryView)
  local needNum = commodityCa.moneyList[1].moneyNum * (1 + EquipAttrManager:GetAttr(Enum_AttrType.Price) + RogueData.GetDescentAttr("Price").value)
  local hasNum = PlayerData:GetGoodsById(commodityCa.moneyList[1].moneyID).num or 0
  local color = "#FFFFFF"
  if needNum > hasNum then
    color = "#FF2121"
  end
  element.Group_Price.Txt_Num:SetColor(color)
  element.Group_Price.Txt_Num:SetText(math.floor(needNum))
  element.Img_Selected:SetActive(DataModel.commodityIndex == elementIndex)
  local cubeData = PlayerData.TempCache.CubeRogueData
  if ca.correspondingTeam ~= nil then
    element.Img_Recommend:SetActive(tostring(ca.correspondingTeam) == tostring(cubeData.team))
  else
    element.Img_Recommend:SetActive(false)
  end
  if commodityCa.purchase then
    local maxNum = StoreDataModel:GetPurchaseNum(commodityCa)
    element.Img_Sold:SetActive(maxNum <= (data.py_cnt or 0))
  else
    element.Img_Sold:SetActive(false)
  end
  element.Btn_:SetClickParam(elementIndex)
end

function Controller:GetBuffWeight(id)
  local ca = PlayerData:GetFactoryData(id)
  local rt = ca.qualityInt + 100
  local cubeData = PlayerData.TempCache.CubeRogueData
  if tostring(ca.correspondingTeam) == tostring(cubeData.team) then
    rt = ca.qualityInt + 200
  end
  return rt
end

function Controller:RefreshGroupRight()
  local index = DataModel.curIndex
  local itemList = DataModel.shops[index].data.items
  local data = itemList[DataModel.commodityIndex]
  local commodityCa = PlayerData:GetFactoryData(data.id)
  local factoryName = DataManager:GetFactoryNameById(commodityCa.commodityItemList[1].id)
  if factoryName == "RogueBuffFactory" or factoryName == "ItemFactory" then
    self:RefreshBuffInfo()
  elseif factoryName == "RogueEquipmentFactory" then
    self:RefreshWeaponInfo()
  end
end

function Controller:RefreshBuffInfo()
  local index = DataModel.curIndex
  local itemList = DataModel.shops[index].data.items
  local data = itemList[DataModel.commodityIndex]
  local commodityCa = PlayerData:GetFactoryData(data.id)
  local ca = PlayerData:GetFactoryData(commodityCa.commodityItemList[1].id)
  View.Group_Right.Group_Buff:SetActive(true)
  View.Group_Right.Group_Weapon:SetActive(false)
  local qualityInt = ca.qualityInt + 1
  if ca.mod == "\233\173\148\230\150\185\229\177\128\229\134\133\233\129\147\229\133\183" then
    qualityInt = ca.qualityInt
  end
  View.Group_Right.Group_Buff.Img_Bg:SetSprite(DataModel.BuffBigBgMap[qualityInt])
  View.Group_Right.Group_Buff.Txt_Name:SetText(ca.name)
  View.Group_Right.Group_Buff.Img_Icon:SetSprite(ca.iconPath)
  View.Group_Right.Group_Buff.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetText(ca.des)
  local teamCA = PlayerData:GetFactoryData(ca.correspondingTeam)
  if teamCA ~= nil then
    View.Group_Right.Group_Buff.ScrollView_DefaultDes.Viewport.Content.Txt_Tyep:SetActive(true)
    View.Group_Right.Group_Buff.ScrollView_DefaultDes.Viewport.Content.Txt_Tyep:SetText(teamCA.name)
    View.Group_Right.Group_Buff.Img_Type:SetSprite(teamCA.tabIconPath)
    View.Group_Right.Group_Buff.Img_TypeIcon:SetActive(true)
    View.Group_Right.Group_Buff.Img_TypeIcon:SetSprite(teamCA.shadePath)
  else
    View.Group_Right.Group_Buff.Img_Type:SetSprite("UI/CubeRogue/ItemUse/ItemUseUI/ItemType")
    View.Group_Right.Group_Buff.Img_TypeIcon:SetActive(false)
    View.Group_Right.Group_Buff.ScrollView_DefaultDes.Viewport.Content.Txt_Tyep:SetActive(false)
  end
  View.Group_Right.Img_Price.Img_Icon:SetSprite(commodityCa.monetaryView)
  local needNum = commodityCa.moneyList[1].moneyNum * (1 + EquipAttrManager:GetAttr(Enum_AttrType.Price) + RogueData.GetDescentAttr("Price").value)
  local hasNum = PlayerData:GetGoodsById(commodityCa.moneyList[1].moneyID).num or 0
  local color = "#FFFFFF"
  local notEnough = needNum > hasNum
  if notEnough then
    color = "#FF2121"
  end
  View.Group_Right.Img_Price.Txt_Num:SetColor(color)
  View.Group_Right.Img_Price.Txt_Num:SetText(math.floor(needNum))
  local cubeData = PlayerData.TempCache.CubeRogueData
  local recommend = teamCA ~= nil and tostring(ca.correspondingTeam) == tostring(cubeData.team)
  View.Group_Right.Group_Buff.Img_Recommend:SetActive(recommend)
  local isSold = false
  if commodityCa.purchase then
    local maxNum = StoreDataModel:GetPurchaseNum(commodityCa)
    isSold = maxNum <= (data.py_cnt or 0)
  end
  View.Group_Right.Btn_Buy.Img_Unable:SetActive(notEnough or isSold)
  if isSold then
    View.Group_Right.Btn_Buy.Img_Unable.Txt_Des:SetText(GetText(80610104))
  elseif notEnough then
    View.Group_Right.Btn_Buy.Img_Unable.Txt_Des:SetText(GetText(80610292))
  end
end

function Controller:OnSelectWeapon(index)
  if index == DataModel.commodityIndex then
    return
  end
  DataModel.commodityIndex = index
  View.Group_Weapon.ScrollGrid_Weapon.grid.self:RefreshAllElement()
  self:RefreshGroupRight()
end

function Controller:OnSetWeaponGrid(element, elementIndex)
  local index = DataModel.curIndex
  local itemList = DataModel.shops[index].data.items
  local data = itemList[elementIndex]
  local commodityCa = PlayerData:GetFactoryData(data.id)
  local ca = PlayerData:GetFactoryData(commodityCa.commodityItemList[1].id)
  local bgPath = DataModel.WeaponSmallBgMap[ca.qualityInt + 1]
  if ca.isNegative then
    bgPath = DataModel.WeaponSmallBgMap[#DataModel.WeaponSmallBgMap]
  end
  element.Img_BG:SetSprite(bgPath)
  element.Txt_Name:SetText(ca.name)
  element.Img_Icon:SetSprite(ca.iconPath)
  element.Group_Price.Img_Icon:SetSprite(commodityCa.monetaryView)
  local needNum = commodityCa.moneyList[1].moneyNum * (1 + EquipAttrManager:GetAttr(Enum_AttrType.Price) + RogueData.GetDescentAttr("Price").value)
  local hasNum = PlayerData:GetGoodsById(commodityCa.moneyList[1].moneyID).num or 0
  local color = "#FFFFFF"
  if needNum > hasNum then
    color = "#FF2121"
  end
  element.Group_Price.Txt_Num:SetColor(color)
  element.Group_Price.Txt_Num:SetText(math.floor(needNum))
  element.Img_Selected:SetActive(DataModel.commodityIndex == elementIndex)
  if commodityCa.purchase then
    local maxNum = StoreDataModel:GetPurchaseNum(commodityCa)
    element.Img_Sold:SetActive(maxNum <= (data.py_cnt or 0))
  else
    element.Img_Sold:SetActive(false)
  end
  element.Btn_:SetClickParam(elementIndex)
end

function Controller:GetWeaponWeight(id)
  local ca = PlayerData:GetFactoryData(id)
  local rt = ca.qualityInt
  if ca.isNegative then
    rt = -100
  end
  return rt
end

function Controller:RefreshWeaponInfo()
  local index = DataModel.curIndex
  local itemList = DataModel.shops[index].data.items
  local data = itemList[DataModel.commodityIndex]
  local commodityCa = PlayerData:GetFactoryData(data.id)
  local ca = PlayerData:GetFactoryData(commodityCa.commodityItemList[1].id)
  View.Group_Right.Group_Weapon:SetActive(true)
  View.Group_Right.Group_Buff:SetActive(false)
  local bgPath = DataModel.WeaponBigBgMap[ca.qualityInt + 1]
  if ca.isNegative then
    bgPath = DataModel.WeaponBigBgMap[#DataModel.WeaponBigBgMap]
  end
  View.Group_Right.Group_Weapon.Img_Bg:SetSprite(bgPath)
  View.Group_Right.Group_Weapon.Txt_Name:SetText(ca.name)
  View.Group_Right.Group_Weapon.Img_Icon:SetSprite(ca.iconPath)
  View.Group_Right.Group_Weapon.ScrollView_Des.Viewport.Content.Txt_Des:SetText(ca.des)
  View.Group_Right.Img_Price.Img_Icon:SetSprite(commodityCa.monetaryView)
  local needNum = commodityCa.moneyList[1].moneyNum * (1 + EquipAttrManager:GetAttr(Enum_AttrType.Price) + RogueData.GetDescentAttr("Price").value)
  local hasNum = PlayerData:GetGoodsById(commodityCa.moneyList[1].moneyID).num or 0
  local color = "#FFFFFF"
  local notEnough = needNum > hasNum
  if notEnough then
    color = "#FF2121"
  end
  View.Group_Right.Img_Price.Txt_Num:SetColor(color)
  View.Group_Right.Img_Price.Txt_Num:SetText(math.floor(needNum))
  local isSold = false
  if commodityCa.purchase then
    local maxNum = StoreDataModel:GetPurchaseNum(commodityCa)
    isSold = maxNum <= (data.py_cnt or 0)
  end
  View.Group_Right.Btn_Buy.Img_Unable:SetActive(notEnough or isSold)
  if isSold then
    View.Group_Right.Btn_Buy.Img_Unable.Txt_Des:SetText(GetText(80610104))
  elseif notEnough then
    View.Group_Right.Btn_Buy.Img_Unable.Txt_Des:SetText(GetText(80610292))
  end
end

function Controller:OnClickBtnBuy()
  local shopIndex = DataModel.curIndex
  local shopId = DataModel.shops[shopIndex].id
  local commodityIndex = DataModel.commodityIndex
  local data = DataModel.shops[shopIndex].data.items[commodityIndex]
  local commodityId = data.id
  local commodityCa = PlayerData:GetFactoryData(commodityId)
  local isSold = false
  if commodityCa.purchase then
    local maxNum = StoreDataModel:GetPurchaseNum(commodityCa)
    isSold = maxNum <= (data.py_cnt or 0)
  end
  if isSold then
    return
  end
  local needNum = commodityCa.moneyList[1].moneyNum * (1 + EquipAttrManager:GetAttr(Enum_AttrType.Price) + RogueData.GetDescentAttr("Price").value)
  local hasNum = PlayerData:GetGoodsById(commodityCa.moneyList[1].moneyID).num or 0
  local notEnough = needNum > hasNum
  if notEnough then
    return
  end
  local cIndex = -1
  local shopCa = PlayerData:GetFactoryData(shopId)
  for i = 1, #shopCa.shopList do
    if tonumber(shopCa.shopList[i].id) == tonumber(commodityId) then
      cIndex = i
      break
    end
  end
  if cIndex <= 0 then
    return
  end
  Net:SendProto("shop.buy", function(json)
    local curCnt = DataModel.shops[shopIndex].data.items[commodityIndex].py_cnt or 0
    DataModel.shops[shopIndex].data.items[commodityIndex].py_cnt = curCnt + 1
    local cost = {
      [commodityCa.moneyList[1].moneyID] = math.tointeger(commodityCa.moneyList[1].moneyNum * (1 + EquipAttrManager:GetAttr(Enum_AttrType.Price) + RogueData.GetDescentAttr("Price").value))
    }
    PlayerData:RefreshUseItems(cost)
    local coinCA = PlayerData:GetFactoryData(DataModel.cubeCA.coinId)
    View.Group_Coin.Txt_Num:SetText(math.floor(PlayerData:GetGoodsById(coinCA.id).num))
    DataModel.commodityIndex = nil
    Controller:OnSelectWeapon(commodityIndex)
    RogueMainController.DealRewardLose(json)
    RogueMainController.ShowCoin()
  end, shopId, cIndex, 1, commodityId)
end

return Controller
