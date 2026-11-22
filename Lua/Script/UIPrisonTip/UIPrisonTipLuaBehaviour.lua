local View = require("UIPrisonTip/UIPrisonTipView")
local DataModel = require("UIPrisonTip/UIPrisonTipDataModel")
local ViewFunction = require("UIPrisonTip/UIPrisonTipViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local data = Json.decode(initParams)
    DataModel.Init(data.id)
    View.Img_T.Txt_Name:SetText(DataModel.activityCA.name)
    View.Img_T.Txt_Name:SetActive(true)
    View.Group_Preview.ScrollGrid_Reward.self:SetActive(#DataModel.activityCA.rewardPreviewList)
    View.Group_Preview.ScrollGrid_Reward.grid.self:SetDataCount(#DataModel.activityCA.rewardPreviewList)
    View.Group_Preview.ScrollGrid_Reward.grid.self:RefreshAllElement()
    View.Img_Bg.Img_x.Txt_Pre:SetActive(false)
    View.Img_Bg.Img_x.Txt_D2:SetActive(true)
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
