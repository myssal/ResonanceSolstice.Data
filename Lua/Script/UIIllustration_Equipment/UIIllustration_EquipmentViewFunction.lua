local View = require("UIIllustration_Equipment/UIIllustration_EquipmentView")
local DataModel = require("UIIllustration_Equipment/UIIllustration_EquipmentDataModel")
local Controller = require("UIIllustration_Equipment/UIIllustration_EquipmentController")
local ViewFunction = {
  Illustration_Equipment_Group_Card_NewScrollGrid_EquipmentCard_SetGrid = function(element, elementIndex)
    local row = DataModel.NowShowList[tonumber(elementIndex)]
    DataModel.Element[tonumber(elementIndex)] = element
    element.Btn_Card:SetClickParam(elementIndex)
    Controller:SetElement(element.Btn_Card, row, elementIndex)
  end,
  Illustration_Equipment_Group_Card_NewScrollGrid_EquipmentCard_Group_Item_Btn_Card_Click = function(btn, str)
    Controller:ClickEquipment(tonumber(str))
  end,
  Illustration_Equipment_Group_RightList_ScrollGrid_RightList_SetGrid = function(element, elementIndex)
    local row = DataModel.EnumEquipSideList[tonumber(elementIndex)]
    element.Btn_ArmamentType:SetClickParam(elementIndex)
    Controller:SetRightElement(element.Btn_ArmamentType, row, tonumber(elementIndex))
  end,
  Illustration_Equipment_Group_RightList_ScrollGrid_RightList_Group_Item_Btn_ArmamentType_Click = function(btn, str)
    Controller:ChooseRightIndex(tonumber(str))
  end,
  Illustration_Equipment_Group_TopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  Illustration_Equipment_Group_TopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  Illustration_Equipment_Group_TopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Illustration_Equipment_Group_TopLeft_Btn_Help_Click = function(btn, str)
  end,
  Illustration_Equipment_Group_TopRight_Btn_Acquiesce_Click = function(btn, str)
    DataModel.SortState.index = 1
    Controller:Click(View.Group_TopRight.Btn_Acquiesce)
  end,
  Illustration_Equipment_Group_TopRight_Btn_Rarity_Click = function(btn, str)
    DataModel.SortState.index = 2
    Controller:Click(View.Group_TopRight.Btn_Rarity)
  end,
  Illustration_Equipment_Group_TopRight_Btn_Screen_Click = function(btn, str)
    View.Group_Filter:SetActive(true)
  end,
  Illustration_Equipment_Group_Filter_Btn_Close_Click = function(btn, str)
    View.Group_Filter:SetActive(false)
  end,
  Illustration_Equipment_Group_Filter_Group_Type_Btn_All_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_Type, btn, 0)
  end,
  Illustration_Equipment_Group_Filter_Group_Type_Btn_T01_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_Type, btn, 1)
  end,
  Illustration_Equipment_Group_Filter_Group_Type_Btn_T02_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_Type, btn, 2)
  end,
  Illustration_Equipment_Group_Filter_Group_Type_Btn_T03_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_Type, btn, 3)
  end,
  Illustration_Equipment_Group_Filter_Group_Rarity_Btn_All_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_Rarity, btn, 0)
  end,
  Illustration_Equipment_Group_Filter_Group_Rarity_Btn_Rarity_01_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_Rarity, btn, 1)
  end,
  Illustration_Equipment_Group_Filter_Group_Rarity_Btn_Rarity_02_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_Rarity, btn, 2)
  end,
  Illustration_Equipment_Group_Filter_Group_Rarity_Btn_Rarity_03_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_Rarity, btn, 3)
  end,
  Illustration_Equipment_Group_Filter_Group_Rarity_Btn_Rarity_04_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_Rarity, btn, 4)
  end,
  Illustration_Equipment_Group_Filter_Group_State_Btn_All_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_State, btn, 0)
  end,
  Illustration_Equipment_Group_Filter_Group_State_Btn_S01_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_State, btn, 1)
  end,
  Illustration_Equipment_Group_Filter_Group_State_Btn_S02_Click = function(btn, str)
    Controller:ScreenBtn(View.Group_Filter.Group_State, btn, 2)
  end,
  Illustration_Equipment_Group_Filter_Btn_OK_Click = function(btn, str)
    Controller:Filter()
    View.Group_Filter:SetActive(false)
    Controller:RefreshData()
  end,
  Illustration_Equipment_Group_Filter_Btn_Cancel_Click = function(btn, str)
    View.Group_Filter:SetActive(false)
  end,
  Illustration_Equipment_Group_Affix_Group_TopLeft_Btn_Return_Click = function(btn, str)
    View.self:PlayAnim("In")
    Controller:ExitAffixBook()
  end,
  Illustration_Equipment_Group_Affix_Group_TopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  Illustration_Equipment_Group_Affix_Group_TopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Illustration_Equipment_Group_Affix_Group_TopLeft_Btn_Help_Click = function(btn, str)
  end,
  Illustration_Equipment_Group_Affix_Group_TopLeft_Btn_Button_Click = function(btn, str)
    Controller:SwitchMaxLevelStats()
  end,
  Illustration_Equipment_Group_Affix_ScrollGrid_Affix_SetGrid = function(element, elementIndex)
    local row = DataModel.CurAffixList[elementIndex]
    local cfg = PlayerData:GetFactoryData(row)
    if cfg then
      if cfg.minAttrSN and cfg.maxAttrSN then
        local showValue = DataModel.CurMaxLevelStats == 0 and PlayerData:GetPreciseDecimalFloor(tonumber(cfg.minAttrSN * cfg.CommonNum), cfg.floatNum) or PlayerData:GetPreciseDecimalFloor(tonumber(cfg.maxAttrSN * cfg.CommonNum), cfg.floatNum)
        element.Txt_Details:SetText(string.format(cfg.description, showValue))
      else
        element.Txt_Details:SetText(cfg.description)
      end
    end
  end,
  Illustration_Equipment_Group_Affix_Group_TopRight_Btn_All_Click = function(btn, str)
    Controller:ChooseAffixPartIndex(1)
  end,
  Illustration_Equipment_Group_Affix_Group_TopRight_Btn_Weapon_Click = function(btn, str)
    Controller:ChooseAffixPartIndex(2)
  end,
  Illustration_Equipment_Group_Affix_Group_TopRight_Btn_Armor_Click = function(btn, str)
    Controller:ChooseAffixPartIndex(3)
  end,
  Illustration_Equipment_Group_Affix_Group_TopRight_Btn_Pendant_Click = function(btn, str)
    Controller:ChooseAffixPartIndex(4)
  end,
  Illustration_Equipment_Btn_Affix_Click = function(btn, str)
    View.self:PlayAnim("AffixIn")
    Controller:EnterAffixBook()
    Controller:RefreshAffixData()
  end
}
return ViewFunction
