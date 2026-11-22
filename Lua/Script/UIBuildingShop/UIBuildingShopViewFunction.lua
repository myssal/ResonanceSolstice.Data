local View = require("UIBuildingShop/UIBuildingShopView")
local DataModel = require("UIBuildingShop/UIBuildingShopDataModel")
local Controller = require("UIBuildingShop/UIBuildingShopController")
local ViewFunction = {
  BuildingShop_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:Return()
  end,
  BuildingShop_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    Controller:Home()
  end,
  BuildingShop_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  BuildingShop_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    Controller:Help()
  end,
  BuildingShop_Group_Store_Group_Resources_Group_GoldCoin_Btn_GoldCoin_Click = function(btn, str)
  end,
  BuildingShop_Group_Store_Group_Resources_Group_GoldCoin_Btn_Add_Click = function(btn, str)
  end,
  BuildingShop_Group_Store_Group_Furniture_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller:RefreshElement(element, elementIndex)
  end,
  BuildingShop_Group_Store_Group_Furniture_ScrollGrid_List_Group_Item_Btn_1_Click = function(btn, str)
    Controller:ClickElement(btn, str)
  end,
  BuildingShop_Group_Store_Group_StoreTab_Img_BG_StaticGrid__SetGrid = function(element, elementIndex)
    Controller:RefreshTabElement(element, elementIndex)
  end,
  BuildingShop_Group_Store_Group_StoreTab_Img_BG_StaticGrid__Group_Item_Btn_Furniture_Click = function(btn, str)
    Controller:ClickTabElement(btn, str)
  end,
  BuildingShop_Group_Store_Group_Time_Img_1_Btn__Click = function(btn, str)
  end,
  BuildingShop_Group_Tab_Btn_Buy_Click = function(btn, str)
    Controller:ClickTradeType(DataModel.TradeType.Buy)
  end,
  BuildingShop_Group_Tab_Btn_Sell_Click = function(btn, str)
    Controller:ClickTradeType(DataModel.TradeType.Sale)
  end,
  BuildingShop_Group_Item_Btn_Furniture_Click = function(btn, str)
  end,
  BuildingShop_Group_Store_Group_Resources_Group_GoldCoin1_Btn_GoldCoin_Click = function(btn, str)
  end,
  BuildingShop_Group_Store_Group_Resources_Group_GoldCoin1_Btn_Add_Click = function(btn, str)
  end
}
return ViewFunction
