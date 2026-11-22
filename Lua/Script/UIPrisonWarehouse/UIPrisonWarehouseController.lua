local DataModel = require("UIPrisonWarehouse/UIPrisonWarehouseDataModel")
local View = require("UIPrisonWarehouse/UIPrisonWarehouseView")
local CommonItem = require("Common/BtnItem")
local NPCDialog = require("Common/NPCDialog")
local Controller = {}

function Controller:InitView()
  DataModel.ChangeGoods = {
    [1] = {},
    [2] = {}
  }
  DataModel.InitWarehouseData()
  View.Group_Batch:SetActive(false)
  Controller:SelectProductBatchMode(DataModel.ProductGoodsBatchMode, true)
  Controller:SelectMaterialBatchMode(DataModel.MaterialGoodsBatchMode, true)
  Controller:SelectTrainBatchMode(DataModel.TrainGoodsBatchMode, true)
  Controller:RefreshMaterialGoods()
  Controller:RefreshProductGoods()
  Controller:RefreshTrainGoods()
  Controller:RefreshTopInfo()
end

function Controller:SelectTrainBatchMode(mode, isInit)
  if DataModel.TrainGoodsBatchMode == mode and not isInit then
    return
  end
  DataModel.TrainGoodsBatchMode = mode
  View.Group_TrainWarehouse.Group_Choose.Btn_Batch.Group_On:SetActive(DataModel.TrainGoodsBatchMode == 1)
  View.Group_TrainWarehouse.Group_Choose.Btn_Max.Group_On:SetActive(DataModel.TrainGoodsBatchMode == 2)
end

function Controller:SelectMaterialBatchMode(mode)
  if DataModel.MaterialGoodsBatchMode == mode then
    return
  end
  DataModel.MaterialGoodsBatchMode = mode
  View.Group_MaterialWarehouse.Group_MaterialWarehouse.Group_Choose.Btn_Batch.Group_On:SetActive(DataModel.MaterialGoodsBatchMode == 1)
  View.Group_MaterialWarehouse.Group_MaterialWarehouse.Group_Choose.Btn_Max.Group_On:SetActive(DataModel.MaterialGoodsBatchMode == 2)
end

function Controller:SelectProductBatchMode(mode)
  if DataModel.ProductGoodsBatchMode == mode then
    return
  end
  DataModel.ProductGoodsBatchMode = mode
  View.Group_ProductWarehouse.Group_ProductWarehouse.Group_Choose.Btn_Batch.Group_On:SetActive(DataModel.ProductGoodsBatchMode == 1)
  View.Group_ProductWarehouse.Group_ProductWarehouse.Group_Choose.Btn_Max.Group_On:SetActive(DataModel.ProductGoodsBatchMode == 2)
end

function Controller:RefreshWarehouseSpace(tab)
  local curCapacity, total
  if tab == 1 then
    curCapacity = DataModel.StationGoodsMaterialSpace
    total = PrisonData.GetRawMaterialWarehouseMaxCapacity()
    Controller:RefreshMaterialGoodsSpace()
  else
    curCapacity = DataModel.StationGoodsProductSpace
    total = PrisonData.GetProductWarehouseMaxCapacity()
    Controller:RefreshProductGoodsSpace()
  end
end

function Controller:RefreshTrainGoods()
  local count = #DataModel.TrainGoods
  if count == 0 then
    View.Group_TrainWarehouse.Img_Kong:SetActive(true)
    View.Group_TrainWarehouse.ScrollGrid_TrainWarehouse.self:SetActive(false)
    View.Group_TrainWarehouse.ScrollGrid_TrainWarehouse.self:SetActive(false)
    View.Group_TrainWarehouse.ScrollGrid_TrainWarehouse.self:SetActive(false)
  else
    View.Group_TrainWarehouse.Img_Kong:SetActive(false)
    View.Group_TrainWarehouse.ScrollGrid_TrainWarehouse.self:SetActive(true)
    View.Group_TrainWarehouse.ScrollGrid_TrainWarehouse.grid.self:SetDataCount(count)
    View.Group_TrainWarehouse.ScrollGrid_TrainWarehouse.grid.self:RefreshAllElement()
  end
  Controller:RefreshTrainSpace()
end

function Controller:RefreshTrainSpace()
  View.Group_TrainWarehouse.Group_TrainCapacity.Txt_CapacityNum:SetText(DataModel.TrainGoodsSpace .. "/" .. DataModel.TrainGoodsMaxSpace)
  View.Group_TrainWarehouse.Group_TrainCapacity.Group_CapacityBar.Img_BarFilling:SetFilledImgAmount(DataModel.TrainGoodsSpace / DataModel.TrainGoodsMaxSpace)
end

