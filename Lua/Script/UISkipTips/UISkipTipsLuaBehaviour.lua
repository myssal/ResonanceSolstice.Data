local View = require("UISkipTips/UISkipTipsView")
local DataModel = require("UISkipTips/UISkipTipsDataModel")
local ViewFunction = require("UISkipTips/UISkipTipsViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
    DataModel.InitData()
    DataModel.RefreshOnShow()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if DataModel.remainTime > 0 then
      DataModel.remainTime = DataModel.remainTime - Time.deltaTime
      if DataModel.remainTime < 0 then
        DataModel.remainTime = 0
      end
      DataModel.RefreshTime()
    end
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
