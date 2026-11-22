local View = require("UIWitchesMap/UIWitchesMapView")
local Controller = require("UIWitchesMap/UIWitchesMapController")
local DataModel = require("UIWitchesMap/UIWitchesMapDataModel")
local ViewFunction = {
  WitchesMap_ScrollView__Viewport_Content_Img_Map_StaticGrid__SetGrid = function(element, elementIndex)
    element.Img_player:SetActive(DataModel.currentUserIndex == elementIndex)
    element.Img_arrived:SetActive(DataModel.arrivedList[elementIndex])
    element.Group_Car.self:SetActive(DataModel.floatPathHave[elementIndex] and DataModel.floatPathHave[elementIndex].isCar and DataModel.isShowFloat)
    element.Group_Car.Img_Arrow:SetActive(false)
    if DataModel.currentFloatIndex == elementIndex then
      element.Group_Car.Img_Arrow:SetActive(true)
      element.Group_Car.Img_Arrow:SetLocalEulerAngles(DataModel.currentFloatDirection)
    end
    element.Img_carroute:SetActive(DataModel.floatPathHave[elementIndex] and DataModel.currentFloatIndex ~= elementIndex and DataModel.isShowFloat)
    local row = DataModel.parkGridList[elementIndex]
    if row == nil then
      element.self:SetActive(false)
      return
    end
    element.self:SetActive(row.isShow)
    if DataModel.eventIconList[elementIndex] then
      element.Img_:SetSprite(DataModel.eventIconList[elementIndex])
    end
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building1_Btn__Click = function(btn, str)
    Controller:ClickSealBtn(1)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building2_Btn__Click = function(btn, str)
    Controller:ClickSealBtn(2)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building3_Btn__Click = function(btn, str)
    Controller:ClickSealBtn(3)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building4_Btn__Click = function(btn, str)
    Controller:ClickSealBtn(4)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building5_Btn__Click = function(btn, str)
    Controller:ClickSealBtn(5)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building6_Btn__Click = function(btn, str)
    Controller:ClickSealBtn(6)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building7_Btn__Click = function(btn, str)
    Controller:ClickSealBtn(7)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building8_Btn__Click = function(btn, str)
    Controller:ClickSealBtn(8)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building9_Btn__Click = function(btn, str)
    Controller:ClickSealBtn(9)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building10_Btn__Click = function(btn, str)
    Controller:ClickSealBtn(10)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_StaticGrid_Start_SetGrid = function(element, elementIndex)
    element.self:SetActive(DataModel.startIndex == elementIndex)
    element.Img_player:SetActive(DataModel.isStartPlayer)
  end,
  WitchesMap_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  WitchesMap_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  WitchesMap_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  WitchesMap_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  WitchesMap_Group_BuildingInfo_Btn_Close_Click = function(btn, str)
    View.Group_BuildingInfo.self:SetActive(false)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building1_Group_Seal_Btn_Color_Click = function(btn, str)
    Controller:ClickSealColor(1)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building2_Group_Seal_Btn_Color_Click = function(btn, str)
    Controller:ClickSealColor(2)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building3_Group_Seal_Btn_Color_Click = function(btn, str)
    Controller:ClickSealColor(3)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building4_Group_Seal_Btn_Color_Click = function(btn, str)
    Controller:ClickSealColor(4)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building5_Group_Seal_Btn_Color_Click = function(btn, str)
    Controller:ClickSealColor(5)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building6_Group_Seal_Btn_Color_Click = function(btn, str)
    Controller:ClickSealColor(6)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building7_Group_Seal_Btn_Color_Click = function(btn, str)
    Controller:ClickSealColor(7)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building8_Group_Seal_Btn_Color_Click = function(btn, str)
    Controller:ClickSealColor(8)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building9_Group_Seal_Btn_Color_Click = function(btn, str)
    Controller:ClickSealColor(9)
  end,
  WitchesMap_ScrollView__Viewport_Content_Img_Map_Group_Building10_Group_Seal_Btn_Color_Click = function(btn, str)
    Controller:ClickSealColor(10)
  end
}
return ViewFunction
