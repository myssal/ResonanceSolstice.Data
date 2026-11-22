local View = require("UIArrestSettlement/UIArrestSettlementView")
local DataModel = require("UIArrestSettlement/UIArrestSettlementDataModel")
local ViewFunction = require("UIArrestSettlement/UIArrestSettlementViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local param = Json.decode(initParams)
      DataModel:SetView(View)
      DataModel:Init(param)
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
