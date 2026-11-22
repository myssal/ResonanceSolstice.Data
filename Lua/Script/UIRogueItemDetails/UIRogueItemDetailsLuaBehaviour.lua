local View = require("UIRogueItemDetails/UIRogueItemDetailsView")
local DataModel = require("UIRogueItemDetails/UIRogueItemDetailsDataModel")
local ViewFunction = require("UIRogueItemDetails/UIRogueItemDetailsViewFunction")
local Controller = require("UIRogueItemDetails/UIRogueItemDetailsController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local data = Json.decode(initParams)
    local itemCfg = PlayerData:GetFactoryData(data.id, "ItemFactory")
    if itemCfg.quality then
      View.Img_qualityBox:SetSprite("UI/CubeRogue/ItemDetails/qualityBox/" .. itemCfg.quality)
    else
      View.Img_qualityBox:SetSprite("UI/CubeRogue/ItemDetails/qualityBox/Orange")
    end
    if itemCfg.iconPath then
      View.Img_Item:SetSprite(itemCfg.iconPath)
    else
      View.Img_Item:SetSprite(itemCfg.itemTipsPath)
    end
    View.Txt_Name:SetText(itemCfg.name)
    local itemNum = data.num or PlayerData:GetGoodsById(data.id).num
    View.Group_Num.Txt_:SetText(itemNum)
    View.Txt_Desc:SetText(itemCfg.des)
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
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
