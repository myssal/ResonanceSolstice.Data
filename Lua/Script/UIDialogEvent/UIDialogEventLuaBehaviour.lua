local View = require("UIDialogEvent/UIDialogEventView")
local ViewFunction = require("UIDialogEvent/UIDialogEventViewFunction")
local Controller = require("UIDialogEvent/UIDialogEventController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil and initParams ~= "" then
      local dialogId = Json.decode(initParams).dialogId
      local lv = Json.decode(initParams).level
      local eventId = Json.decode(initParams).eventId
      local gridId = Json.decode(initParams).gridId
      Controller.Init(dialogId, lv, eventId, gridId)
    end
  end,
  awake = function()
  end,
  start = function()
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
