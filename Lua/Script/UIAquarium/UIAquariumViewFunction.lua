local View = require("UIAquarium/UIAquariumView")
local DataModel = require("UIAquarium/UIAquariumDataModel")
local Controller = require("UIAquarium/UIAquariumController")
local ViewFunction = {
  Aquarium_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if View.Group_Store.self.IsActive then
      Controller:ReturnToMain()
      return
    end
    UIManager:GoBack()
  end,
  Aquarium_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  Aquarium_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Aquarium_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Aquarium_Group_Main_Btn_Buy_Click = function(btn, str)
    Controller:ClickTrade()
  end,
  Aquarium_Group_Main_Btn_Talk_Click = function(btn, str)
    Controller:ShowNPCTalk(DataModel.NPCDialogEnum.talkText)
  end,
  Aquarium_Group_Store_Group_Tab_Btn_Buy_Click = function(btn, str)
    Controller:SelectTab(DataModel.TradeType.Buy)
  end,
  Aquarium_Group_Store_Group_Tab_Btn_Sell_Click = function(btn, str)
    Controller:SelectTab(DataModel.TradeType.Sell)
  end,
  Aquarium_Group_Store_Group_Resources_Group_GoldCoin_Btn_GoldCoin_Click = function(btn, str)
  end,
  Aquarium_Group_Store_Group_NpcInfoL_Btn_Refresh_Click = function(btn, str)
  end,
  Aquarium_Group_Store_Group_Buy_Group_General_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller:SetBuyStoreElement(element, elementIndex)
  end,
  Aquarium_Group_Store_Group_Buy_Group_General_ScrollGrid_List_Group_Item_Btn_1_Click = function(btn, str)
    if DataModel.batchOpen then
      Controller.BatchBuyItemClick(str)
      return
    end
    Controller:GeneralBuyClickItem(str)
  end,
  Aquarium_Group_Store_Group_Sell_Group_General_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller:SetSellStoreElement(element, elementIndex)
  end,
  Aquarium_Group_Store_Group_Sell_Group_General_ScrollGrid_List_Group_Item_Btn_1_Click = function(btn, str)
    if DataModel.batchOpen then
      Controller.BatchSaleItemClick(str)
      return
    end
    Controller:GeneralSellClickItem(str)
  end,
  Aquarium_Group_Store_Group_Buy_Group_General_Btn_PL_Click = function(btn, str)
    if Controller.IsBuyBatchOpen() then
      Controller.CloseBuyBatch()
    else
      Controller.OpenBuyBatch()
    end
  end,
  Aquarium_Group_Store_Group_Buy_Group_General_Group_Time_Btn_ShuaXin_Click = function(btn, str)
    Controller.RefreshGeneralBuyShop()
  end,
  Aquarium_Group_Store_Group_Buy_Group_General_Group_Time_Btn__Click = function(btn, str)
    Controller.BatchBuyConfirm()
  end,
  Aquarium_Group_Store_Group_Sell_Group_General_Group_Time_Btn__Click = function(btn, str)
    Controller.BatchSaleConfirm()
  end,
  Aquarium_Group_Store_Group_Sell_Group_General_Btn_PL_Click = function(btn, str)
    if Controller.IsSaleBatchOpen() then
      Controller.CloseSaleBatch()
    else
      Controller.OpenSaleBatch()
    end
  end
}
return ViewFunction
