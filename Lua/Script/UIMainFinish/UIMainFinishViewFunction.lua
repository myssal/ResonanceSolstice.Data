local View = require("UIMainFinish/UIMainFinishView")
local DataModel = require("UIMainFinish/UIMainFinishDataModel")
local ViewFunction = {
  MainFinish_Group_Btn_Btn_Furlough_Click = function(btn, str)
    DataModel.TempLeftActivity()
  end,
  MainFinish_Group_Btn_Btn_Revive_Click = function(btn, str)
    if not WitchData.IsCanRevive() then
      CommonTips.OpenTips(80610330)
      return
    end
    DataModel.ReviveActivity()
  end,
  MainFinish_Group_Btn_Btn_Revive_Group_RevivieCost_Btn_Item_Click = function(btn, str)
  end,
  MainFinish_Group_Btn_Btn_Finish_Click = function(btn, str)
    DataModel.AbandonActivity()
  end,
  MainFinish_Img__Btn__Click = function(btn, str)
    View.self:CloseUI()
  end
}
return ViewFunction