function Controller:RefreshMaterialGoods()
  local data = DataModel.GetGoodsDataByType(DataModel.GoodsPlaceType.Material)
  View.Group_MaterialWarehouse.ScrollGrid_Warehouse.grid.self:SetDataCount(#data)
  View.Group_MaterialWarehouse.ScrollGrid_Warehouse.grid.self:RefreshAllElement()
  local count = table.count(data)
  View.Group_MaterialWarehouse.Img_Kong:SetActive(count == 0)
  Controller:RefreshMaterialGoodsSpace()
end

function Controller:RefreshMaterialGoodsSpace()
  View.Group_MaterialWarehouse.Group_MaterialWarehouse.Group_MaterialCapacity.Txt_CapacityNum:SetText(DataModel.StationGoodsMaterialSpace .. "/" .. DataModel.StationGoodsMaterialMaxSpace)
  View.Group_MaterialWarehouse.Group_MaterialWarehouse.Group_MaterialCapacity.Group_CapacityBar.Img_BarFilling:SetFilledImgAmount(DataModel.StationGoodsMaterialSpace / DataModel.StationGoodsMaterialMaxSpace)
end

function Controller:RefreshProductGoods()
  local data = DataModel.GetGoodsDataByType(DataModel.GoodsPlaceType.Product)
  View.Group_ProductWarehouse.Group_ProductWarehouse.ScrollGrid_Warehouse.grid.self:SetDataCount(#data)
  View.Group_ProductWarehouse.Group_ProductWarehouse.ScrollGrid_Warehouse.grid.self:RefreshAllElement()
  local count = table.count(data)
  View.Group_ProductWarehouse.Img_Kong:SetActive(count == 0)
  Controller:RefreshProductGoodsSpace()
end

function Controller:RefreshProductGoodsSpace()
  View.Group_ProductWarehouse.Group_ProductWarehouse.Group_ProductCapacity.Txt_CapacityNum:SetText(DataModel.StationGoodsProductSpace .. "/" .. DataModel.StationGoodsProductMaxSpace)
  View.Group_ProductWarehouse.Group_ProductWarehouse.Group_ProductCapacity.Group_CapacityBar.Img_BarFilling:SetFilledImgAmount(DataModel.StationGoodsProductSpace / DataModel.StationGoodsProductMaxSpace)
end

function Controller:RefreshTopInfo()
  View.Group_Resources.Group_GoldCoin.Txt_Num:SetText(PlayerData:GetGoodsById(11400001).num)
  View.Group_Resources.Group_DiamondCount.Txt_Num:SetText(PlayerData:GetGoodsById(11400005).num)
  View.Group_Resources.Group_MaterialLv:SetActive(true)
  local prisonLevel = PrisonData.GetPrisonLv()
  local prisonCfg = PrisonData.GetPrisonCA()
  local lvCfg = prisonCfg.lvList[prisonLevel]
  local curLvSpace, remainGoodSpace
  local curMax = PrisonData.GetRawMaterialWarehouseMaxCapacity() + PrisonData.GetProductWarehouseMaxCapacity()
  local cfgMax = lvCfg.materialWare + lvCfg.extraMaterialWare + lvCfg.commodityWare + lvCfg.extraCommodityWare
  local remainPrison = cfgMax - curMax
  View.Group_Resources.Group_MaterialLv.Txt_Num:SetText(string.format(GetText(80601085), remainPrison))
end

function Controller:SetMaterialWarehouseItemElement(element, elementIndex)
  local data = DataModel.GetGoodsDataByType(DataModel.GoodsPlaceType.Material)
  CommonItem:SetItem(element.Group_Item, data[elementIndex].info)
  local factoryName = DataManager:GetFactoryNameById(data[elementIndex].info.id)
  if element.Group_Item.Txt_Num then
    element.Group_Item.Txt_Num:SetActive(true)
    element.Group_Item.Txt_Num:SetText(data.num)
  end
  element.Group_Item.Group_EType:SetActive(true)
  if factoryName == "SourceMaterialFactory" then
    element.Group_Item.Group_EType.Img_Icon:SetSprite("UI/Prison/PrisonWarehouse/sucai")
  elseif factoryName == "HomeGoodsFactory" then
    element.Group_Item.Group_EType.Img_Icon:SetSprite("UI/Prison/PrisonWarehouse/huowu")
  elseif factoryName == "ItemFactory" then
    element.Group_Item.Group_EType.Img_Icon:SetSprite("UI/Depot/Item_picked")
  else
    element.Group_Item.Group_EType:SetActive(false)
  end
  element.Group_Item.Btn_Item:SetClickParam(elementIndex)
  element.Group_Item.Txt_Num:SetText(data[elementIndex].num)
end

function Controller:SetProductMaterialWarehouseItemElement(element, elementIndex)
  local data = DataModel.GetGoodsDataByType(DataModel.GoodsPlaceType.Product)
  CommonItem:SetItem(element.Group_Item, data[elementIndex].info)
  local factoryName = DataManager:GetFactoryNameById(data[elementIndex].info.id)
  if element.Group_Item.Txt_Num then
    element.Group_Item.Txt_Num:SetActive(true)
    element.Group_Item.Txt_Num:SetText(data.num)
  end
  element.Group_Item.Group_EType:SetActive(true)
  if factoryName == "SourceMaterialFactory" then
    element.Group_Item.Group_EType.Img_Icon:SetSprite("UI/Prison/PrisonWarehouse/sucai")
  elseif factoryName == "HomeGoodsFactory" then
    element.Group_Item.Group_EType.Img_Icon:SetSprite("UI/Prison/PrisonWarehouse/huowu")
  elseif factoryName == "ItemFactory" then
    element.Group_Item.Group_EType.Img_Icon:SetSprite("UI/Depot/Item_picked")
  else
    element.Group_Item.Group_EType:SetActive(false)
  end
  element.Group_Item.Btn_Item:SetClickParam(elementIndex)
  element.Group_Item.Txt_Num:SetText(data[elementIndex].num)
end

function Controller:SetTrainWarehouseItemElement(element, elementIndex)
  local data = DataModel.TrainGoods
  CommonItem:SetItem(element.Group_Item, data[elementIndex].info)
  local factoryName = DataManager:GetFactoryNameById(data[elementIndex].info.id)
  if element.Group_Item.Txt_Num then
    element.Group_Item.Txt_Num:SetActive(true)
    element.Group_Item.Txt_Num:SetText(data.num)
  end
  element.Group_Item.Group_EType:SetActive(true)
  if factoryName == "SourceMaterialFactory" then
    element.Group_Item.Group_EType.Img_Icon:SetSprite("UI/Prison/PrisonWarehouse/sucai")
  elseif factoryName == "HomeGoodsFactory" then
    element.Group_Item.Group_EType.Img_Icon:SetSprite("UI/Prison/PrisonWarehouse/huowu")
  elseif factoryName == "ItemFactory" then
    element.Group_Item.Group_EType.Img_Icon:SetSprite("UI/Depot/Item_picked")
  else
    element.Group_Item.Group_EType:SetActive(false)
  end
  element.Group_Item.Btn_Item:SetClickParam(elementIndex)
  element.Group_Item.Txt_Num:SetText(data[elementIndex].num)
end

function Controller:OpenBatchPanel(info, idx, type, from, to)
  UIManager:LoadSplitPrefab(View, "UI/Prison/PrisonWarehouse/PrisonWarehouse", "Group_Batch")
  View.Group_Batch.self:SetActive(true)
  DataModel.BatchInfo = info
  DataModel.BatchIdx = idx
  DataModel.BatchFrom = from
  DataModel.BatchTo = to
  DataModel.BatchType = type
  Controller:RefreshItem(info, View.Group_Batch.Group_Panel.Group_Item)
  View.Group_Batch.Group_Panel.Txt_Name:SetText(info.name or info.info.name)
  View.Group_Batch.Group_Panel.ScrollView_Describe.Viewport.Txt_Describe:SetText(info.des or info.info.des)
  View.Group_Batch.Group_Panel.Img_Flat:SetActive(false)
  View.Group_Batch.Group_Panel.Img_Up:SetActive(false)
  View.Group_Batch.Group_Panel.Img_Down:SetActive(false)
  View.Group_Batch.Group_Panel.Img_TrendFlat:SetActive(false)
  View.Group_Batch.Group_Panel.Img_TrendUp:SetActive(false)
  View.Group_Batch.Group_Panel.Img_TrendDown:SetActive(false)
  View.Group_Batch.Group_Panel.Txt_Quotation:SetActive(false)
  View.Group_Batch.Group_Panel.Group_Gold.self:SetActive(false)
  View.Group_Batch.Group_Panel.Group_Price.self:SetActive(false)
  View.Group_Batch.Group_Panel.Group_Average.self:SetActive(false)
  View.Group_Batch.Group_Panel.self:SetAnchoredPositionY(-200)
  if type == 1 then
    View.Group_Batch.Btn_Confirm.Group_.Txt_T:SetText(GetText(80601090))
  else
    View.Group_Batch.Btn_Confirm.Group_.Txt_T:SetText(GetText(80601091))
  end
  local maxNum, minNum
  maxNum = info.num
  minNum = maxNum <= 0 and 0 or 1
  View.Group_Batch.Group_Panel.Group_Slider.Group_Num.Txt_Select:SetText(minNum)
  View.Group_Batch.Group_Panel.Group_Slider.Group_Num.Txt_Possess:SetText(maxNum)
  View.Group_Batch.Group_Panel.Group_Slider.Slider_Value.self:SetMinAndMaxValue(minNum, maxNum, true)
  View.Group_Batch.Group_Panel.Group_Slider.Slider_Value.self:SetSliderValue(minNum)
  DataModel.BatchNum = minNum
end

function Controller:RefreshItem(info, element)
  local show
  if info.info then
    show = info.info
  end
  element.Img_Item:SetSprite(string.nilorempty(info.info.imagePath) and info.info.iconPath or info.info.imagePath)
  element.Img_Bottom:SetSprite(UIConfig.BottomConfig[show.qualityInt + 1])
  element.Img_Mask:SetSprite(UIConfig.MaskConfig[show.qualityInt + 1])
  element.Txt_Num:SetText(info.num)
end

function Controller:ExchangeGoods(from, to, idx, num)
  if num < 0 then
    return
  end
  local fromData = DataModel.GetGoodsDataByType(from)
  local toRemainSpace = DataModel.GetRemainSpaceByType(to)
  if toRemainSpace <= 0 then
    CommonTips.OpenTips(GetText(80600598))
    return
  end
  if not fromData[idx] or num > fromData[idx].num then
    return
  end
  if (from == DataModel.GoodsPlaceType.Train or to == DataModel.GoodsPlaceType.Train) and (DataModel.InTravel or DataModel.CurStation ~= 83000017) then
    CommonTips.OpenTips(GetText(80608033))
    return
  end
  if to == DataModel.GoodsPlaceType.Train then
    local factoryName = DataManager:GetFactoryNameById(fromData[idx].info.id)
    if factoryName == "HomeGoodsFactory" and num > toRemainSpace then
      num = toRemainSpace
    end
  elseif toRemainSpace < num then
    num = toRemainSpace
  end
  if num == 0 then
    return
  end
  if DataModel.ExchangeGoods(from, to, idx, num) then
    if from == DataModel.GoodsPlaceType.Material or to == DataModel.GoodsPlaceType.Material then
      table.sort(DataModel.MaterialGoods, function(a, b)
        return a.info.id < b.info.id
      end)
      Controller:RefreshMaterialGoods()
    end
    if from == DataModel.GoodsPlaceType.Product or to == DataModel.GoodsPlaceType.Product then
      table.sort(DataModel.ProductGoods, function(a, b)
        return a.info.id < b.info.id
      end)
      Controller:RefreshProductGoods()
    end
    if from == DataModel.GoodsPlaceType.Train or to == DataModel.GoodsPlaceType.Train then
      table.sort(DataModel.TrainGoods, function(a, b)
        return a.info.id < b.info.id
      end)
      Controller:RefreshTrainGoods()
    end
  end
end

function Controller:ChangeExchangeType(type)
  if DataModel.CurExchangeType == type then
    return
  end
  DataModel.CurExchangeType = type
  Controller:PlayExchangeAnim()
  View.Group_btnTM.Group_Pick:SetActive(type == DataModel.ExchangeType.MaterialAndTrain)
  View.Group_btnTP.Group_Pick:SetActive(type == DataModel.ExchangeType.ProductAndTrain)
  View.Group_btnMP.Group_Pick:SetActive(type == DataModel.ExchangeType.MaterialAndProduct)
end

function Controller:ConfirmBatchClick()
  Controller:ExchangeGoods(DataModel.BatchFrom, DataModel.BatchTo, DataModel.BatchIdx, DataModel.BatchNum)
  View.Group_Batch.self:SetActive(false)
end

function Controller:OneClickGetGoods()
end

function Controller:OneClickSaveGoods()
  if DataModel.InTravel or DataModel.CurStation ~= 83000017 then
    CommonTips.OpenTips(GetText(80608033))
    return
  end
end

function Controller:PlayExchangeAnim()
  if DataModel.CurExchangeType == DataModel.ExchangeType.ProductAndTrain then
    View.self:PlayAnimOnce("PrisonWarehouse_Tp")
  elseif DataModel.CurExchangeType == DataModel.ExchangeType.MaterialAndTrain then
    View.self:PlayAnimOnce("PrisonWarehouse_Tm")
  elseif DataModel.CurExchangeType == DataModel.ExchangeType.MaterialAndProduct then
    View.self:PlayAnimOnce("PrisonWarehouse_Mp")
  end
end

function Controller:ClickExpandSpace(type)
  UIManager:Open("UI/Prison/PrisonWarehouse/WarehouseNew/PrisonWarehouseOption", Json.encode({type = type}))
end

function Controller:ReturnToMain()
  DataModel.DealWithGoods()
end

return Controller
