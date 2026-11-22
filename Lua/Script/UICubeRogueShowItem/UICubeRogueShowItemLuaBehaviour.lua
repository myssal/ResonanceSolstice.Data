local View = require("UICubeRogueShowItem/UICubeRogueShowItemView")
local DataModel = require("UICubeRogueShowItem/UICubeRogueShowItemDataModel")
local ViewFunction = require("UICubeRogueShowItem/UICubeRogueShowItemViewFunction")
local Controller = require("UICubeRogueShowItem/UICubeRogueShowItemController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local temp = Json.decode(initParams)
    DataModel.Data = {}
    for k, v in pairs(temp.data) do
      table.insert(DataModel.Data, v)
    end
    local isGet = temp.ptype == "get_gold"
    View.Img_Title:SetActive(isGet)
    View.Img_LoseTitle:SetActive(not isGet)
    Controller.ShowPanel()
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
