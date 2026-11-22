local View = require("UIHYOrderRecord/UIHYOrderRecordView")
local DataModel = require("UIHYOrderRecord/UIHYOrderRecordDataModel")
local ViewFunction = require("UIHYOrderRecord/UIHYOrderRecordViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
    DataModel.RefreshOnShow()
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
