local View = require("UIMonopolyBuyBuff/UIMonopolyBuyBuffView")
local DataModel = require("UIMonopolyBuyBuff/UIMonopolyBuyBuffDataModel")
local ViewFunction = require("UIMonopolyBuyBuff/UIMonopolyBuyBuffViewFunction")
local monopolyDataModel = require("UIMonopoly/UIMonopolyDataModel")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local shopData = Json.decode(initParams).gridShop
    DataModel.Init(shopData)
    View.Group_BuyTips:SetActive(false)
    View.StaticGrid_BuffList.grid.self:RefreshAllElement()
    View.Img_Livia.Img_Des.Group_ItemNum.Txt_Own:SetText(monopolyDataModel.GetAllItemsCount())
    View.Img_Livia.Img_Des.Group_ItemNum.Txt_Max:SetText(DataModel.ownMaxNum)
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
