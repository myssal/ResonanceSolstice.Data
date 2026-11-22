local View = require("UIBookList/UIBookListView")
local DataModel = require("UIBookList/UIBookListDataModel")
local ViewFunction = require("UIBookList/UIBookListViewFunction")
local Controller = require("UIBookList/UIBookListController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil and initParams ~= "" then
      DataModel.cubeId = Json.decode(initParams).cubeId
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
