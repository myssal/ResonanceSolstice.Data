local View = require("UIIllustration_Source/UIIllustration_SourceView")
local DataModel = require("UIIllustration_Source/UIIllustration_SourceDataModel")
local Controller = require("UIIllustration_Source/UIIllustration_SourceController")
local ViewFunction = {
  Illustration_Source_Group_Card_NewScrollGrid_SourceCard_SetGrid = function(element, elementIndex)
    local row = DataModel.NowShowList[tonumber(elementIndex)]
    DataModel.Element[tonumber(elementIndex)] = element
    element.Btn_Card:SetClickParam(elementIndex)
    Controller:SetElement(element.Btn_Card, row, elementIndex)
  end,
  Illustration_Source_Group_Card_NewScrollGrid_SourceCard_Group_Item_Btn_Card_Click = function(btn, str)
    Controller:ClickSource(tonumber(str))
  end,
  Illustration_Source_Group_RightList_ScrollGrid_RightList_SetGrid = function(element, elementIndex)
    local row = DataModel.EnumEnemyCampList[tonumber(elementIndex)]
    element.Btn_ArmamentType:SetClickParam(elementIndex)
    Controller:SetRightElement(element.Btn_ArmamentType, row, tonumber(elementIndex))
  end,
  Illustration_Source_Group_RightList_ScrollGrid_RightList_Group_Item_Btn_ArmamentType_Click = function(btn, str)
    Controller:ChooseRightIndex(tonumber(str))
  end,
  Illustration_Source_Group_TopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  Illustration_Source_Group_TopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  Illustration_Source_Group_TopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Illustration_Source_Group_TopLeft_Btn_Help_Click = function(btn, str)
  end,
  Illustration_Source_Group_TopRight_Btn_Acquiesce_Click = function(btn, str)
    DataModel.SortState.index = 1
    Controller:Click(View.Group_TopRight.Btn_Acquiesce)
  end,
  Illustration_Source_Group_TopRight_Btn_Rarity_Click = function(btn, str)
    DataModel.SortState.index = 2
    Controller:Click(View.Group_TopRight.Btn_Rarity)
  end,
  Illustration_Source_Group_TopRight_Btn_Screen_Click = function(btn, str)
    View.Group_Filter:SetActive(true)
  end,
  Illustration_Source_Group_Filter_Btn_Close_Click = function(btn, str)
    View.Group_Filter:SetActive(false)
  end,
  Illustration_Source_Group_Filter_Group_Rarity_Btn_All_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_Rarity, btn, 0)
  end,
  Illustration_Source_Group_Filter_Group_Rarity_Btn_Rarity_01_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_Rarity, btn, 1)
  end,
  Illustration_Source_Group_Filter_Group_Rarity_Btn_Rarity_02_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_Rarity, btn, 2)
  end,
  Illustration_Source_Group_Filter_Group_Rarity_Btn_Rarity_03_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_Rarity, btn, 3)
  end,
  Illustration_Source_Group_Filter_Group_Rarity_Btn_Rarity_04_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_Rarity, btn, 4)
  end,
  Illustration_Source_Group_Filter_Group_Rarity_Btn_Rarity_05_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_Rarity, btn, 5)
  end,
  Illustration_Source_Group_Filter_Btn_OK_Click = function(btn, str)
    Controller:Filter()
    View.Group_Filter:SetActive(false)
    Controller:RefreshData()
  end,
  Illustration_Source_Group_Filter_Btn_Cancel_Click = function(btn, str)
    View.Group_Filter:SetActive(false)
  end
}
return ViewFunction
