local View = require("UIOrderTips/UIOrderTipsView")
local DataModel = require("UIOrderTips/UIOrderTipsDataModel")
local ViewFunction = require("UIOrderTips/UIOrderTipsViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams == "" or initParams == nil then
      UIManager:CloseTip("UI/StageQuest/Order/OrderTips")
      return
    end
    local params = Json.decode(initParams)
    DataModel.ItemId = params.id
    DataModel.NeedNum = params.needNum
    DataModel.OrderUId = params.uid
    DataModel.Init()
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
