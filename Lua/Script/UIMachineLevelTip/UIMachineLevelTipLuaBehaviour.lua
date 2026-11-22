local View = require("UIMachineLevelTip/UIMachineLevelTipView")
local DataModel = require("UIMachineLevelTip/UIMachineLevelTipDataModel")
local ViewFunction = require("UIMachineLevelTip/UIMachineLevelTipViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.init()
    View.Img_PlayerInfo.Group_LV.Txt_Num:SetText(DataModel.makeLv)
    local nowProbability = DataModel.machiningExpList[DataModel.makeLv].AdditionalProbability * 100
    View.Group_Now.Txt_Rise:SetText(nowProbability .. "%")
    if DataModel.makeLv < #DataModel.machiningExpList then
      local needLv = DataModel.machiningExpList[DataModel.makeLv].LvUpExp
      View.Img_PlayerInfo.Txt_Profit:SetText(DataModel.makeExp .. "/" .. needLv)
      View.Img_PlayerInfo.Img_BP:SetFilledImgAmount(DataModel.makeExp / needLv)
      local nextProbability = DataModel.machiningExpList[DataModel.makeLv + 1].AdditionalProbability * 100
      View.Group_Next.Txt_Rise:SetText(nextProbability .. "%")
    else
      View.Group_Next.Txt_Rise:SetText("-")
      View.Img_PlayerInfo.Txt_Profit:SetText("-/-")
      View.Img_PlayerInfo.Img_BP:SetFilledImgAmount(1)
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
