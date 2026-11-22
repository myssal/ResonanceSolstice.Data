local View = require("UICubeWarehouse/UICubeWarehouseView")
local DataModel = require("UICubeWarehouse/UICubeWarehouseDataModel")
local Controller = require("UICubeWarehouse/UICubeWarehouseController")
local ViewFunction = {
  CubeWarehouse_Group_Buff_StaticGrid_List_SetGrid = function(element, elementIndex)
    Controller:OnSetBuffTypeGrid(element, elementIndex)
  end,
  CubeWarehouse_Group_Buff_StaticGrid_List_Group_Item_Btn__Click = function(btn, str)
    Controller:SetBuffFilter(tonumber(str))
  end,
  CubeWarehouse_Group_Buff_Group_Item_Btn__Click = function(btn, str)
  end,
  CubeWarehouse_Group_Weapon_Group_Quality_Group_All_Btn__Click = function(btn, str)
    Controller:SetWeaponFilterMode("all")
  end,
  CubeWarehouse_Group_Weapon_Group_Quality_Group_Blue_Btn__Click = function(btn, str)
    Controller:SetWeaponFilterMode("Blue")
  end,
  CubeWarehouse_Group_Weapon_Group_Quality_Group_Purple_Btn__Click = function(btn, str)
    Controller:SetWeaponFilterMode("Purple")
  end,
  CubeWarehouse_Group_Weapon_Group_Quality_Group_Golden_Btn__Click = function(btn, str)
    Controller:SetWeaponFilterMode("Golden")
  end,
  CubeWarehouse_Group_Weapon_Group_Quality_Group_Orange_Btn__Click = function(btn, str)
    Controller:SetWeaponFilterMode("Orange")
  end,
  CubeWarehouse_Group_Weapon_Group_Quality_Group_Negative_Btn__Click = function(btn, str)
    Controller:SetWeaponFilterMode("negative")
  end,
  CubeWarehouse_Group_Weapon_Group_Bottom_ScrollGrid_Weapon_SetGrid = function(element, elementIndex)
  end,
  CubeWarehouse_Group_Top_Group_Buff_Btn__Click = function(btn, str)
    Controller:OnClickTopTab(1)
  end,
  CubeWarehouse_Group_Top_Group_Weapon_Btn__Click = function(btn, str)
    Controller:OnClickTopTab(2)
  end,
  CubeWarehouse_Group_Top_Group_Team_Btn__Click = function(btn, str)
    Controller:OnClickTopTab(3)
  end,
  CubeWarehouse_Group_Coin_Btn_GoldCoin_Click = function(btn, str)
    CommonTips.OpenCubeRogueItemDetails({
      id = DataModel.cubeCA.coinId
    })
  end,
  CubeWarehouse_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  CubeWarehouse_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  CubeWarehouse_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  CubeWarehouse_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  CubeWarehouse_Group_Weapon_Group_Bottom_ScrollGrid_Weapon_Group_Weapon_Btn__Click = function(btn, str)
    Controller:OnClickWeapon(str)
  end,
  CubeWarehouse_Group_Team_ScrollView_List_Viewport_Content_StaticGrid_List_SetGrid = function(element, elementIndex)
    Controller:OnSetTeamBuffGrid(element, elementIndex)
  end,
  CubeWarehouse_Group_Buff_ScrollGrid_Buff_SetGrid = function(element, elementIndex)
    Controller:OnSetBuffGrid(element, elementIndex)
  end,
  CubeWarehouse_Group_Buff_ScrollGrid_Buff_Group_Buff_Btn__Click = function(btn, str)
  end,
  CubeWarehouse_Group_Weapon_ScrollGrid_Weapon_SetGrid = function(element, elementIndex)
    Controller:OnSetWeaponGrid(element, elementIndex)
  end,
  CubeWarehouse_Group_Buff_Group_Bottom_ScrollGrid_Buff_SetGrid = function(element, elementIndex)
    Controller:OnSetBuffGrid(element, elementIndex)
  end,
  CubeWarehouse_Group_Buff_Group_Bottom_ScrollGrid_Buff_Group_Buff_Btn__Click = function(btn, str)
    Controller:OnClickBuff(str)
  end
}
return ViewFunction
