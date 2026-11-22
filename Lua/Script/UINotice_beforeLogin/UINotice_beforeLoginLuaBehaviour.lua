local View = require("UINotice_beforeLogin/UINotice_beforeLoginView")
local DataModel = require("UINotice_beforeLogin/UINotice_beforeLoginDataModel")
local Controller = require("UINotice_beforeLogin/UINotice_beforeLoginController")
local ViewFunction = require("UINotice_beforeLogin/UINotice_beforeLoginViewFunction")
local Luabehaviour = {
  serialize = function()
    return DataModel.initParams
  end,
  deserialize = function(initParams)
    DataModel.initParams = initParams
    local htmlContent = Json.decode(initParams)
    DataModel.InitHtmlText(htmlContent)
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
