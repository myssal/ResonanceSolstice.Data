local View = require("UIArrest_Success/UIArrest_SuccessView")
local DataModel = require("UIArrest_Success/UIArrest_SuccessDataModel")
local ViewFunction = require("UIArrest_Success/UIArrest_SuccessViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local param = Json.decode(initParams)
      DataModel.isSkip = param.isSkip
      DataModel.reward = param.reward
      DataModel.prisonerDic = param.prisonerDic
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
    if DataModel.prisonerDic ~= nil then
      if DataModel.isSkip then
        UIManager:Open("UI/Prison/ArrestPrisoner/SkipArrestSettlement", Json.encode({
          prisonerDic = DataModel.prisonerDic
        }), function()
          UIManager:GoBack()
          CommonTips.OpenShowItem(DataModel.reward)
        end)
      else
        UIManager:Open("UI/Prison/ArrestPrisoner/ArrestSettlement", Json.encode({
          prisonerDic = DataModel.prisonerDic
        }))
      end
    end
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
