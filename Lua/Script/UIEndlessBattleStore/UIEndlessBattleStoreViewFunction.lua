local View = require("UIEndlessBattleStore/UIEndlessBattleStoreView")
local DataModel = require("UIRandomBattleStore/UIRandomBattleStoreDataModel")
local CommonItem = require("Common/BtnItem")
local NPCDialog = require("Common/NPCDialog")
local EndlessDataModel = require("UIActivityEndlessBattle/UIActivityEndlessBattleDataModel")
local ViewFunction = {
  EndlessBattleStore_Group_NPC_Btn_Chat_Click = function(btn, str)
    NPCDialog.SetNPCTextByEnum(View.Group_NPC, DataModel.NPCDialogEnum.talkText)
  end,
  EndlessBattleStore_Group_Right_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  EndlessBattleStore_Group_Right_Group_Item_Btn_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  EndlessBattleStore_Group_Right_NewScrollGrid_CommodityList_SetGrid = function(element, elementIndex)
    local data = DataModel.shopList[tonumber(elementIndex)]
    local cfg = PlayerData:GetFactoryData(data.id)
    local Btn_Item = element.Btn_Item
    Btn_Item.self:SetClickParam(elementIndex)
    Btn_Item.Txt_CommodityName:SetText(cfg.commodityName)
    Btn_Item.Group_Quota.self:SetActive(data.limitBuy)
    if data.limitBuy then
      local remainCnt = data.maxBuyCnt - (DataModel.purchaseDic[data.id] or 0)
      local textId = 80602522
      Btn_Item.Group_Quota.Txt_Num:SetText(string.format(GetText(textId), remainCnt))
      Btn_Item.Group_SoldOut.self:SetActive(data.limitBuy and remainCnt <= 0)
    else
      Btn_Item.Group_SoldOut.self:SetActive(false)
    end
    CommonItem:SetItem(Btn_Item.Group_Item, {
      id = cfg.commodityItemList[1].id,
      num = cfg.commodityNum
    })
    local moneyCA = PlayerData:GetFactoryData(cfg.moneyList[1].moneyID)
    Btn_Item.Group_Money.Img_Money:SetSprite(moneyCA.buyPath)
    Btn_Item.Group_Money.Txt_Price:SetText(cfg.moneyList[1].moneyNum)
    local coinNum = 0
    if EndlessDataModel.user_endless ~= nil then
      coinNum = EndlessDataModel.user_endless.coin or 0
    end
    local canBuy = coinNum >= cfg.moneyList[1].moneyNum
    local color = canBuy and "#000000" or "#FF0000"
    Btn_Item.Group_Money.Txt_Price:SetColor(color)
  end,
  EndlessBattleStore_Group_Right_NewScrollGrid_CommodityList_Group_Item_Btn_Item_Click = function(btn, str)
    local idx = tonumber(str)
    local data = DataModel.shopList[idx]
    local remainCnt = data.maxBuyCnt - (DataModel.purchaseDic[data.id] or 0)
    local notBuy = data.limitBuy and remainCnt <= 0
    if notBuy then
      NPCDialog.SetNPCTextByEnum(View.Group_NPC, DataModel.NPCDialogEnum.saleOutText)
      CommonTips.OpenTips(80602917)
      return
    end
    local parmas = {}
    parmas.index = idx - 1
    parmas.shopid = DataModel.shopId
    parmas.id = data.id
    parmas.endlessCoinId = DataModel.coinCA.id
    if data.limitBuy then
      parmas.residue = remainCnt
    end
    
    local function callBack()
      DataModel.initPurchaseDic(DataModel.shopId)
      DataModel.SortShopList()
      View.Group_Right.NewScrollGrid_CommodityList.grid.self:RefreshAllElement()
      local coinCA = DataModel.coinCA
      local coinNum = 0
      if EndlessDataModel.user_endless ~= nil then
        coinNum = EndlessDataModel.user_endless.coin or 0
      end
      View.Group_CommomBottomLeft.Group_Items.Img_Icon:SetSprite(coinCA.iconPath)
      View.Group_CommomBottomLeft.Group_Items.Txt_Num:SetText(coinNum)
      NPCDialog.SetNPCTextByEnum(View.Group_NPC, DataModel.NPCDialogEnum.buySuccessText)
    end
    
    CommonTips.OpenBuyTips(parmas, callBack)
  end,
  EndlessBattleStore_Group_Right_NewScrollGrid_CommodityList_Group_Item_Btn_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  EndlessBattleStore_StaticGrid_Coin_SetGrid = function(element, elementIndex)
    local data = DataModel.coinList[elementIndex]
    if data.click == "Tips" then
      element.Btn_:SetClickParam(elementIndex)
    end
    local cfg = PlayerData:GetFactoryData(data.id)
    local num = PlayerData:GetGoodsById(data.id).num or 0
    element.Img_Money:SetSprite(cfg.buyPath)
    element.Txt_Num:SetText(num)
  end,
  EndlessBattleStore_StaticGrid_Coin_Group_TopRight_Btn__Click = function(btn, str)
  end,
  EndlessBattleStore_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  EndlessBattleStore_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  EndlessBattleStore_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  EndlessBattleStore_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  EndlessBattleStore_Group_CommomBottomLeft_Btn_Rank_Click = function(btn, str)
  end,
  EndlessBattleStore_Group_TopRight_Btn__Click = function(btn, str)
  end
}
return ViewFunction
