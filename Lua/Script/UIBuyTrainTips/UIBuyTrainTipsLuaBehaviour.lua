local View = require("UIBuyTrainTips/UIBuyTrainTipsView")
local DataModel = require("UIBuyTrainTips/UIBuyTrainTipsDataModel")
local ViewFunction = require("UIBuyTrainTips/UIBuyTrainTipsViewFunction")
local Controller = require("UIBuyTrainTips/UIBuyTrainTipsController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local params = Json.decode(initParams)
      if params and params.weaponId then
        DataModel.weaponId = params.weaponId
        Controller.Init()
      end
    end
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
