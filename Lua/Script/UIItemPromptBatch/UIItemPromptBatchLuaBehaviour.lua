local View = require("UIItemPromptBatch/UIItemPromptBatchView")
local DataModel = require("UIItemPromptBatch/UIItemPromptBatchDataModel")
local Controller = require("UIItemPromptBatch/UIItemPromptBatchController")
local ViewFunction = require("UIItemPromptBatch/UIItemPromptBatchViewFunction")
local Luabehaviour = {
  serialize = function()
    return Json.encode(DataModel.params)
  end,
  deserialize = function(initParams)
    DataModel.params = Json.decode(initParams)
    Controller:Init()
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
