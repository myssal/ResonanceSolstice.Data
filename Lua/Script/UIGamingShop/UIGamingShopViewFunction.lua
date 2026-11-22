local View = require("UIGamingShop/UIGamingShopView")
local DataModel = require("UIGamingShop/UIGamingShopDataModel")
local Controller = require("UIGamingShop/UIGamingShopController")
local RogueMainController = require("UICubeRogueMain/UICubeRoguewMainController")
local EquipAttrManager = require("UICubeRogueMain/CubeRogueEquipAttrManager")
local ViewFunction = {
  GamingShop_Group_Right_Btn_Buy_Click = function(btn, str)
    Controller:OnClickBtnBuy()
  end,
  GamingShop_Group_Weapon_ScrollGrid_Weapon_SetGrid = function(element, elementIndex)
    Controller:OnSetItemGrid(element, elementIndex)
  end,
  GamingShop_Group_Coin_Btn_GoldCoin_Click = function(btn, str)
    CommonTips.OpenCubeRogueItemDetails({
      id = DataModel.cubeCA.coinId
    })
  end,
  GamingShop_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if DataModel.isTriggerClose then
      RogueMainController.TryTriggerAndNextRound(nil, function()
        EquipAttrManager:RefreshEffectNumByAttrType(Enum_AttrType.Price)
        UIManager:GoBack(false)
        return false
      end)
    end
  end,
  GamingShop_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  GamingShop_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  GamingShop_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  GamingShop_Group_Weapon_ScrollGrid_Weapon_Group_Weapon_Btn__Click = function(btn, str)
    Controller:OnSelectWeapon(tonumber(str))
  end,
  GamingShop_Group_Right_Group_Buff_Btn__Click = function(btn, str)
  end,
  GamingShop_Group_Right_Group_Weapon_Btn__Click = function(btn, str)
  end,
  GamingShop_Group_Backpack_Btn__Click = function(btn, str)
    UIManager:Open("UI/CubeRogue/CubeWarehouse/CubeWarehouse")
  end,
  GamingShop_Group_Buff_ScrollGrid_Buff_SetGrid = function(element, elementIndex)
    Controller:OnSetBuffGrid(element, elementIndex)
  end,
  GamingShop_Group_Buff_ScrollGrid_Buff_Group_Buff_Btn__Click = function(btn, str)
    Controller:OnSelectBuff(tonumber(str))
  end,
  GamingShop_Group_Tab_Group_Btn_Btn__Click = function(btn, str)
  end,
  GamingShop_Group_Tab_StaticGrid_List_SetGrid = function(element, elementIndex)
    Controller:OnSetTabGrid(element, elementIndex)
  end,
  GamingShop_Group_Tab_StaticGrid_List_Group_Btn_Btn__Click = function(btn, str)
    Controller:RefreshShopTab(tonumber(str))
  end
}
return ViewFunction
