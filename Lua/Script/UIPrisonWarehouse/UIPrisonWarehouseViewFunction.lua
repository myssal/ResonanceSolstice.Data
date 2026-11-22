local View = require("UIPrisonWarehouse/UIPrisonWarehouseView")
local DataModel = require("UIPrisonWarehouse/UIPrisonWarehouseDataModel")
local Controller = require("UIPrisonWarehouse/UIPrisonWarehouseController")
local ViewFunction = {
  PrisonWarehouse_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:ReturnToMain()
    View.self:CloseUI()
  end,
  PrisonWarehouse_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    Controller:ReturnToMain()
    UIManager:GoHome()
  end,
  PrisonWarehouse_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PrisonWarehouse_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80304345}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end,
  PrisonWarehouse_Group_Resources_Group_MaterialLv_Btn_Tips_Click = function(btn, str)
    View.Group_Tips:SetActive(true)
  end,
  PrisonWarehouse_Group_Resources_Group_GoldCoin_Btn_GoldCoin_Click = function(btn, str)
  end,
  PrisonWarehouse_Group_Resources_Group_GoldCoin_Btn_Add_Click = function(btn, str)
  end,
  PrisonWarehouse_Group_TrainWarehouse_ScrollGrid_TrainWarehouse_SetGrid = function(element, elementIndex)
    Controller:SetTrainWarehouseItemElement(element, elementIndex)
  end,
  PrisonWarehouse_Group_TrainWarehouse_ScrollGrid_TrainWarehouse_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local data = DataModel.GetGoodsDataByType(DataModel.GoodsPlaceType.Train)
    local idx = tonumber(str)
    if DataModel.CurExchangeType == DataModel.ExchangeType.MaterialAndTrain then
      if DataModel.TrainGoodsBatchMode == 1 then
        Controller:OpenBatchPanel(data[idx], idx, 1, DataModel.GoodsPlaceType.Train, DataModel.GoodsPlaceType.Material)
      else
        Controller:ExchangeGoods(DataModel.GoodsPlaceType.Train, DataModel.GoodsPlaceType.Material, idx, data[idx].num)
      end
    elseif DataModel.CurExchangeType == DataModel.ExchangeType.ProductAndTrain then
      if DataModel.TrainGoodsBatchMode == 1 then
        Controller:OpenBatchPanel(data[idx], idx, 1, DataModel.GoodsPlaceType.Train, DataModel.GoodsPlaceType.Product)
      else
        Controller:ExchangeGoods(DataModel.GoodsPlaceType.Train, DataModel.GoodsPlaceType.Product, tonumber(str), data[idx].num)
      end
    end
  end,
  PrisonWarehouse_Group_TrainWarehouse_Group_Choose_Btn_Batch_Click = function(btn, str)
    Controller:SelectTrainBatchMode(1)
  end,
  PrisonWarehouse_Group_TrainWarehouse_Group_Choose_Btn_Max_Click = function(btn, str)
    Controller:SelectTrainBatchMode(2)
  end,
  PrisonWarehouse_Group_Batch_Btn_BG_Click = function(btn, str)
  end,
  PrisonWarehouse_Group_Batch_Group_Panel_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  PrisonWarehouse_Group_Batch_Group_Panel_Btn_Min_Click = function(btn, str)
    DataModel.BatchNum = 1
    View.Group_Batch.Group_Panel.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BatchNum)
    View.Group_Batch.Group_Panel.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.BatchNum)
  end,
  PrisonWarehouse_Group_Batch_Group_Panel_Btn_Dec_Click = function(btn, str)
    if DataModel.BatchNum - 1 < View.Group_Batch.Group_Panel.Group_Slider.Slider_Value.slider.minValue then
      return
    end
    DataModel.BatchNum = DataModel.BatchNum - 1
    View.Group_Batch.Group_Panel.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BatchNum)
    View.Group_Batch.Group_Panel.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.BatchNum)
  end,
  PrisonWarehouse_Group_Batch_Group_Panel_Group_Slider_Slider_Value_Slider = function(slider, value)
    DataModel.BatchNum = DataModel.NumRound(value)
    View.Group_Batch.Group_Panel.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.BatchNum)
  end,
  PrisonWarehouse_Group_Batch_Group_Panel_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  PrisonWarehouse_Group_Batch_Group_Panel_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  PrisonWarehouse_Group_Batch_Group_Panel_Btn_Add_Click = function(btn, str)
    if DataModel.BatchNum + 1 > View.Group_Batch.Group_Panel.Group_Slider.Slider_Value.slider.maxValue then
      return
    end
    DataModel.BatchNum = DataModel.BatchNum + 1
    View.Group_Batch.Group_Panel.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BatchNum)
    View.Group_Batch.Group_Panel.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.BatchNum)
  end,
  PrisonWarehouse_Group_Batch_Group_Panel_Btn_Max_Click = function(btn, str)
    DataModel.BatchNum = math.floor(View.Group_Batch.Group_Panel.Group_Slider.Slider_Value.slider.maxValue + 0.5)
    View.Group_Batch.Group_Panel.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BatchNum)
    View.Group_Batch.Group_Panel.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.BatchNum)
  end,
  PrisonWarehouse_Group_Batch_Btn_Cancel_Click = function(btn, str)
    View.Group_Batch.self:SetActive(false)
  end,
  PrisonWarehouse_Group_Batch_Btn_Confirm_Click = function(btn, str)
    Controller:ConfirmBatchClick()
  end,
  PrisonWarehouse_Group_Tips_Btn_Close_Click = function(btn, str)
    View.Group_Tips:SetActive(false)
  end,
  PrisonWarehouse_Group_TrainWarehouse_ScrollGrid_TrainWarehouse_Group_Item_Group_Item_Btn_Item_LongPress = function(btn, str)
    local row = DataModel.TrainGoods[tonumber(str)]
    if row then
      CommonTips.OpenGoodsTips(row.info.id, 1)
    end
  end,
  PrisonWarehouse_Group_Resources_Group_DiamondCount_Btn_Diamond_Click = function(btn, str)
    CommonTips.OpenStoreBuy()
  end,
  PrisonWarehouse_Group_Resources_Group_DiamondCount_Btn_Add_Click = function(btn, str)
    CommonTips.OpenStoreBuy()
  end,
  PrisonWarehouse_Group_MaterialWarehouse_Group_MaterialWarehouse_Group_Choose_Btn_Max_Click = function(btn, str)
    Controller:SelectMaterialBatchMode(2)
  end,
  PrisonWarehouse_Group_MaterialWarehouse_Group_MaterialWarehouse_Group_Choose_Btn_Batch_Click = function(btn, str)
    Controller:SelectMaterialBatchMode(1)
  end,
  PrisonWarehouse_Group_MaterialWarehouse_Group_MaterialWarehouse_Group_Expansion_Btn__Click = function(btn, str)
    DataModel.CurExpandPanelType = 1
    Controller:ClickExpandSpace(1)
  end,
  PrisonWarehouse_Group_MaterialWarehouse_ScrollGrid_Warehouse_SetGrid = function(element, elementIndex)
    Controller:SetMaterialWarehouseItemElement(element, elementIndex)
  end,
  PrisonWarehouse_Group_MaterialWarehouse_ScrollGrid_Warehouse_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local data = DataModel.GetGoodsDataByType(DataModel.GoodsPlaceType.Material)
    local idx = tonumber(str)
    if DataModel.CurExchangeType == DataModel.ExchangeType.MaterialAndProduct then
      if DataModel.MaterialGoodsBatchMode == 1 then
        Controller:OpenBatchPanel(data[idx], idx, 2, DataModel.GoodsPlaceType.Material, DataModel.GoodsPlaceType.Product)
      else
        Controller:ExchangeGoods(DataModel.GoodsPlaceType.Material, DataModel.GoodsPlaceType.Product, idx, data[idx].num)
      end
    elseif DataModel.CurExchangeType == DataModel.ExchangeType.MaterialAndTrain then
      if DataModel.MaterialGoodsBatchMode == 1 then
        Controller:OpenBatchPanel(data[idx], idx, 2, DataModel.GoodsPlaceType.Material, DataModel.GoodsPlaceType.Train)
      else
        Controller:ExchangeGoods(DataModel.GoodsPlaceType.Material, DataModel.GoodsPlaceType.Train, tonumber(str), data[idx].num)
      end
    end
  end,
  PrisonWarehouse_Group_MaterialWarehouse_ScrollGrid_Warehouse_Group_Item_Group_Item_Btn_Item_LongPress = function(btn, str)
    local row = DataModel.MaterialGoods[tonumber(str)]
    if row then
      CommonTips.OpenGoodsTips(row.info.id, 1)
    end
  end,
  PrisonWarehouse_Group_ProductWarehouse_Group_ProductWarehouse_Group_Choose_Btn_Max_Click = function(btn, str)
    Controller:SelectProductBatchMode(2)
  end,
  PrisonWarehouse_Group_ProductWarehouse_Group_ProductWarehouse_Group_Choose_Btn_Batch_Click = function(btn, str)
    Controller:SelectProductBatchMode(1)
  end,
  PrisonWarehouse_Group_ProductWarehouse_Group_ProductWarehouse_Group_Expansion_Btn__Click = function(btn, str)
    DataModel.CurExpandPanelType = 2
    Controller:ClickExpandSpace(2)
  end,
  PrisonWarehouse_Group_ProductWarehouse_Group_ProductWarehouse_ScrollGrid_Warehouse_SetGrid = function(element, elementIndex)
    Controller:SetProductMaterialWarehouseItemElement(element, elementIndex)
  end,
  PrisonWarehouse_Group_ProductWarehouse_Group_ProductWarehouse_ScrollGrid_Warehouse_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local data = DataModel.GetGoodsDataByType(DataModel.GoodsPlaceType.Product)
    local idx = tonumber(str)
    if DataModel.CurExchangeType == DataModel.ExchangeType.MaterialAndProduct then
      if DataModel.ProductGoodsBatchMode == 1 then
        Controller:OpenBatchPanel(data[idx], idx, 2, DataModel.GoodsPlaceType.Product, DataModel.GoodsPlaceType.Material)
      else
        Controller:ExchangeGoods(DataModel.GoodsPlaceType.Product, DataModel.GoodsPlaceType.Material, idx, data[idx].num)
      end
    elseif DataModel.CurExchangeType == DataModel.ExchangeType.ProductAndTrain then
      if DataModel.ProductGoodsBatchMode == 1 then
        Controller:OpenBatchPanel(data[idx], idx, 2, DataModel.GoodsPlaceType.Product, DataModel.GoodsPlaceType.Train)
      else
        Controller:ExchangeGoods(DataModel.GoodsPlaceType.Product, DataModel.GoodsPlaceType.Train, tonumber(str), data[idx].num)
      end
    end
  end,
  PrisonWarehouse_Group_ProductWarehouse_Group_ProductWarehouse_ScrollGrid_Warehouse_Group_Item_Group_Item_Btn_Item_LongPress = function(btn, str)
    local row = DataModel.ProductGoods[tonumber(str)]
    if row then
      CommonTips.OpenGoodsTips(row.info.id, 1)
    end
  end,
  PrisonWarehouse_Group_btnTM_Btn_Unpick_Click = function(btn, str)
    Controller:ChangeExchangeType(DataModel.ExchangeType.MaterialAndTrain)
    DataModel.DealWithGoods()
  end,
  PrisonWarehouse_Group_btnTP_Btn_Unpick_Click = function(btn, str)
    Controller:ChangeExchangeType(DataModel.ExchangeType.ProductAndTrain)
    DataModel.DealWithGoods()
  end,
  PrisonWarehouse_Group_btnMP_Btn_Unpick_Click = function(btn, str)
    Controller:ChangeExchangeType(DataModel.ExchangeType.MaterialAndProduct)
    DataModel.DealWithGoods()
  end
}
return ViewFunction
