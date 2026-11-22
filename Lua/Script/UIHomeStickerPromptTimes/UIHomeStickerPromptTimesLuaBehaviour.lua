local View = require("UIHomeStickerPromptTimes/UIHomeStickerPromptTimesView")
local DataModel = require("UIHomeStickerPromptTimes/UIHomeStickerPromptTimesDataModel")
local ViewFunction = require("UIHomeStickerPromptTimes/UIHomeStickerPromptTimesViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil and initParams ~= "" then
      local param = Json.decode(initParams)
      DataModel.characterInfo = param.info
      DataModel.costId = param.costId
      DataModel.costNum = param.costNum
    end
    DataModel:Init()
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
