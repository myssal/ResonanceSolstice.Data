local View = require("UITeam_Illustration/UITeam_IllustrationView")
local DataModel = require("UITeam_Illustration/UITeam_IllustrationDataModel")
local ViewFunction = require("UITeam_Illustration/UITeam_IllustrationViewFunction")
local Controller = require("UITeam_Illustration/UITeam_IllustrationController")
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
