local View = require("UIRoleHire/UIRoleHireView")
local DataModel = require("UIRoleHire/UIRoleHireDataModel")
local BtnController = require("UIRoleHire/UIRoleHireController")
local ViewFunction = {
  RoleHire_Btn_Back_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  RoleHire_Btn_Hire_Click = function(btn, str)
    BtnController.OnHireClick()
  end,
  RoleHire_Group_Coin_Btn_GoldCoin_Click = function(btn, str)
    local allCfg = PlayerData:GetFactoryData(89400002, "CubeRogueFactory")
    CommonTips.OpenCubeRogueItemDetails({
      id = allCfg.coinId
    })
  end,
  RoleHire_Group_SuccessTip_Btn_Close_Click = function(btn, str)
    View.Group_SuccessTip:SetActive(false)
  end,
  RoleHire_Group_SuccessTip_ScrollGrid_Role_SetGrid = function(element, elementIndex)
    local roleData = PlayerData.ServerData.roles[tostring(DataModel.newRoles[elementIndex])]
    DataModel.RefreshBreakIndex = elementIndex
    BtnController.SetElement(element, roleData)
  end,
  RoleHire_ScrollGrid_Middle_SetGrid = function(element, elementIndex)
    local roleData = PlayerData.ServerData.roles[DataModel.Roles[elementIndex]]
    element.Btn_Click:SetClickParam(elementIndex)
    DataModel.RefreshBreakIndex = elementIndex
    BtnController.SetElement(element, roleData)
  end,
  RoleHire_ScrollGrid_Middle_Group_Character_Group_Break_StaticGrid_BK_SetGrid = function(element, elementIndex)
    local roleData = PlayerData.ServerData.roles[DataModel.Roles[DataModel.RefreshBreakIndex]]
    element.Img_On:SetActive(false)
    if elementIndex <= roleData.awake_lv then
      element.Img_On:SetActive(true)
    end
  end,
  RoleHire_ScrollGrid_Middle_Group_Character_Btn_Click_Click = function(btn, str)
    BtnController.SelectRole(tonumber(DataModel.Roles[tonumber(str)]))
  end,
  RoleHire_Group_TopRight_Btn_Level_Click = function(btn, str)
    BtnController:Click(View.Group_TopRight.Btn_Level)
  end,
  RoleHire_Group_TopRight_Btn_Rarity_Click = function(btn, str)
    BtnController:Click(View.Group_TopRight.Btn_Rarity)
  end,
  RoleHire_Group_TopRight_Btn_Time_Click = function(btn, str)
    BtnController:Click(View.Group_TopRight.Btn_Time)
  end,
  RoleHire_Group_TopRight_Btn_Screen_Click = function(btn, str)
    BtnController.Open_Screen_Chapter(true)
  end,
  RoleHire_Screen_Chapter_New_Btn_BG_Click = function(btn, str)
  end,
  RoleHire_Screen_Chapter_New_Group_Group_Btn_All_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Group, btn, 0)
  end,
  RoleHire_Screen_Chapter_New_Group_Group_Btn_C01_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Group, btn, 1)
  end,
  RoleHire_Screen_Chapter_New_Group_Group_Btn_C02_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Group, btn, 2)
  end,
  RoleHire_Screen_Chapter_New_Group_Group_Btn_C03_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Group, btn, 3)
  end,
  RoleHire_Screen_Chapter_New_Group_Group_Btn_C04_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Group, btn, 4)
  end,
  RoleHire_Screen_Chapter_New_Group_Group_Btn_C05_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Group, btn, 5)
  end,
  RoleHire_Screen_Chapter_New_Group_Group_Btn_C06_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Group, btn, 6)
  end,
  RoleHire_Screen_Chapter_New_Group_Group_Btn_C07_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Group, btn, 7)
  end,
  RoleHire_Screen_Chapter_New_Group_Group_Btn_C08_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Group, btn, 8)
  end,
  RoleHire_Screen_Chapter_New_Group_Group_Btn_C09_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Group, btn, 9)
  end,
  RoleHire_Screen_Chapter_New_Group_Rarity_Btn_All_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Rarity, btn, 0)
  end,
  RoleHire_Screen_Chapter_New_Group_Rarity_Btn_G01_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Rarity, btn, 5)
  end,
  RoleHire_Screen_Chapter_New_Group_Rarity_Btn_G02_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Rarity, btn, 4)
  end,
  RoleHire_Screen_Chapter_New_Group_Rarity_Btn_G03_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Rarity, btn, 3)
  end,
  RoleHire_Screen_Chapter_New_Group_Rarity_Btn_G04_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Rarity, btn, 2)
  end,
  RoleHire_Screen_Chapter_New_Group_Rarity_Btn_G05_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Rarity, btn, 1)
  end,
  RoleHire_Screen_Chapter_New_Group_Tag_Btn_All_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Tag, btn, 0)
  end,
  RoleHire_Screen_Chapter_New_Group_Tag_Btn_Occupation_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Tag, btn, 1)
  end,
  RoleHire_Screen_Chapter_New_Group_Tag_Btn_Hit_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Tag, btn, 2)
  end,
  RoleHire_Screen_Chapter_New_Group_Tag_Btn_Technology_Click = function(btn, str)
    BtnController.ScreenBtn(View.Screen_Chapter_New.Group_Tag, btn, 3)
  end,
  RoleHire_Screen_Chapter_New_Group_Tag_Img_Bg_ScrollGrid_Tag_SetGrid = function(element, elementIndex)
    BtnController.SetSpeacialElement(element, elementIndex)
  end,
  RoleHire_Screen_Chapter_New_Group_Tag_Img_Bg_ScrollGrid_Tag_Group_Item_Btn_Tag_Click = function(btn, str)
    BtnController.ClickSpecialTitle(tonumber(str))
  end,
  RoleHire_Screen_Chapter_New_Btn_OK_Click = function(btn, str)
    BtnController.Open_Screen_Chapter(false)
    BtnController.Filter()
  end,
  RoleHire_Screen_Chapter_New_Btn_Cancel_Click = function(btn, str)
    BtnController.Open_Screen_Chapter(false)
  end,
  RoleHire_Group_SuccessTip_ScrollGrid_Role_Group_Character_Group_Break_StaticGrid_BK_SetGrid = function(element, elementIndex)
    local roleData = PlayerData.ServerData.roles[tostring(DataModel.newRoles[DataModel.RefreshBreakIndex])]
    element.Img_On:SetActive(false)
    if elementIndex <= roleData.awake_lv then
      element.Img_On:SetActive(true)
    end
  end,
  RoleHire_Group_SuccessTip_ScrollGrid_Role_Group_Character_Btn_Click_Click = function(btn, str)
  end
}
return ViewFunction
