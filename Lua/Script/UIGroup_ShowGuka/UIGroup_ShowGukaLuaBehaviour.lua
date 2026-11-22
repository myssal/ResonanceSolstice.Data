local View = require("UIGroup_ShowGuka/UIGroup_ShowGukaView")
local DataModel = require("UIGroup_ShowGuka/UIGroup_ShowGukaDataModel")
local ViewFunction = require("UIGroup_ShowGuka/UIGroup_ShowGukaViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams == "" or initParams == nil then
      return
    end
    local params = Json.decode(initParams)
    DataModel.GuKaId = params.id
    DataModel.ShowGuKa()
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
