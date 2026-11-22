local View = require("UIStrikeGiftTip/UIStrikeGiftTipView")
local DataModel = require("UIStrikeGiftTip/UIStrikeGiftTipDataModel")
local ViewFunction = require("UIStrikeGiftTip/UIStrikeGiftTipViewFunction")
local CommonItem = require("Common/BtnItem")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
  end,
  awake = function()
    DataModel.id = GetCA(99900044, "ConfigFactory").strikeGiftId
    CommonItem:SetItem(View.Group_Item, {
      id = DataModel.id
    })
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
