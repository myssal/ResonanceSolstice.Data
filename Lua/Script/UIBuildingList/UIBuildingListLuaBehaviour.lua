local View = require("UIBuildingList/UIBuildingListView")
local DataModel = require("UIBuildingList/UIBuildingListDataModel")
local ViewFunction = require("UIBuildingList/UIBuildingListViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.Init()
    View.Group_Main.ScrollGrid_.grid.self:SetDataCount(#DataModel.openList)
    View.Group_Main.ScrollGrid_.grid.self:RefreshAllElement()
    ViewFunction.RefreshPanel()
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
