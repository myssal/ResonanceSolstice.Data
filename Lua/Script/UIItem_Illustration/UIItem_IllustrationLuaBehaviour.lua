local View = require("UIItem_Illustration/UIItem_IllustrationView")
local DataModel = require("UIItem_Illustration/UIItem_IllustrationDataModel")
local ViewFunction = require("UIItem_Illustration/UIItem_IllustrationViewFunction")
local Controller = require("UIItem_Illustration/UIItem_IllustrationController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil and initParams ~= "" then
      DataModel.bookName = Json.decode(initParams).bookName
      Controller.Init()
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
    Controller.Release()
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
