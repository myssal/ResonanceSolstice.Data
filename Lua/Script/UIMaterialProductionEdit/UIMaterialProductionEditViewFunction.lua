local View = require("UIMaterialProductionEdit/UIMaterialProductionEditView")
local DataModel = require("UIMaterialProductionEdit/UIMaterialProductionEditDataModel")
local Controller = require("UIMaterialProductionEdit/UIMaterialProductionEditController")
local ViewFunction = {
  MaterialProductionEdit_Btn_Left_Click = function(btn, str)
  end,
  MaterialProductionEdit_Btn_Light_Click = function(btn, str)
  end,
  MaterialProductionEdit_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if UIManager:IsPanelOpened("UI/Prison/Overview/Prison") then
      local UIPrisonDataModel = require("UIPrison/UIPrisonDataModel")
      UIPrisonDataModel.RefreshMaterialProductRoom()
    end
    UIManager:GoBack()
  end,
  MaterialProductionEdit_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  MaterialProductionEdit_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  MaterialProductionEdit_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80304355}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end,
  MaterialProductionEdit_Group_Right_Img_Top_ScrollGrid_Toplist_SetGrid = function(element, elementIndex)
    Controller:SetFormulaElement(element, elementIndex)
  end,
  MaterialProductionEdit_Group_Right_Img_Top_ScrollGrid_Toplist_Group_Item_Btn_Choose_Click = function(btn, str)
    Controller:SelectFormula(tonumber(str))
  end,
  MaterialProductionEdit_Group_Right_Img_Top_ScrollGrid_Toplist_Group_Item_Group_Lock_Btn_Getway_Click = function(btn, str)
    local scalex = UIManager:GetCanvas().transform.localScale.x
    local posx = btn.transform.position.x / scalex
    Controller:OpenGetWayPanel(tonumber(str), posx)
  end,
  MaterialProductionEdit_Group_Right_Group_PrisonerManage_ScrollGrid_PrisonerManageList_SetGrid = function(element, elementIndex)
    Controller:SetPlacedPrisonerElement(element, elementIndex)
  end,
  MaterialProductionEdit_Group_Right_Group_PrisonerNum_Btn_All_Click = function(btn, str)
    Controller:OpenPrisonerList()
  end,
  MaterialProductionEdit_Group_Left_Group_Producing_Btn_Stop_Click = function(btn, str)
    Controller:TryStopProduct()
  end,
  MaterialProductionEdit_Group_Left_Group_Producing_Btn_Accelerate_Click = function(btn, str)
    Controller:TrySpeedProduct()
  end,
  MaterialProductionEdit_Group_Left_Group_Prepare_Btn_Start_Click = function(btn, str)
    Controller:TryStartProduct()
  end,
  MaterialProductionEdit_Group_Left_Group_Prepare_Btn_CantStart_Click = function(btn, str)
  end,
  MaterialProductionEdit_Group_Left_Group_Cost_Btn_Deposit_Click = function(btn, str)
    Controller:OpenBatchPanel()
  end,
  MaterialProductionEdit_Group_Left_Group_Product_Btn_Get_Click = function(btn, str)
    Controller:TryGetProduction()
  end,
  MaterialProductionEdit_PrisonerListManage_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    View.PrisonerListManage:SetActive(false)
    DataModel.SelectPrisoner = {}
  end,
  MaterialProductionEdit_PrisonerListManage_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  MaterialProductionEdit_PrisonerListManage_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  MaterialProductionEdit_PrisonerListManage_Btn_Passenger_Click = function(btn, str)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_TopRightPrison_Btn_Level_Click = function(btn, str)
    DataModel.SortState.index = 1
    Controller:Click(View.PrisonerListManage.Group_TopRightPrison.Btn_Level)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_TopRightPrison_Btn_Time_Click = function(btn, str)
    DataModel.SortState.index = 2
    Controller:Click(View.PrisonerListManage.Group_TopRightPrison.Btn_Time)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_TopRightPrison_Btn_Screen_Click = function(btn, str)
    View.PrisonerListManage.Group_Screen:SetActive(true)
  end,
  MaterialProductionEdit_PrisonerListManage_ScrollGrid_Prison_SetGrid = function(element, elementIndex)
    Controller:SetPrisonerListElement(element, elementIndex)
  end,
  MaterialProductionEdit_PrisonerListManage_ScrollGrid_Prison_Group_Item_Group_Character_Btn_Mask_Click = function(btn, str)
  end,
  MaterialProductionEdit_PrisonerListManage_ScrollGrid_Prison_Group_Item_Group_Character_Btn_Item_Click = function(btn, str)
    Controller:SelectPrisoner(tonumber(str))
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Btn_BG_Click = function(btn, str)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Working_Btn_All_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Working, btn, 0)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Working_Btn_C01_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Working, btn, 1)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Working_Btn_C02_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Working, btn, 2)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Working_Btn_C03_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Working, btn, 3)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Working_Btn_C04_Click = function(btn, str)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_All_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 0)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C01_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 1)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C02_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 2)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C03_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 3)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C04_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 4)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C05_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 5)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C06_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 6)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C07_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 7)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C08_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 8)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C09_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 9)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C10_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 10)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C11_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 11)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C12_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 12)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C13_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 13)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_All_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 0)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G01_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 1)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G02_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 2)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G03_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 3)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G04_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 4)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G05_Click = function(btn, str)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G06_Click = function(btn, str)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G07_Click = function(btn, str)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G08_Click = function(btn, str)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G09_Click = function(btn, str)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Rarity_Btn_All_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 0)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Rarity_Btn_R01_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 1)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Rarity_Btn_R02_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 2)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Rarity_Btn_R03_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 3)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Group_Rarity_Btn_R04_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 4)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Btn_OK_Click = function(btn, str)
    View.PrisonerListManage.Group_Screen:SetActive(false)
    Controller:RefreshPrisonerList()
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Screen_Btn_Cancel_Click = function(btn, str)
    View.PrisonerListManage.Group_Screen:SetActive(false)
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Detail_Btn_Confirm_Click = function(btn, str)
    Controller:ConfirmSelectPrisoner()
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Detail_Btn_All_Click = function(btn, str)
    Controller:OneBtnChooseAll()
  end,
  MaterialProductionEdit_PrisonerListManage_Group_Detail_Btn_AllCancel_Click = function(btn, str)
    Controller:OneBtnCancelAll()
  end,
  MaterialProductionEdit_BuyTips_Btn_BG_Click = function(btn, str)
    View.BuyTips:SetActive(false)
  end,
  MaterialProductionEdit_BuyTips_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  MaterialProductionEdit_BuyTips_Img_Furniture_Btn_ShowTips_Click = function(btn, str)
  end,
  MaterialProductionEdit_BuyTips_Btn_Min_Click = function(btn, str)
    DataModel.BatchNum = 1
    View.BuyTips.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BatchNum)
    View.BuyTips.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.BatchNum)
    View.BuyTips.Group_Slider.Group_Num.Txt_Possess:SetText(DataModel.NumRound(View.BuyTips.Group_Slider.Slider_Value.slider.maxValue))
  end,
  MaterialProductionEdit_BuyTips_Btn_Dec_Click = function(btn, str)
    if DataModel.BatchNum - 1 < View.BuyTips.Group_Slider.Slider_Value.slider.minValue then
      return
    end
    DataModel.BatchNum = DataModel.BatchNum - 1
    View.BuyTips.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BatchNum)
    View.BuyTips.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.BatchNum)
    View.BuyTips.Group_Slider.Group_Num.Txt_Possess:SetText(DataModel.NumRound(View.BuyTips.Group_Slider.Slider_Value.slider.maxValue))
  end,
  MaterialProductionEdit_BuyTips_Group_Slider_Slider_Value_Slider = function(slider, value)
    DataModel.BatchNum = DataModel.NumRound(value)
    View.BuyTips.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.BatchNum)
    View.BuyTips.Group_Slider.Group_Num.Txt_Possess:SetText(DataModel.NumRound(View.BuyTips.Group_Slider.Slider_Value.slider.maxValue))
  end,
  MaterialProductionEdit_BuyTips_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  MaterialProductionEdit_BuyTips_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  MaterialProductionEdit_BuyTips_Btn_Add_Click = function(btn, str)
    if DataModel.BatchNum + 1 > View.BuyTips.Group_Slider.Slider_Value.slider.maxValue then
      return
    end
    DataModel.BatchNum = DataModel.BatchNum + 1
    View.BuyTips.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BatchNum)
    View.BuyTips.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.BatchNum)
    View.BuyTips.Group_Slider.Group_Num.Txt_Possess:SetText(DataModel.NumRound(View.BuyTips.Group_Slider.Slider_Value.slider.maxValue))
  end,
  MaterialProductionEdit_BuyTips_Btn_Max_Click = function(btn, str)
    DataModel.BatchNum = math.floor(View.BuyTips.Group_Slider.Slider_Value.slider.maxValue + 0.5)
    View.BuyTips.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BatchNum)
    View.BuyTips.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.BatchNum)
    View.BuyTips.Group_Slider.Group_Num.Txt_Possess:SetText(DataModel.NumRound(View.BuyTips.Group_Slider.Slider_Value.slider.maxValue))
  end,
  MaterialProductionEdit_BuyTips_Btn_Cancel_Click = function(btn, str)
    View.BuyTips:SetActive(false)
  end,
  MaterialProductionEdit_BuyTips_Btn_Sale_Click = function(btn, str)
    Controller:TryStorageCoin()
  end,
  MaterialProductionEdit_Group_Warehouse_Btn__Click = function(btn, str)
    Controller:JumpToWarehouse()
  end,
  MaterialProductionEdit_Group_Right_Group_Pick_Btn_Diamond_Click = function(btn, str)
    if DataModel.PrisonerTab == 1 then
      return
    end
    DataModel.PrisonerTab = 1
    Controller:RefreshPlacedPrisonerList()
  end,
  MaterialProductionEdit_Group_Right_Group_Pick_Btn_Item_Click = function(btn, str)
    if DataModel.PrisonerTab == 2 then
      return
    end
    DataModel.PrisonerTab = 2
    Controller:RefreshPlacedPrisonerList()
  end
}
return ViewFunction
