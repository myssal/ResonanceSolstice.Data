local View = require("UITransitCenter/UITransitCenterView")
local DataModel = require("UITransitCenter/UITransitCenterDataModel")
local Controller = require("UITransitCenter/UITransitCenterController")
local ViewFunction = {
  TransitCenter_Group_Transit_Btn_Prisoner_Click = function(btn, str)
    Controller:EnterTransPrisoner()
  end,
  TransitCenter_Group_Transit_Btn_PrisonerUnavailable_Click = function(btn, str)
    local can, code = DataModel.CheckCanTransPrisoner()
    if not can then
      local txt = DataModel.PrisonerFailTips[code]
      if txt then
        CommonTips.OpenTips(GetText(txt))
        return
      end
    end
  end,
  TransitCenter_Group_Transit_Btn_Goods_Click = function(btn, str)
    Controller:EnterTransGoods()
  end,
  TransitCenter_Group_Transit_Btn_GoodsUnavailable_Click = function(btn, str)
    Controller:EnterTransGoods()
  end,
  TransitCenter_Group_Fleet_ScrollGrid__SetGrid = function(element, elementIndex)
    Controller:SetFleetElement(element, elementIndex)
  end,
  TransitCenter_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    View.self:CloseUI()
  end,
  TransitCenter_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  TransitCenter_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  TransitCenter_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80304356}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end,
  TransitCenter_Group_TransitGoods_Btn_Close_Click = function(btn, str)
    View.Group_TransitGoods:SetActive(false)
  end,
  TransitCenter_Group_TransitGoods_Group_PickRoute_Btn_Confirm_Click = function(btn, str)
    Controller:ConfirmTransit()
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_Group_Switch_Group_Material_Btn_Off_Click = function(btn, str)
    Controller:SwitchWarehouseTab(1)
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_Group_Switch_Group_Product_Btn_Off_Click = function(btn, str)
    Controller:SwitchWarehouseTab(2)
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_Group_Choose_Btn_Max_Click = function(btn, str)
    Controller:SwitchBatchType(2)
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_Group_Choose_Btn_Batch_Click = function(btn, str)
    Controller:SwitchBatchType(1)
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_ScrollGrid_Item_SetGrid = function(element, elementIndex)
    Controller:SetWarehouseElement(element, elementIndex)
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_ScrollGrid_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:ClickWarehouseGoods(tonumber(str))
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_Group_Batch_Btn_BG_Click = function(btn, str)
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_Group_Batch_Group_Panel_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_Group_Batch_Group_Panel_Btn_Min_Click = function(btn, str)
    DataModel.BatchNum = 1
    View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BatchNum)
    View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.BatchNum)
    View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Gold.Txt_Num:SetText(math.floor(DataModel.BatchNum * DataModel.TransitGoodsCost * (DataModel.SelectRouteDistance / 100)))
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_Group_Batch_Group_Panel_Btn_Dec_Click = function(btn, str)
    if DataModel.BatchNum - 1 < View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Slider.Slider_Value.slider.minValue then
      return
    end
    DataModel.BatchNum = DataModel.BatchNum - 1
    View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BatchNum)
    View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.BatchNum)
    View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Gold.Txt_Num:SetText(math.floor(DataModel.BatchNum * DataModel.TransitGoodsCost * (DataModel.SelectRouteDistance / 100)))
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_Group_Batch_Group_Panel_Group_Slider_Slider_Value_Slider = function(slider, value)
    DataModel.BatchNum = DataModel.NumRound(value)
    View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.BatchNum)
    View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Gold.Txt_Num:SetText(math.floor(DataModel.BatchNum * DataModel.TransitGoodsCost * (DataModel.SelectRouteDistance / 100)))
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_Group_Batch_Group_Panel_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_Group_Batch_Group_Panel_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_Group_Batch_Group_Panel_Btn_Add_Click = function(btn, str)
    if DataModel.BatchNum + 1 > View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Slider.Slider_Value.slider.maxValue then
      return
    end
    DataModel.BatchNum = DataModel.BatchNum + 1
    View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BatchNum)
    View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.BatchNum)
    View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Gold.Txt_Num:SetText(math.floor(DataModel.BatchNum * DataModel.TransitGoodsCost * (DataModel.SelectRouteDistance / 100)))
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_Group_Batch_Group_Panel_Btn_Max_Click = function(btn, str)
    DataModel.BatchNum = math.floor(View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Slider.Slider_Value.slider.maxValue + 0.5)
    View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BatchNum)
    View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.BatchNum)
    View.Group_TransitGoods.Group_Warehouse.Group_Batch.Group_Panel.Group_Gold.Txt_Num:SetText(math.floor(DataModel.BatchNum * DataModel.TransitGoodsCost * (DataModel.SelectRouteDistance / 100)))
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_Group_Batch_Btn_Cancel_Click = function(btn, str)
    View.Group_TransitGoods.Group_Warehouse.Group_Batch.self:SetActive(false)
  end,
  TransitCenter_Group_TransitGoods_Group_Warehouse_Group_Batch_Btn_Confirm_Click = function(btn, str)
    Controller:ConfirmBatchClick()
  end,
  TransitCenter_Group_Route_ScrollView__Viewport_Content_StaticGrid_Locked_SetGrid = function(element, elementIndex)
    Controller:SetUnlockRouteElement(element, elementIndex)
  end,
  TransitCenter_Group_Route_ScrollView__Viewport_Content_StaticGrid_Locked_Group_Item_Group_lock_Btn__Click = function(btn, str)
  end,
  TransitCenter_Group_Route_ScrollView__Viewport_Content_StaticGrid_Unlocked_SetGrid = function(element, elementIndex)
    Controller:SetLockRouteElement(element, elementIndex)
  end,
  TransitCenter_Group_Route_ScrollView__Viewport_Content_StaticGrid_Unlocked_Group_Item_Group_lock_Btn__Click = function(btn, str)
    Controller:TryUnlockRoute(tonumber(str))
  end,
  TransitCenter_Group_Route_Group_Item_Group_lock_Btn__Click = function(btn, str)
  end,
  TransitCenter_Group_Fleet_ScrollGrid__Group_Item_Group_Locked_Group_Unavailable_Btn_Unavailable_Click = function(btn, str)
    CommonTips.OpenTips(string.format(GetText(80607636), DataModel.FleetCount2LevelRecord[tonumber(str)]))
  end,
  TransitCenter_Group_Fleet_ScrollGrid__Group_Item_Group_Locked_Group_Available_Btn_Available_Click = function(btn, str)
    Controller:TryUnlockFleet()
  end,
  TransitCenter_Group_TransitGoods_Group_PickRoute_ScrollGrid__SetGrid = function(element, elementIndex)
    Controller:SetPickRouteElement(element, elementIndex)
  end,
  TransitCenter_Group_TransitGoods_Group_PickRoute_ScrollGrid__Group_PickPlace_GroupInfo_Btn_Pick_Click = function(btn, str)
    Controller:SelectPickRoute(tonumber(str))
  end,
  TransitCenter_Group_TransitGoods_Group_PickRoute_Btn_CantConfirm_Click = function(btn, str)
  end,
  TransitCenter_Group_TransitPrisoners_Btn_Close_Click = function(btn, str)
    View.Group_TransitPrisoners:SetActive(false)
  end,
  TransitCenter_Group_TransitPrisoners_ScrollGrid_Coach_SetGrid = function(element, elementIndex)
    Controller:SetPrisonerElement(element, elementIndex)
  end,
  TransitCenter_Group_TransitPrisoners_ScrollGrid_Coach_Group_Item_Btn_Pick_Click = function(btn, str)
    Controller:ClickPrisonerElement(tonumber(str))
  end,
  TransitCenter_Group_TransitPrisoners_ScrollGrid_Coach_Group_Item_Btn_Release_Click = function(btn, str)
    Controller:ReleasePrisoner(tonumber(str))
  end,
  TransitCenter_Group_TransitPrisoners_Btn_Confirm_Click = function(btn, str)
    Controller:ConfirmTransitPrisoner()
  end,
  TransitCenter_Group_TransitPrisoners_Btn_CantConfirm_Click = function(btn, str)
  end,
  TransitCenter_Group_TransitPrisoners_Btn_All_Click = function(btn, str)
    Controller:TrySelectAllPrisoner()
  end
}
return ViewFunction
