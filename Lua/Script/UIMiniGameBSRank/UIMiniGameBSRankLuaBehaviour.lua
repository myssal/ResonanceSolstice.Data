local View = require("UIMiniGameBSRank/UIMiniGameBSRankView")
local D = require("UIMiniGameBSRank/UIMiniGameBSRankDataModel")
local Controller = require("UIMiniGameBSRank/UIMiniGameBSRankController")
local ViewFunction = require("UIMiniGameBSRank/UIMiniGameBSRankViewFunction")
return {
  {
    serialize = function()
      return Json.encode(D.params)
    end,
    deserialize = function(params)
      Controller.Init(params)
    end,
    perupdate = function()
      Controller.Update()
    end,
    ondestroy = function()
      Controller.Destroy()
    end
  },
  View,
  ViewFunction
}
