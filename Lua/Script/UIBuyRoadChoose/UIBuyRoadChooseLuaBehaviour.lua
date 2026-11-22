local View = require("UIBuyRoadChoose/UIBuyRoadChooseView")
local DataModel = require("UIBuyRoadChoose/UIBuyRoadChooseDataModel")
local ViewFunction = require("UIBuyRoadChoose/UIBuyRoadChooseViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local basic = Json.decode(initParams)
      DataModel.TrainEventId = basic.eventId
      DataModel.TrainLineId = basic.lineId
      DataModel.needGold = basic.needGold
      View.Group_BuyRoad.Group_Choose1.Btn_Bg.Group_Num.Txt_Num:SetText(DataModel.needGold)
    else
      error("\230\178\161\230\156\137\231\129\171\232\189\166\228\186\139\228\187\182id\239\188\140\228\184\141\229\144\136\231\144\134")
      return
    end
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
