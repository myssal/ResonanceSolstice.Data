local NPCDialog = require("Common/NPCDialog")
local CommonItem = require("Common/BtnItem")
local View = require("UIOutsideStore/UIOutsideStoreView")
local DataModel = require("UIOutsideStore/UIOutsideStoreDataModel")
local Controller = {}

function Controller:Init(initParams)
  DataModel.Init(initParams)
  Controller:RefreshShopList()
  View.Img_Title:SetSprite(PlayerData:GetFactoryData(88300214).filePath)
  NPCDialog.SetNPC(View.Group_NPC, DataModel.npcId)
  NPCDialog.SetNPCTextByEnum(View.Group_NPC, DataModel.NPCDialogEnum.enterText)
end

function Controller:RefreshShopList()
  View.ScrollGrid_Commodity.grid.self:SetDataCount(table.count(DataModel.storeList))
  View.ScrollGrid_Commodity.grid.self:RefreshAllElement()
  View.ScrollGrid_Coin.self:SetActive(#DataModel.coinList > 0)
  if #DataModel.coinList > 0 then
    View.ScrollGrid_Coin.grid.self:SetDataCount(#DataModel.coinList)
    View.ScrollGrid_Coin.grid.self:RefreshAllElement()
  end
  local coinId = DataModel.storeCA.currencyShow[1].id
  View.Group_Coin.self:SetActive(coinId and coinId ~= "")
  if coinId and coinId ~= "" then
    View.Group_Coin.Txt_Num:SetText(PlayerData:GetGoodsById(coinId).num or 0)
  end
end

function Controller:SetResetGroupElement(element, elementIndex)
  local idx = tonumber(elementIndex)
  element.Btn_:SetClickParam(idx)
  local row = DataModel.storeList[idx]
  local quality_int
  if row.qualityInt ~= nil then
    quality_int = row.qualityInt + 1
  else
    quality_int = 1
  end
  element.Txt_Name:SetText(row.name)
  element.Group_CommonItem.Img_Bottom:SetSprite(UIConfig.BottomConfig[quality_int])
  element.Group_CommonItem.Img_Mask:SetSprite(UIConfig.MaskConfig[quality_int])
  element.Group_CommonItem.Img_Item:SetSprite(row.iconPath)
  element.Group_CommonItem.Txt_Num:SetText(row.itemNum)
  element.Group_Limit:SetActive(row.purchase ~= false)
  if row.purchase then
    local textId = 0
    if row.limitBuyType == "Forever" then
      textId = 80600430
    elseif row.limitBuyType == "Daily" then
      textId = 80600798
    elseif row.limitBuyType == "Weekly" then
      textId = 80600800
    elseif row.limitBuyType == "Monthly" then
      textId = 80600801
    end
    element.Group_Limit.Txt_PurchaseNum:SetText(string.format(GetText(textId), row.residue, row.purchaseNum))
  end
  element.Img_SoldOut:SetActive(row.purchase and row.residue == 0)
  local money = row.moneyList[1]
  element.Group_Price.self:SetActive(money ~= nil)
  if money then
    local left_money = PlayerData:GetFactoryData(tonumber(row.moneyList[1].moneyID))
    local path = left_money.buyPath
    if path == "" then
      path = left_money.iconPath
    end
    element.Group_Price.Img_Coin:SetSprite(path)
    local moneyNum = row.moneyList[1].moneyNum
    if row.isChange and 0 < row.moneyList[1].correspondPrice then
      local listCA = PlayerData:GetFactoryData(row.moneyList[1].correspondPrice, "ListFactory")
      local buyCount = (row.py_cnt or 0) + 1
      local priceCount = #listCA.priceList
      if buyCount > priceCount then
        buyCount = priceCount
      end
      moneyNum = listCA.priceList[buyCount].num
    end
    element.Group_Price.Txt_Num:SetText(moneyNum)
    element.Group_Price.Txt_Num:SetColor("#FFFFFF")
    local curHaveMoneyNum = PlayerData:GetGoodsById(left_money.id).num
    if moneyNum > curHaveMoneyNum then
      element.Group_Price.Txt_Num:SetColor("#A8A8A8")
    end
  end
end

return Controller
