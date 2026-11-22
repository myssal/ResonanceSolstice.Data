local View = require("UIHotelTip/UIHotelTipView")
local DataModel = require("UIHotelTip/UIHotelTipDataModel")
local ViewFunction = require("UIHotelTip/UIHotelTipViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local data = Json.decode(initParams)
    DataModel.Init(data.id)
    View.Img_Logo.Txt_Name:SetText(DataModel.activityCA.name)
    View.Group_Preview.ScrollGrid_Reward.self:SetActive(#DataModel.activityCA.rewardPreviewList)
    View.Group_Preview.ScrollGrid_Reward.grid.self:SetDataCount(#DataModel.activityCA.rewardPreviewList)
    View.Group_Preview.ScrollGrid_Reward.grid.self:RefreshAllElement()
    View.Img_Bg.Img_x.Txt_Pre:SetActive(DataModel.index == 1)
    View.Img_Bg.Img_x.Txt_D2:SetActive(DataModel.index == 2)
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
