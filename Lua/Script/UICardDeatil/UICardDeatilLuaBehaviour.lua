local View = require("UICardDeatil/UICardDeatilView")
local DataModel = require("UICardDeatil/UICardDeatilDataModel")
local ViewFunction = require("UICardDeatil/UICardDeatilViewFunction")
local Controller = require("UICardDeatil/UICardDeatilController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local data = Json.decode(initParams)
      Controller:Init(data)
    end
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
