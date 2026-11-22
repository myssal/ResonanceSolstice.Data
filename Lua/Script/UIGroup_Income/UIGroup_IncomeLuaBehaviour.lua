local View = require("UIGroup_Income/UIGroup_IncomeView")
local DataModel = require("UIGroup_Income/UIGroup_IncomeDataModel")
local ViewFunction = require("UIGroup_Income/UIGroup_IncomeViewFunction")
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
  end,
  ondestroy = function()
    if DataModel.investRewardItemObjList then
      for i, tbl in ipairs(DataModel.investRewardItemObjList) do
        for _, v in ipairs(tbl) do
          Object.Destroy(v.gameObject)
        end
      end
      DataModel.investRewardItemObjList = nil
    end
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
