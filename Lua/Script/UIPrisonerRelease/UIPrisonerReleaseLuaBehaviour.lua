local View = require("UIPrisonerRelease/UIPrisonerReleaseView")
local DataModel = require("UIPrisonerRelease/UIPrisonerReleaseDataModel")
local ViewFunction = require("UIPrisonerRelease/UIPrisonerReleaseViewFunction")
local Controller = require("UIPrisonerRelease/UIPrisonerReleaseController")
local Luabehaviour = {
  serialize = function()
    return Json.encode({
      release_prisoner = DataModel.release_prisoner
    })
  end,
  deserialize = function(initParams)
    Controller.InitView(Json.decode(initParams))
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
