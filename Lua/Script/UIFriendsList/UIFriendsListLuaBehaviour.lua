local View = require("UIFriendsList/UIFriendsListView")
local DataModel = require("UIFriendsList/UIFriendsListDataModel")
local ViewFunction = require("UIFriendsList/UIFriendsListViewFunction")
local Controller = require("UIFriendsList/UIFriendsListController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.Init()
    DataModel.SetJsonData(initParams)
    Controller:Init()
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
