local View = require("UILM_UI/UILM_UIView")
local DataModel = require("UILM_UI/UILM_UIDataModel")
local ViewFunction = require("UILM_UI/UILM_UIViewFunction")
local Luabehaviour = {
  serialize = function()
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
  update = function()
    for i, v in ipairs(DataModel.circleAnim) do
      if DataModel.curFrame >= v.frame.frameStart and DataModel.curFrame <= v.frame.frameEnd then
        local rate = (DataModel.curFrame - v.frame.frameStart) / (v.frame.frameEnd - v.frame.frameStart)
        if 1 < i then
          local beforeNum = 0
          for index = 1, i - 1 do
            beforeNum = beforeNum + DataModel.circleAnim[index].num
          end
          v.ctrl:SetFilledImgAmount(beforeNum / DataModel.totalConsume + v.num / DataModel.totalConsume * rate)
        else
          v.ctrl:SetFilledImgAmount(v.num / DataModel.totalConsume * rate)
        end
      end
    end
    DataModel.curFrame = DataModel.curFrame + 1
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
