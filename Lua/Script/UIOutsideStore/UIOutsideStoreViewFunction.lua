local NPCDialog = require("Common/NPCDialog")
local View = require("UIOutsideStore/UIOutsideStoreView")
local DataModel = require("UIOutsideStore/UIOutsideStoreDataModel")
local Controller = require("UIOutsideStore/UIOutsideStoreController")
local ViewFunction = {
  OutsideStore_Group_Coin_Btn_Tips_Click = function(btn, str)
    if DataModel.storeCA.currencyShow[1].id == nil or DataModel.storeCA.currencyShow[1].id == "" then
      return
    end
    CommonTips.OpenRewardDetail(DataModel.storeCA.currencyShow[1].id)
  end,
  OutsideStore_Group_NPC_Btn_Chat_Click = function(btn, str)
    NPCDialog.SetNPCTextByEnum(View.Group_NPC, DataModel.NPCDialogEnum.talkText)
  end,
  OutsideStore_ScrollGrid_Commodity_SetGrid = function(element, elementIndex)
    Controller:SetResetGroupElement(element, elementIndex)
  end,
  OutsideStore_ScrollGrid_Commodity_Group_Item_Group_CommonItem_Btn_Item_Click = function(btn, str)
  end,
  OutsideStore_ScrollGrid_Commodity_Group_Item_Btn__Click = function(btn, str)
    local row = DataModel.storeList[tonumber(str)]
    if row.purchase and row.residue == 0 then
      NPCDialog.SetNPCTextByEnum(View.Group_NPC, DataModel.NPCDialogEnum.saleOutText)
      CommonTips.OpenTips(80602917)
      return
    end
    local parmas = {}
    parmas.index = tonumber(str) - 1
    parmas.shopid = row.shopId
    parmas.id = row.id
    parmas.residue = row.residue
    
    local function callBack()
      DataModel.RefreshShopList()
      Controller:RefreshShopList()
      NPCDialog.SetNPCTextByEnum(View.Group_NPC, DataModel.NPCDialogEnum.buySuccessText)
    end
    
    CommonTips.OpenBuyTips(parmas, callBack)
  end,
  OutsideStore_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  OutsideStore_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  OutsideStore_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  OutsideStore_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  OutsideStore_ScrollGrid_Coin_SetGrid = function(element, elementIndex)
    local data = DataModel.coinList[elementIndex]
    if data.click == "Tips" then
      element.Btn_Tips:SetClickParam(elementIndex)
    end
    local cfg = PlayerData:GetFactoryData(data.id)
    local num = PlayerData:GetGoodsById(data.id).num or 0
    element.Img_Icon:SetSprite(cfg.buyPath)
    element.Txt_Num:SetText(num)
  end
}
return ViewFunction
