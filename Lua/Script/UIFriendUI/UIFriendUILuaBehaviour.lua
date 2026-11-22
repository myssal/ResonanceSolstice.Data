local View = require("UIFriendUI/UIFriendUIView")
local DataModel = require("UIFriendUI/UIFriendUIDataModel")
local ViewFunction = require("UIFriendUI/UIFriendUIViewFunction")
local Luabehaviour = {
  serialize = function()
    return Json.encode({
      reload = DataModel.reload,
      friendServerData = DataModel.friendServerData,
      otherInfo = DataModel.otherInfo,
      petReduceRate = DataModel.petReduceRate,
      ownOtherInfo = DataModel.ownOtherInfo
    })
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
    DataModel.InitData()
    DataModel.RefreshOnShow()
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
    if View.Group_Info.Group_ClearCD.IsActive then
      local cd = DataModel.GetCleanCD(DataModel.friendServerData.uid)
      View.Group_Info.Group_ClearCD.Txt_Num:SetText(cd)
      if cd == 0 then
        View.Group_Info.Group_ClearCD:SetActive(false)
      end
    end
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
