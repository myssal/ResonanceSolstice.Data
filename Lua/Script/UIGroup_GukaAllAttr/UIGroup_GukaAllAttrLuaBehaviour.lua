local View = require("UIGroup_GukaAllAttr/UIGroup_GukaAllAttrView")
local DataModel = require("UIGroup_GukaAllAttr/UIGroup_GukaAllAttrDataModel")
local ViewFunction = require("UIGroup_GukaAllAttr/UIGroup_GukaAllAttrViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams and initParams ~= "" then
      local params = Json.decode(initParams)
      DataModel.IsInGuKaView = params.IsInGuKaView
    else
      DataModel.IsInGuKaView = false
    end
    DataModel.Init()
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
